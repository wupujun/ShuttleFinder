//
//  HomeViewController.h
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/16/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRevealControllerProperty.h"

@interface HomeViewController : UIViewController <IRevealControllerProperty>
- (IBAction)applySettingButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *settingView;

@end
