//
//  ClientSetting.h
//  ShuttleBus
//
//  Created by Pujun Wu on 14/11/22.
//  Copyright (c) 2014年 Pujun Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ClientSetting : NSManagedObject

@property (nonatomic, retain) NSString * serverIP;
@property (nonatomic, retain) NSNumber * port;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * shuttleLine;

@end
