//
//  ClientSettingTabController.m
//  ShuttleBus
//
//  Created by Pujun Wu on 14/11/16.
//  Copyright (c) 2014年 Pujun Wu. All rights reserved.
//

#import "ClientSettingTabController.h"

#import "ShareObject.h"
#import "RestRequestor.h"

@interface ClientSettingTabController ()

@end

@implementation ClientSettingTabController

- (IBAction)showStopInfo:(id)sender {
    
    ShuttleDataStore* dataStore=[ShuttleDataStore instance];
    NSString* lineID= dataStore.clientSetting.lineID;
    
    NSArray * stopArray= [ShuttleAPI getBusLineSchedule:lineID morningOrNight:YES];
    
    
    
    
    
    
    NSString *info=@"";
    NSArray* sortedArray=nil;
    
    if (stopArray==nil)
    {
        info=@"未能获取到班车信息！";
    }
    else
    {
        sortedArray = [stopArray sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
             BusScheduleStopInfo* stop1=obj1;
             BusScheduleStopInfo* stop2=obj2;
            NSString* time1=stop1->time;
            NSString* time2=stop2->time;
            
            NSComparisonResult result=[time1 compare:time2];
            
            switch(result)
            {
                case NSOrderedAscending:
                    return NSOrderedDescending;
                case NSOrderedDescending:
                    return NSOrderedAscending;
                case NSOrderedSame:
                    return NSOrderedSame;
                default:
                    return NSOrderedSame;
            } // 时间从近到远（远近相对当前时间而言）
            
        }];
        
        for(int i=0;i<sortedArray.count;i++)
        {
            BusScheduleStopInfo* stop=[stopArray objectAtIndex:i];
            info= [NSString stringWithFormat:@"%@\n%@\t%@", info,stop->time,stop->name ];
        }
    }
    
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                         
                                                  message:info
                         
                                                 delegate:nil
                         
                                        cancelButtonTitle:@"确定"
                         
                                        otherButtonTitles:nil];
    
    [alert show];
}

@synthesize settingTable,checkEndTime,checkStartTime;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [super viewDidLoad];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section==0) return 4;
    if (section==1) return 1;
    if (section==2) return 3;
    
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addNewCheckWindowClieck:(id)sender {
    NSLog(@"%@,%@,%@",self.userNameLabel.text,self.checkStartTime.text,checkEndTime.text);
    ShuttleDataStore* dataStore=[ShuttleDataStore instance];
    
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [checkEndTime resignFirstResponder];
    [checkStartTime resignFirstResponder];
    [_checkIntervalInMin resignFirstResponder];
    [_serverIPLable resignFirstResponder];
}
@end
