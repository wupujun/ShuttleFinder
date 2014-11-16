//
//  ClientSettingTabController.h
//  ShuttleBus
//
//  Created by Pujun Wu on 14/11/16.
//  Copyright (c) 2014年 Pujun Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientSettingTabController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *settingTable;
@property (strong, nonatomic) IBOutlet UITextField *checkStartTime;
@property (strong, nonatomic) IBOutlet UITextField *checkEndTime;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *shuttleLineLabel;
@property (strong, nonatomic) IBOutlet UITextField *serverIPLable;
@property (strong, nonatomic) IBOutlet UITextField *checkIntervalInMin;
- (IBAction)addNewCheckWindowClieck:(id)sender;

@end
