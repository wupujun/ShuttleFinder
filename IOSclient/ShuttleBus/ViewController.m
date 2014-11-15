//
//  ViewController.m
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/16/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "ViewController.h"
#import "MenuListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginShuttleBus:(UIButton *)sender {
    // 获取菜单页面.
    MenuListViewController* menuVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuListViewController"];
    NSLog(@"instantiateViewControllerWithIdentifier: %@", menuVc);
    if (nil==menuVc) return;
    
    // 直接模态弹出菜单页面（已废弃，仅用于调试）.
    if (NO) {
        menuVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;    // 淡入淡出.
        [self presentModalViewController:menuVc animated:YES];
    }
    
    // 模态弹出侧开菜单控制器.
    if (YES) {
        //UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
        UIColor *bgColor = [UIColor whiteColor];
        GHRevealViewController* revealController = [[GHRevealViewController alloc] initWithNibName:nil bundle:nil];
        revealController.view.backgroundColor = bgColor;
        
        // 绑定.
        menuVc.revealController = revealController;
        revealController.sidebarViewController = menuVc;
        
        // show.
        revealController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;    // 淡入淡出.
        [self presentModalViewController:revealController animated:YES];
    }
}
@end
