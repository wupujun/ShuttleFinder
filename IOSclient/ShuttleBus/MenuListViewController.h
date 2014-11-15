//
//  MenuListViewController.h
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/16/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRevealControllerProperty.h"

//for Rest API
#import "ShareObject.h"
#import "RestRequestor.h"

@interface MenuListViewController : UIViewController <IRevealControllerProperty, UITableViewDataSource, UITableViewDelegate,AsynCallCompletionNotify>

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *lineLoadingIcon;

@end
