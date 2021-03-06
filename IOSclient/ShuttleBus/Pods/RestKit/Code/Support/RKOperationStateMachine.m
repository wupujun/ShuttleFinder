//
//  RKOperationStateMachine.m
//  RestKit
//
//  Created by Blake Watters on 4/11/13.
//  Copyright (c) 2013 RestKit. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "TransitionKit.h"
#import "RKOperationStateMachine.h"

NSString *const RKOperationFailureException = @"RKOperationFailureException";

static NSString *const RKOperationStateReady = @"Ready";
static NSString *const RKOperationStateExecuting = @"Executing";
static NSString *const RKOperationStateFinished = @"Finished";

static NSString *const RKOperationEventStart = @"start";
static NSString *const RKOperationEventFinish = @"finish";

static NSString *const RKOperationLockName = @"org.restkit.operation.lock";

@interface RKOperationStateMachine ()
@property (nonatomic, strong) TKStateMachine *stateMachine;
@property (nonatomic, weak, readwrite) NSOperation *operation;
@property (nonatomic, assign, readwrite) dispatch_queue_t dispatchQueue;
@property (nonatomic, assign, getter = isCancelled) BOOL cancelled;
@property (nonatomic, copy) void (^cancellationBlock)(void);
@property (nonatomic, strong) NSRecursiveLock *lock;
@end

@implementation RKOperationStateMachine

- (id)initWithOperation:(NSOperation *)operation dispatchQueue:(dispatch_queue_t)dispatchQueue
{
    if (! operation) [NSException raise:NSInvalidArgumentException format:@"Invalid argument: `operation` cannot be nil."];
    if (! dispatchQueue) [NSException raise:NSInvalidArgumentException format:@"Invalid argument: `dispatchQueue` cannot be nil."];
    self = [super init];
    if (self) {
        self.operation = operation;
        self.dispatchQueue = dispatchQueue;
        self.stateMachine = [TKStateMachine new];
        self.lock = [NSRecursiveLock new];
        [self.lock setName:RKOperationLockName];

        // NOTE: State transitions are guarded by a lock via start/finish/cancel action methods
        TKState *readyState = [TKState stateWithName:RKOperationStateReady];
        __weak __typeof(self)weakSelf = self;
        [readyState setWillExitStateBlock:^(TKState *state, TKTransition *transition) {
            [weakSelf.operation willChangeValueForKey:@"isReady"];
        }];
        [readyState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
            [weakSelf.operation didChangeValueForKey:@"isReady"];
        }];

        TKState *executingState = [TKState stateWithName:RKOperationStateExecuting];
        [executingState setWillEnterStateBlock:^(TKState *state, TKTransition *transition) {
            [weakSelf.operation willChangeValueForKey:@"isExecuting"];
        }];
        // NOTE: isExecuting KVO for `setDidEnterStateBlock:` configured below in `setExecutionBlock`
        [executingState setWillExitStateBlock:^(TKState *state, TKTransition *transition) {
            [weakSelf.operation willChangeValueForKey:@"isExecuting"];
        }];
        [executingState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
            [weakSelf.operation didChangeValueForKey:@"isExecuting"];
        }];
        [executingState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
            [NSException raise:NSInternalInconsistencyException format:@"You must configure an execution block via `setExecutionBlock:`."];
        }];

        TKState *finishedState = [TKState stateWithName:RKOperationStateFinished];
        [finishedState setWillEnterStateBlock:^(TKState *state, TKTransition *transition) {
            [weakSelf.operation willChangeValueForKey:@"isFinished"];
        }];
        [finishedState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
            [weakSelf.operation didChangeValueForKey:@"isFinished"];
        }];
        [finishedState setWillExitStateBlock:^(TKState *state, TKTransition *transition) {
            [weakSelf.operation willChangeValueForKey:@"isFinished"];
        }];
        [finishedState setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
            [weakSelf.operation didChangeValueForKey:@"isFinished"];
        }];

        [self.stateMachine addStates:@[ readyState, executingState, finishedState ]];

        TKEvent *startEvent = [TKEvent eventWithName:RKOperationEventStart transitioningFromStates:@[ readyState ] toState:executingState];
        TKEvent *finishEvent = [TKEvent eventWithName:RKOperationEventFinish transitioningFromStates:@[ executingState ] toState:finishedState];
        [self.stateMachine addEvents:@[ startEvent, finishEvent ]];

        self.stateMachine.initialState = readyState;
        [self.stateMachine activate];
    }
    return self;
}

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%@ Failed to call designated initializer. Invoke initWithOperation: instead.",
                                           NSStringFromClass([self class])]
                                 userInfo:nil];
}

- (BOOL)isReady
{
    return [self.stateMachine isInState:RKOperationStateReady];
}

- (BOOL)isExecuting
{
    return [self.stateMachine isInState:RKOperationStateExecuting];
}

- (BOOL)isFinished
{
    return [self.stateMachine isInState:RKOperationStateFinished];
}

- (void)start
{
    if (! self.dispatchQueue) [NSException raise:NSInternalInconsistencyException format:@"You must configure an `operationQueue`."];
    [self performBlockWithLock:^{
        NSError *error = nil;
        BOOL success = [self.stateMachine fireEvent:RKOperationEventStart userInfo:nil error:&error];
        if (! success) [NSException raise:RKOperationFailureException format:@"The operation unexpectedly failed to start due to an error: %@", error];
    }];
}

- (void)finish
{
    // Ensure that we are finished from the operation queue
    dispatch_async(self.dispatchQueue, ^{
        [self performBlockWithLock:^{
            NSError *error = nil;
            BOOL success = [self.stateMachine fireEvent:RKOperationEventFinish userInfo:nil error:&error];
            if (! success) [NSException raise:RKOperationFailureException format:@"The operation unexpectedly failed to finish due to an error: %@", error];
        }];
    });
}

- (void)cancel
{
    if ([self isCancelled] || [self isFinished]) return;
    [self performBlockWithLock:^{
        self.cancelled = YES;
    }];

    if (self.cancellationBlock) {
        dispatch_async(self.dispatchQueue, ^{
            [self performBlockWithLock:self.cancellationBlock];
        });
    }
}

- (void)setExecutionBlock:(void (^)(void))block
{
    __weak __typeof(self)weakSelf = self;
    TKState *executingState = [self.stateMachine stateNamed:RKOperationStateExecuting];
    [executingState setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [weakSelf.operation didChangeValueForKey:@"isExecuting"];
        dispatch_async(weakSelf.dispatchQueue, ^{
            block();
        });
    }];
}

- (void)setFinalizationBlock:(void (^)(void))block
{
    __weak __typeof(self)weakSelf = self;
    TKState *finishedState = [self.stateMachine stateNamed:RKOperationStateFinished];
    [finishedState setWillEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [weakSelf performBlockWithLock:^{
            // Must emit KVO as we are replacing the block configured in `initWithOperation:queue:`
            [weakSelf.operation willChangeValueForKey:@"isFinished"];
            block();
        }];
    }];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p (for %@:%p), state: %@, cancelled: %@>",
            [self class], self,
            [self.operation class], self.operation,
            self.stateMachine.currentState.name,
            ([self isCancelled] ? @"YES" : @"NO")];
}

- (void)performBlockWithLock:(void (^)())block
{
    [self.lock lock];
    block();
    [self.lock unlock];
}

@end
