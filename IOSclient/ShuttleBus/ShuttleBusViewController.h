//
//  ShuttleBusViewController.h
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/17/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRevealControllerProperty.h"
#import <MapKit/MapKit.h>

//for Rest API
#import "RestRequestor.h"

@interface ShuttleBusViewController : UIViewController <IRevealControllerProperty, CLLocationManagerDelegate,MKMapViewDelegate,AsynCallCompletionNotify>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;

@property (assign, nonatomic) float longitudeValue;
@property (assign, nonatomic) float latitudeValue;

@end
