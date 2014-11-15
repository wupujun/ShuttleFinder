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

- (NSInteger) getReturnedObjectArray: (NSArray*) objectArray;

@end

@interface RestQueryParamter:NSObject

@property(nonatomic,strong) NSString* uri;
@property(strong,nonatomic) NSString* path;
@property(strong,nonatomic) NSDictionary * fieldMap;
@end

@interface RestRequestor : NSObject


@property (retain,nonatomic) id<AsynCallCompletionNotify> delegate;

//remote mothods
- (void) getBusLineList : (id<AsynCallCompletionNotify>) callbakcObj;
- (void) getReportedBusLineLocation: (NSString*) lineID callback:(id<AsynCallCompletionNotify>) callbakcObj;
- (bool) updateMyLocationToServer: (Location*) myLocation;
//- (void) callRestAPIAndReturnObjAsArray: (NSString*) restURI : mappedClass : (id<AsynCallCompletionNotify>) callback;
- (void) callRestAPIAndReturnObjAsArray: (RestQueryParamter*)queryParamter  class:(Class)mappedClass  callback:(id<AsynCallCompletionNotify>) callbackObj;
//local methods
+ (NSString*) getServerAddress;
- (bool) setServerAddress: (NSString*) serverIP;


@end
