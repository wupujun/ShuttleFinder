//
//  RestRequestor.h
//  BusFinder
//
//  Created by Pujun Wu on 14/11/9.
//  Copyright (c) 2014年 Pujun Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "ShareObject.h"
#import "ShuttleAPI.h"

@protocol AsynCallCompletionNotify <NSObject>

- (NSInteger) getReturnedObjectArray: (NSArray*) objectArray;
- (void) reportError:(NSString*) errorMsg;

@end

@interface RestQueryParamter:NSObject

@property(nonatomic,strong) NSString* uri;
@property(nonatomic,strong) NSString* serverURL;
@property(strong,nonatomic) NSString* path;
@property(strong,nonatomic) NSDictionary * fieldMap;
@property(strong,nonatomic) NSDictionary * postMap;
@property(strong,nonatomic) NSDictionary * getMap;
@end

@interface RestRequestor : NSObject {
    NSString* _serverURL;
}

@property (retain,nonatomic) id<AsynCallCompletionNotify> delegate;

//remote mothods
- (void) getReportedBusLineLocation: (NSString*) lineID callback:(void(^) (NSArray*, bool) ) callbackFun;
- (bool) updateMyLocationToServer:(NSString*) line location:(BusLocationInfo*) myLocation callback:(void(^) (NSArray*, bool) ) callbackFun;
- (void) getBusLineSchedule:(NSString*) lineID callback:(void(^) (NSArray*, bool) ) callbackFun;

//remote motheds with bloack for callback
- (void) getAllBusline: (void (^)(NSArray* objArray,bool)) callbackFun;

//local methods
- (NSString*) getServerURL;
- (bool) setServerURL: (NSString*) serverURL;

@end
