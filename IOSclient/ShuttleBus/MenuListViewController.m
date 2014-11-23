//
//  MenuListViewController.m
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/16/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import "MenuListViewController.h"
#import "SideMenuUtil.h"
#import "MenuListCell.h"



#define kSidebarCellTextKey	@"CellText"
#define kSidebarCellImageKey	@"CellImage"

@interface MenuListViewController () {
	NSMutableArray *_headers;	//!< 节头文本.
	
    NSMutableArray *_cellInfos;	//!< 单元格信息.
	NSMutableArray *_controllers;	//!< 导航控制器集.
    
    UIViewController* _homeController;
}

@end

@implementation MenuListViewController;

@synthesize revealController,lineLoadingIcon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) dealloc {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置自身窗口尺寸
    self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    // 绑定主页为内容视图（已废弃，仅用于调试）.
    if (NO) {
        UINavigationController* homeNC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
        NSLog(@"instantiateViewControllerWithIdentifier: %@", homeNC);
        [SideMenuUtil addNavigationGesture:homeNC revealController:revealController];
        //homeNC.revealController = revealController;
        [SideMenuUtil setRevealControllerProperty:homeNC revealController:revealController];
        revealController.contentViewController = homeNC;
    }
    
    // 初始化表格.
    _headers =[[NSMutableArray alloc] init];
    _cellInfos = [[NSMutableArray alloc] init];
    _controllers = [[NSMutableArray alloc] init];

    _homeController=[self.storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(refreshMenu)
     name:@"ServerIPChangeMsg"//表示消息名称，发送跟接收双方都要一致
     object:nil];
    
    
    [self refreshMenu];
    // ui.

}

- (void) refreshMenu {
    
    [_headers removeAllObjects];
    [_cellInfos removeAllObjects];
    [_controllers removeAllObjects];

    
    [_headers addObject:
     [NSNull null]
     ];
    
    [_cellInfos addObject:
     @[
       @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Home", @"")},
       @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Logout", @"")},
       ]
     ];
    
    [_controllers addObject:
     
     @[
       _homeController,@"logout",
       ]
     ];
    
    
    UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    self.view.backgroundColor = bgColor;
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.backgroundColor = [UIColor clearColor];
    
    
    
    [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
    
    // 添加手势.
    for (id obj1 in _controllers) {
        if (nil==obj1) continue;
        for (id obj2 in (NSArray *)obj1) {
            if (nil==obj2) continue;
            [SideMenuUtil setRevealControllerProperty:obj2 revealController:revealController];
            if ([obj2 isKindOfClass:UINavigationController.class]) {
                [SideMenuUtil addNavigationGesture:(UINavigationController*)obj2 revealController:revealController];
            }
        }
    }
    
    [self.menuTableView reloadData];
    
    
    [lineLoadingIcon startAnimating];
    RestRequestor* requstor= [[RestRequestor alloc]init];
    [requstor getBusLineList:self];
    
}
- (void) reportError:(NSString *)errorMsg {
    NSLog(@"REST API call failed, error=%@",errorMsg);
}

- (void) fillBusLinesInfo: (NSArray*) arrayObject {
    
    [_headers removeAllObjects];
    [_cellInfos removeAllObjects];
    [_controllers removeAllObjects];
    
    
    [_headers addObject:
     [NSNull null]
     ];
    
    [_cellInfos addObject:
     @[
       @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Home", @"")},
       ]
     ];
    
    [_controllers addObject:
     
     @[
       _homeController,
       ]
     ];
    
    
    
    UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    self.view.backgroundColor = bgColor;
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.backgroundColor = [UIColor clearColor];
    
    
    
    [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    

    
    
    
    if (arrayObject.count==0) {
        NSLog(@"can't find any ShuttleBus line info from Server!!!");
        return;
    }
    
    
    
    
    [_headers addObject:@""];
    [_headers addObject:@""];
    
    NSMutableArray* infoArray = [[NSMutableArray alloc]init];
    NSMutableArray* ctlArray= [[NSMutableArray alloc]init];
    
    for ( BusLine* busline in arrayObject) {
        
        [infoArray addObject:
         @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(busline.lineName, @"")}
         ];
        
        [ctlArray addObject:
         [self.storyboard instantiateViewControllerWithIdentifier:@"ShuttleBusNavigationController"]
         ];
    }
    
    [_cellInfos addObject:infoArray];
    [_cellInfos addObject:
    @[
      @{kSidebarCellImageKey: [UIImage imageNamed:@"user.png"], kSidebarCellTextKey: NSLocalizedString(@"Logout", @"")},
      ]
    ];

    [_controllers addObject:ctlArray];
    [_controllers addObject:
     @[
       @"logout",
       ]
     ];
    
    
    // 添加手势.
    for (id obj1 in _controllers) {
        if (nil==obj1) continue;
        for (id obj2 in (NSArray *)obj1) {
            if (nil==obj2) continue;
            [SideMenuUtil setRevealControllerProperty:obj2 revealController:revealController];
            if ([obj2 isKindOfClass:UINavigationController.class]) {
                [SideMenuUtil addNavigationGesture:(UINavigationController*)obj2 revealController:revealController];
            }
        }
    }
 
  //refresh UITable
  [self.menuTableView reloadData];
  [lineLoadingIcon stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    // 设置自身窗口尺寸
    self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));

}

#pragma mark - method

// 处理菜单项点击事件.
- (BOOL)onSelectRowAtIndexPath:(NSIndexPath *)indexPath hideSidebar:(BOOL)hideSidebar {
	BOOL rt = NO;
	do {
		if (nil==indexPath) break;
		
		// 获得当前项目.
		id controller = _controllers[indexPath.section][indexPath.row];
		if (nil!=controller) {
			// 命令.
			if ([controller isKindOfClass:NSString.class]) {
				NSString* cmd = controller;
				if ([cmd isEqualToString:@"logout"]) {
					[self cancelButton_selector:nil];
					rt = YES;
					break;
				}
			}
			
			// 页面跳转.
			if ([controller isKindOfClass:UIViewController.class]) {
				rt = YES;
				revealController.contentViewController = controller;
				if (hideSidebar) {
					[revealController toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
				}
			}
		}
	} while (0);
	return rt;
}

/// 选择某个菜单项.
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
	[_menuTableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
	if (scrollPosition == UITableViewScrollPositionNone) {
		[_menuTableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
	}
	[self onSelectRowAtIndexPath:indexPath hideSidebar:NO];
    
    NSDictionary *info = _cellInfos[indexPath.section][indexPath.row];
    NSString* lineName = info[kSidebarCellTextKey];
    
    
	NSLog(@"selectRowAtIndexPath: %@, lineName=%@", revealController.contentViewController,lineName);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _headers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_cellInfos.count==0) return 0;
    
    return ((NSArray *)_cellInfos[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"MenuListCell";
	MenuListCell *cell = (MenuListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[MenuListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	NSDictionary *info = _cellInfos[indexPath.section][indexPath.row];
	cell.textLabel.text = info[kSidebarCellTextKey];
	cell.imageView.image = info[kSidebarCellImageKey];
	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return (_headers[section] == [NSNull null]) ? 0.0f : 21.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSObject *headerText = _headers[section];
	UIView *headerView = nil;
	if (headerText != [NSNull null]) {
		headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 21.0f)];
		CAGradientLayer *gradient = [CAGradientLayer layer];
		gradient.frame = headerView.bounds;
		gradient.colors = @[
                            (id)[UIColor colorWithRed:(67.0f/255.0f) green:(74.0f/255.0f) blue:(94.0f/255.0f) alpha:1.0f].CGColor,
                            (id)[UIColor colorWithRed:(57.0f/255.0f) green:(64.0f/255.0f) blue:(82.0f/255.0f) alpha:1.0f].CGColor,
                            ];
		[headerView.layer insertSublayer:gradient atIndex:0];
		
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)];
		textLabel.text = (NSString *) headerText;
		textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:([UIFont systemFontSize] * 0.8f)];
		textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		textLabel.textColor = [UIColor colorWithRed:(125.0f/255.0f) green:(129.0f/255.0f) blue:(146.0f/255.0f) alpha:1.0f];
		textLabel.backgroundColor = [UIColor clearColor];
		[headerView addSubview:textLabel];
		
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(78.0f/255.0f) green:(86.0f/255.0f) blue:(103.0f/255.0f) alpha:1.0f];
		[headerView addSubview:topLine];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 21.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		bottomLine.backgroundColor = [UIColor colorWithRed:(36.0f/255.0f) green:(42.0f/255.0f) blue:(5.0f/255.0f) alpha:1.0f];
		[headerView addSubview:bottomLine];
	}
	return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self onSelectRowAtIndexPath:indexPath hideSidebar:YES];
	NSLog(@"didSelectRowAtIndexPath: %@", revealController.contentViewController);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)cancelButton_selector:(id)sender {
	if (nil!=revealController) {
		[revealController dismissModalViewControllerAnimated:YES];
	}
	else {
		[self dismissModalViewControllerAnimated:YES];
	}
}


//implement Async

-(NSInteger) getReturnedObjectArray: (NSArray*) objectArray {
   
    [self fillBusLinesInfo:objectArray];
    
    return objectArray.count;
}

@end
