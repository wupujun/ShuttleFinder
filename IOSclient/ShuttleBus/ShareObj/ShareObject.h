//
//  ShareObject.h
//  Locator
//
//  Created by Pujun Wu on 14/11/2.
//  Copyright (c) 2014年 Pujun Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKMapView.h>
#import "MapKit/MapKit.h"

@interface ResultObject : NSObject

@property (copy,nonatomic) NSString* status;
@property (copy,nonatomic) NSString* dataType;
@property (copy,nonatomic) NSString* errorMsg;
@property (copy,nonatomic) NSMutableArray *returnObject;

@end

@interface Location : NSObject
@property (strong,nonatomic) NSString* latitude;
@property (strong,nonatomic) NSString* longitude;
@property (strong,nonatomic) NSString* reportedUserID;
@property (strong,nonatomic) NSString* reportedTime;
@property (strong,nonatomic) NSString* locationName;

@end


@interface BusLine: NSObject

@property (strong,nonatomic) NSString* driverName;
@property (strong,nonatomic) NSString* lineName;
@property (strong,nonatomic) NSArray* stopList;
@property (strong,nonatomic) Location* lastLocation;

@end

@interface ShuttleStop: NSObject

@property (nonatomic) time_t arrTime;
@property (copy,nonatomic) NSString* stopName;

@end

@interface MyLocation : NSObject<MKAnnotation>


//实现MKAnnotation协议必须要定义这个属性
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
//标题
@property (nonatomic,copy) NSString *title;

//初始化方法
-(id)initWithCoordinate:(CLLocationCoordinate2D)c andTitle:(NSString*)t;

@end

//global dataStore
@interface ShuttleDataStore : NSObject

@property (strong,nonatomic) NSMutableArray* busLines;

+(id) instance;
@end
