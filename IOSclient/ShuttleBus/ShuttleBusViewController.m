//
//  ShuttleBusViewController.m
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/17/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "ShuttleBusViewController.h"
#import "MarkPoint.h"
#import "ShareObject.h"


@interface ShuttleBusViewController ()
{
    //NSTimer * shuttleQuerytimer;
    bool isQueryInprogress;
    MyLocation *_myPoint;
}
@end

@implementation ShuttleBusViewController

@synthesize revealController;
@synthesize mapView;
@synthesize longitudeValue;
@synthesize latitudeValue;

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
    // Do any additional setup after loading the view.
    
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    
    
    ShuttleDataStore* dataStore=[ShuttleDataStore instance];
    
    
    CLLocationManager *locationManager = dataStore.locationManager;
    if (locationManager==nil)
        dataStore.locationManager= [[CLLocationManager alloc] init];//创建位置管理器
    
    locationManager = dataStore.locationManager;
    
    locationManager.delegate=self;//设置代理
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
    //locationManager.distanceFilter=kCLDistanceFilterNone;//设置距离筛选器
    locationManager.distanceFilter = 10;
    
    //[locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];//启动位置管理器
    
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    //mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    //[mapView setShowsUserLocation:YES];

    isQueryInprogress=false;
    
    
    
    NSInteger checkInterval= dataStore.clientSetting.freshInterval;
    
    if (checkInterval<=0) checkInterval=60;
    
    [self performSelector:@selector(queryShuttleLocation) withObject:nil afterDelay:checkInterval ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location=[locations firstObject];
    CLLocationCoordinate2D loc = [location coordinate];
 
    NSLog(@"update location (%f,%f)", loc.longitude,loc.latitude);
  
    RestRequestor * req= [[RestRequestor alloc] init];
    Location* aLoc=[[Location alloc] init];
    aLoc.longitude=[NSString stringWithFormat:@"%f",loc.longitude];
    aLoc.latitude=[NSString stringWithFormat:@"%f",loc.latitude];
    aLoc.reportedUserID= @"user1";
    aLoc.reportedTime=@"00:00:00";

    [req updateMyLocationToServer:aLoc callback:self];

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

- (IBAction)markYourPosition:(UIButton *)sender {
    //创建CLLocation 设置经纬度
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.latitudeValue longitude:self.longitudeValue];
    CLLocationCoordinate2D coord = [loc coordinate];
    //创建标题
    NSString *titile = [NSString stringWithFormat:@"%f,%f",coord.latitude,coord.longitude];
    MarkPoint *markPoint = [[MarkPoint alloc] initWithCoordinate:coord andTitle:titile];
    //添加标注
    [self.mapView addAnnotation:markPoint];
    
    //放大到标注的位置
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    [self.mapView setRegion:region animated:YES];
}

//queryShuttle bus location
-(void) queryShuttleLocation {
    
    if (isQueryInprogress) {
        NSLog(@"the last Query isn't finished, skip it");
        return;
    }
    
    NSLog(@"start to query the shuttle bus location");
    RestRequestor * req= [[RestRequestor alloc] init];
    [req getReportedBusLineLocation:@""  callback:self];
}

- (void) reportError:(NSString *)errorMsg {
    NSLog(@"REST API call failed, error=%@",errorMsg);
}


- (NSInteger) getReturnedObjectArray: (NSArray*) objectArray {
    
    if (objectArray==nil || objectArray.count<1) return 0;
    
    Location *lastPos=objectArray.lastObject;
    NSLog(@"lat=%@,long=%@", lastPos.latitude,lastPos.longitude);
    isQueryInprogress=false;
    
    
    MKCoordinateSpan theSpan = MKCoordinateSpanMake(0.14,0.14);
    theSpan.latitudeDelta = 0.01;
    theSpan.longitudeDelta = 0.01;
    CLLocationCoordinate2D center= CLLocationCoordinate2DMake([lastPos.latitude doubleValue], [lastPos.longitude doubleValue]);
    MKCoordinateRegion theRegion= MKCoordinateRegionMakeWithDistance(center, 250, 250);
    
    
    theRegion.span = theSpan;
    [self.mapView setRegion:theRegion];
    //把当前位置设为中心
    [mapView regionThatFits:theRegion];
    
    [mapView removeAnnotation:_myPoint];
    
    NSString *titile = [NSString stringWithFormat:@"%@,%@",lastPos.latitude,lastPos.longitude];
    _myPoint = [[MyLocation alloc] initWithCoordinate:center andTitle:titile];
    //添加标注
    NSLog(@"New Location=%@",titile);
    [mapView addAnnotation:_myPoint];

    ShuttleDataStore* dataStore=[ShuttleDataStore instance];
    NSInteger checkInterval= dataStore.clientSetting.freshInterval;
    [self performSelector:@selector(queryShuttleLocation) withObject:nil afterDelay:checkInterval ];
    //shuttleQuerytimer.timeInterval=checkInterval;
    
    return objectArray.count;
}
@end
