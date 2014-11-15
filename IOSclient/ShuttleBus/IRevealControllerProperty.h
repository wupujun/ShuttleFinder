//
//  IRevealControllerProperty.h
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/16/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHRevealViewController.h"

@protocol IRevealControllerProperty <NSObject>

@property (nonatomic, weak) GHRevealViewController* revealController;

@end
