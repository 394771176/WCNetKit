//
//  UINavigationController+PopAfterPush.h
//  QueryViolations
//
//  Created by ali on 14-10-17.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 push以后，pop掉上一个controler
 */
@interface UINavigationController (PopAfterPush)

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated complete:(void (^)(void))complete;

- (void)pushViewControllerWithPopOneController:(UIViewController *)viewController;
- (void)pushViewControllerWithPopOneController:(UIViewController *)viewController AndAnimated:(BOOL)animated;

- (void)pushViewControllerWithPopRootController:(UIViewController *)viewController;
- (void)pushViewControllerController:(UIViewController *)viewController withPopToController:(Class)popClass;
- (void)pushViewControllerController:(UIViewController *)viewController withPopToIndex:(NSInteger)index;
//跳转页面时 移除队列指定class的vc
- (void)pushViewController:(UIViewController *)viewController withPopControllerClass:(Class)popClass;
- (void)addControllerToBackActionIndex:(UIViewController *)controller;

- (id)findControllerWithControllerClass:(Class)controllerClass;
- (id)findControllerWithControllerClass:(Class)controllerClass compareBlock:(BOOL (^)(id controller))compareBlock;

@end
