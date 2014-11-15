//
//  SideMenuUtil.h
//  ShuttleBus
//
//  Created by LiuWeiMac on 8/16/14.
//  Copyright (c) 2014 TR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRevealControllerProperty.h"

@interface SideMenuUtil : NSObject

/**
 *	@brief	设置revealController属性.
 *
 * - 若有IRevealControllerProperty接口，便用该接口赋值.
 * - 若是UINavigationController，则自动为其中的页面赋值.
 *
 *	@param 	obj 	需要设置revealController属性的对象.
 *	@param 	revealController 	侧开菜单控制器.
 *
 *	@return	若设置成功（或部分成功）时，则返回原obj。若全部失败，返回nil;
 */
+ (id)setRevealControllerProperty:(id)obj revealController:(GHRevealViewController*)revealController;


/**
 *	@brief	添加导航手势.
 *
 *	@param 	navigationController 	导航控制器.
 *	@param 	revealController 	侧开菜单控制器.
 *
 *	@return	成功时返回YES，失败时返回NO.
 */
+ (BOOL)addNavigationGesture:(UINavigationController*)navigationController revealController:(GHRevealViewController*)revealController;

@end
