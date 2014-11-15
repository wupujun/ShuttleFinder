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

@protocol AsynCallCompletionNotify <NSObject>

- (NSInteger) setObjectArray: (NSArray*) objectArray;

@end

@interface RestRequestor : NSObject


@property (retain,nonatomic) id<AsynCallCompletionNotify> delegate;

//remote mothods
- (void) getBusLineList : (id<AsynCallCompletionNotify>) callbakcObj;
- (Location*) getReportedBusLineLocation: (NSString*) lineID;
- (bool) updateMyLocationToServer: (Location*) myLocation;
- (void) callRestAPIAndReturnObjAsArray: (NSString*) restURI : (Class) mappedClass : (id<AsynCallCompletionNotify>) callback;

//local methods
+ (NSString*) getServerAddress;
- (bool) setServerAddress: (NSString*) serverIP;


@end
