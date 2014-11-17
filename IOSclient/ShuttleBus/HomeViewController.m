//
//  HomeViewController.m
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/16/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "HomeViewController.h"
#import "ClientSettingTabController.h"

#import "ShareObject.h"


@interface HomeViewController () {
    ClientSettingTabController *_clientSettingView;
}

@end

@implementation HomeViewController

@synthesize revealController,settingView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)showLeftMenu:(id)sender {
    [self.revealController toggleSidebar:!self.revealController.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}

- (IBAction)applySettingButtonClick:(id)sender {
    NSString* ipAddress= _clientSettingView.serverIPLable.text;
    NSInteger freshInterview=[_clientSettingView.checkIntervalInMin.text floatValue]*60;
    
    ShuttleDataStore* dataStore=[ShuttleDataStore instance];
    
    NSLog(@"change server ip/port from %@ to %@",dataStore.clientSetting.serverIPPort, ipAddress);
    NSLog(@"change server ip/port from %d to %d",dataStore.clientSetting.freshInterval, freshInterview);
    dataStore.clientSetting.serverIPPort = ipAddress;
    dataStore.clientSetting.freshInterval = freshInterview;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    _clientSettingView= (ClientSettingTabController*)  segue.destinationViewController;
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self resignFirstResponder];
}

@end
