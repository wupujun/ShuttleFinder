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


