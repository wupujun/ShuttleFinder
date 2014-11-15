//
//  ShareObject.m
//  Locator
//
//  Created by Pujun Wu on 14/11/2.
//  Copyright (c) 2014年 Pujun Wu. All rights reserved.
//

#import "ShareObject.h"

@implementation ResultObject

@synthesize status,errorMsg, dataType,returnObject;


@end

@implementation Location

@synthesize longitude,latitude,reportedTime,reportedUserID;

@end



@implementation BusLine

@synthesize driverName,lineName, stopList;




@end

@implementation MyLocation

@synthesize coordinate=_coordinate,title=_title;


-(id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString *)t{
    self = [super init];
    if(self){
        _coordinate = c;
        _title = t;
    }
    return self;
}

@end

static ShuttleDataStore *_instance=nil;

@implementation ShuttleDataStore

@synthesize busLines;

+ (id) instance{
    @synchronized(self) {
        if (_instance==nil) {
            _instance= [[self alloc] init];
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            return _instance;
        }
    }
    return nil;
}

//copy返回单例本身
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end


