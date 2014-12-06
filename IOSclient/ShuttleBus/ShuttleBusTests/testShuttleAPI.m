//
//  testShuttleAPI.m
//  ShuttleBus
//
//  Created by Pujun Wu on 14/11/28.
//  Copyright (c) 2014年 Pujun Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ShuttleAPI.h"


/*
 + (void) setServerURL:(NSString*) serverURL;
 + (NSString*) getServerURL;
 
 + (NSArray*) getAllBusInfo;
 
 + (NSArray*) getBusInfo: (NSString*) line;
 
 + (NSArray*) getBusLineSchedule: (NSString*) line
 morningOrNight: (bool) isMorning;
 
 + (bool) uploadBusLocation: (NSString*) line
 morningOrNight: (bool) isMorning
 busLocationInfo: (BusLocationInfo*) info;
 
 + (NSArray*) getBusLocation: (NSString*) line
 morningOrNight: (bool) isMorning
 userId: (NSString*) userId
 time: (NSString*) time; // Format: 2011-08-26 05:41:06 +0000
 */

@interface testShuttleAPI : XCTestCase

@end

@implementation testShuttleAPI

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_getAllBusInfoAsync {

    __block NSArray* busArray=nil;
    
    dispatch_semaphore_t _sema = dispatch_semaphore_create(0);
    
    void(^callback)(NSArray*,bool) = ^(NSArray* objArray, bool isError) {
        NSLog(@"get %d returned objects",objArray.count);
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
    XCTAssertNotNil(busArray);
    XCTAssertGreaterThan(busArray.count, 0);
    
}

- (void) test_getAllBusInfo {
    [ShuttleAPI setServerURL:@"127.0.0.1:8080"];
    NSArray * busArray= [ShuttleAPI getAllBusInfo];
    XCTAssertNotNil(busArray);
    XCTAssertGreaterThan(busArray.count, 0);
}


- (void) test_getBusLineSchedule {
    [ShuttleAPI setServerURL:@"127.0.0.1:8080"];
    NSArray * stopArray= [ShuttleAPI getBusLineSchedule:@"西线2号线" morningOrNight:YES];
    XCTAssertNotNil(stopArray);
    XCTAssertGreaterThan(stopArray.count, 0);
}


- (void) test_getBusLocation {
    [ShuttleAPI setServerURL:@"127.0.0.1:8080"];
    [self test_uploadBusLocation];
    
    NSArray* locatons=[ShuttleAPI getBusLocation:@"东线班车1号线" morningOrNight:YES userId:@"user1" time:nil];
    XCTAssertTrue([locatons count]>0);
}

- (void) test_uploadBusLocation {
    
    [ShuttleAPI setServerURL:@"127.0.0.1:8080"];
    BusLocationInfo *loc=[[BusLocationInfo alloc] init];
    loc->longitude=-122.4028534;
    loc->latitude=37.75193292;
    loc->altitude=0.0;
    loc->userID=@"testUser";
    loc->time=@"2014-11-30 12:10:57";
    bool isOK=[ShuttleAPI uploadBusLocation:@"东线班车1号线" morningOrNight:YES busLocationInfo:loc];
    XCTAssertTrue(isOK);
    
}


- (void)test_uploadBusLocationAsync {
    // This is an example of a performance test case.
    
    [ShuttleAPI setServerURL:@"127.0.0.1:8080"];
    
    
    __block NSArray* busArray=nil;
    __block bool uploadError=YES;
    
    dispatch_semaphore_t _sema = dispatch_semaphore_create(0);
    
    void(^callback)(NSArray*,bool) = ^(NSArray* objArray, bool isError) {
        NSLog(@"post %d returned objects",objArray.count);
        busArray=objArray;
        uploadError=isError;
        dispatch_semaphore_signal(_sema);
    };
    
    BusLocationInfo *loc=[[BusLocationInfo alloc] init];
    loc->longitude=-122.4028534;
    loc->latitude=37.75193292;
    loc->altitude=0.0;
    loc->userID=@"testUser";
    loc->time=@"2014-11-30 12:10:57";
    NSTimeInterval checkEveryInterval = 0.05;
    
    dispatch_queue_t mainq=dispatch_get_main_queue();
    
    dispatch_async(mainq, ^(void) {
        [ShuttleAPI uploadBusLocationAsync:@"东线班车1号线" morningOrNight:YES busLocationInfo:loc callback:callback];

    });
    
    while(YES)
    {
        long ret=dispatch_semaphore_wait(_sema, DISPATCH_TIME_NOW );
        if (ret==0) break;
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:checkEveryInterval]];
    }
    XCTAssertFalse(uploadError);

}

@end
