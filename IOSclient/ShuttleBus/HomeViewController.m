//  HomeViewController.m
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/16/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "CoreData/ClientSetting.h"

#import "HomeViewController.h"
#import "ClientSettingTabController.h"

#import "ShareObject.h"


@interface HomeViewController () {
    ClientSettingTabController *_clientSettingView;
    NSManagedObjectContext *_context;
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
    
    ShuttleDataStore* dataStore=[ShuttleDataStore instance];
    
    _clientSettingView.serverIPLable.text =dataStore.clientSetting.serverIPPort;
    _clientSettingView.userNameLabel.text = dataStore.clientSetting.userName;
    _clientSettingView.checkIntervalInMin.text=[NSString stringWithFormat:@"%d", dataStore.clientSetting.freshInterval];
    //NSInteger freshInterview=[ floatValue]*1;
    
    
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
    
    //id menuController=[self valueForKey:@"KeyForMenuRefresh"];
    
    //[menuController performSelector:@selector(refreshMenu)];

    [self.revealController toggleSidebar:!self.revealController.sidebarShowing duration:kGHRevealSidebarDefaultAnimationDuration];
}

- (IBAction)applySettingButtonClick:(id)sender {
    NSString* ipAddress= _clientSettingView.serverIPLable.text;
    NSInteger freshInterview=[_clientSettingView.checkIntervalInMin.text floatValue]*1;
    //NSString* lineID= _clientSettingView.shuttleLineLabel.text;
    
    ShuttleDataStore* dataStore=[ShuttleDataStore instance];
    
    NSLog(@"change server ip/port from %@ to %@",dataStore.clientSetting.serverIPPort, ipAddress);
    NSLog(@"fresh frequenct from %d to %d",dataStore.clientSetting.freshInterval, freshInterview);
    dataStore.clientSetting.serverIPPort = ipAddress;
    dataStore.clientSetting.freshInterval = freshInterview;
    //dataStore.clientSetting.lineID=lineID;
    
    [dataStore saveToLocal];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ServerIPChangeMsg" object:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    _clientSettingView= (ClientSettingTabController*)  segue.destinationViewController;
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self resignFirstResponder];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    ShuttleDataStore* dataStore=[ShuttleDataStore instance];
    _clientSettingView.shuttleLineLabel.text=dataStore.clientSetting.lineID;
}

- (void)viewWillAppear:(BOOL)animated {
    ShuttleDataStore* dataStore=[ShuttleDataStore instance];
    _clientSettingView.shuttleLineLabel.text=dataStore.clientSetting.lineID;
    NSLog(@"HomeView will show!");
    
}


@end
