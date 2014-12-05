//
//  ShuttleAPI.m
//  ShuttleBus
//
//  Created by Pujun Wu on 14/11/28.
//  Copyright (c) 2014年 Pujun Wu. All rights reserved.
//

#import "ShuttleAPI.h"
#import "RestRequestor.h"

@implementation BusInfo


@end

@implementation BusLocationInfo


@end

@implementation ShuttleAPI

static NSString* _serverURL=nil;

+ (void) setServerURL:(NSString*) serverURL {

    _serverURL=serverURL;
}

+ (NSString*) getServerURL {
    return _serverURL;
}


+ (void) getAllBusInfoAsync: (void(^)(NSArray*,bool) )callbackFun {
    
    RestRequestor *req= [[RestRequestor alloc]init];
    [req setServerURL: [ShuttleAPI getServerURL]];
        
    [req getAllBusline:callbackFun];
    
    return;
    
}

+ (NSArray*) getAllBusInfo {
    
 
    __block NSArray* busArray=nil;
    
    dispatch_semaphore_t _sema = dispatch_semaphore_create(0);
    
    void(^callback)(NSArray*,bool) = ^(NSArray* objArray,bool isError) {
        NSLog(@"getAllBusInfoASync returned with %d objects",objArray.count);
        busArray=objArray;
        dispatch_semaphore_signal(_sema);
    };
    
    NSTimeInterval checkEveryInterval = 0.05;
    dispatch_queue_t mainq=dispatch_get_main_queue();
    dispatch_async(mainq, ^(void) {
        [ShuttleAPI getAllBusInfoAsync:callback];
    });
    
    while(YES)
    {
        long ret=dispatch_semaphore_wait(_sema, DISPATCH_TIME_NOW );
        if (ret==0) break;
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:checkEveryInterval]];
    }
    
    return busArray;
    
}

+ (BusInfo*) getBusInfo: (NSString*) line {
   
    
    return nil;
    
}

+ (NSArray*) getBusLineSchedule: (NSString*) line
                 morningOrNight: (bool) isMorning {
    return nil;
    
}

+ (bool) uploadBusLocation: (NSString*) line
            morningOrNight: (bool) isMorning
           busLocationInfo: (BusLocationInfo*) info {

    __block bool isOK=NO;
    __block NSArray* busArray=nil;
    
    dispatch_semaphore_t _sema = dispatch_semaphore_create(0);
    
    void(^callback)(NSArray*,bool) = ^(NSArray* objArray,bool isError) {
        NSLog(@"uploadBusLocation returned with %d objects",objArray.count);
        busArray=objArray;
        isOK=!isError;
        dispatch_semaphore_signal(_sema);
    };
    
    NSTimeInterval checkEveryInterval = 0.05;
    dispatch_queue_t mainq=dispatch_get_main_queue();
    dispatch_async(mainq, ^(void) {
        [ShuttleAPI uploadBusLocationAsync:line morningOrNight:isMorning
                           busLocationInfo:info
                                  callback:callback];
    });
    
    while(YES)
    {
        long ret=dispatch_semaphore_wait(_sema, DISPATCH_TIME_NOW );
        if (ret==0) break;
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:checkEveryInterval]];
    }
    
    return isOK;
}

+ (bool) uploadBusLocationAsync: (NSString*) line
            morningOrNight: (bool) isMorning
           busLocationInfo: (BusLocationInfo*) info
                  callback: (void(^)(NSArray*,bool) )callbackFun {
    
            RestRequestor *req= [[RestRequestor alloc]init];
            [req setServerURL: [ShuttleAPI getServerURL]];
    
    [req updateMyLocationToServer:line location:info callback:callbackFun];
    
    
    
    return YES;
}

+ (NSArray*) getBusLocation: (NSString*) line
             morningOrNight: (bool) isMorning
                     userId: (NSString*) userID
                       time: (NSString*) time {
    
    __block NSArray* busArray=nil;
    
    dispatch_semaphore_t _sema = dispatch_semaphore_create(0);
    
    void(^callback)(NSArray*,bool) = ^(NSArray* objArray,bool isError) {
        NSLog(@"uploadBusLocation returned with %d objects",objArray.count);
        busArray=objArray;
        dispatch_semaphore_signal(_sema);
    };
    
    NSTimeInterval checkEveryInterval = 0.05;
    dispatch_queue_t mainq=dispatch_get_main_queue();
    dispatch_async(mainq, ^(void) {
        [ShuttleAPI getBusLocationAsync:line morningOrNight:isMorning userId:userID time:time
                                  callback:callback];
    });
    
    while(YES)
    {
        long ret=dispatch_semaphore_wait(_sema, DISPATCH_TIME_NOW );
        if (ret==0) break;
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:checkEveryInterval]];
    }
    
    
    
    return busArray;
    
}

+ (void) getBusLocationAsync: (NSString*) line
             morningOrNight: (bool) isMorning
                     userId: (NSString*) userID
                       time: (NSString*) time
                   callback: (void(^)(NSArray*,bool) )callbackFun {
    
        RestRequestor *req= [[RestRequestor alloc]init];
        [req setServerURL: [ShuttleAPI getServerURL]];
    
        [req getReportedBusLineLocation:line callback:callbackFun];
}


@end
