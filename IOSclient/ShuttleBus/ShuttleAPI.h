//
//  ShuttleAPI.h
//  ShuttleBus
//
//  Created by Pujun Wu on 14/11/28.
//  Copyright (c) 2014年 Pujun Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusInfo : NSObject
{
@public
    
    NSString* busLine;  // 班车线路名称比如Line1, Line2
    int seatCount;  // 座位数
    NSString* license;  // 拍照
    NSString* driver;  // 司机姓名
    NSString* phone;  // 电话号码
}
@end

@interface BusLocationInfo : NSObject
{
@public
    double longitude;
    double latitude;
    double altitude;
    NSString* time; // Format: 2011-08-26 05:41:06 +0000
    NSString* userID;
}
@end


@interface BusScheduleStopInfo : NSObject
{
    double longitude;
    double latitude;
    double altitude;
    NSString* name;
    NSString* time;
}
@end



@interface ShuttleAPI : NSObject {
}

+ (void) setServerURL:(NSString*) serverURL;
+ (NSString*) getServerURL;

+ (void) getAllBusInfoAsync:(void(^)(NSArray*,bool)) callback;
+ (NSArray*) getAllBusInfo;

+ (NSArray*) getBusInfo: (NSString*) line;

+ (NSArray*) getBusLineSchedule: (NSString*) line
                 morningOrNight: (bool) isMorning;

+ (bool) uploadBusLocation: (NSString*) line
            morningOrNight: (bool) isMorning
           busLocationInfo: (BusLocationInfo*) info;

+ (bool) uploadBusLocationAsync: (NSString*) line
            morningOrNight: (bool) isMorning
           busLocationInfo: (BusLocationInfo*) info
           callback:(void(^)(NSArray* arrayObject,bool isError))callbackFun;


+ (NSArray*) getBusLocation: (NSString*) line
             morningOrNight: (bool) isMorning
                     userId: (NSString*) userId
                       time: (NSString*) time; // Format: 2011-08-26 05:41:06 +0000

@end

