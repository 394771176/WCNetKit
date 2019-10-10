//
//  UINavigationController+PopAfterPush.m
//  QueryViolations
//
//  Created by ali on 14-10-17.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "UINavigationController+PopAfterPush.h"
#import "WCCategory.h"

@implementation UINavigationController (PopAfterPush)

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated complete:(void (^)(void))complete
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:complete];
    [self pushViewController:viewController animated:animated];
    [CATransaction commit];
}

- (void)pushViewControllerWithPopOneController:(UIViewController *)viewController
{
    [self pushViewControllerWithPopOneController:viewController AndAnimated:YES];
}

- (void)pushViewControllerWithPopOneController:(UIViewController *)viewController AndAnimated:(BOOL)animated
{
    __block id controller = [self.viewControllers lastObject];
    [self pushViewController:viewController animated:animated complete:^{
        NSMutableArray *controllerList = [self.viewControllers mutableCopy];
        if (controller!=[controllerList firstObject]) {
            [controllerList removeObject:controller];
            self.viewControllers = [NSArray arrayWithArray:controllerList];
        }
    }];
}

- (void)pushViewControllerWithPopRootController:(UIViewController *)viewController
{
    __block NSInteger index = self.viewControllers.count - 1;
    [self pushViewController:viewController animated:YES complete:^{
        NSMutableArray *controllerList = [self.viewControllers mutableCopy];
        while (index > 0) {
            [controllerList removeObjectAtIndex:index];
            index --;
        }
        self.viewControllers = [NSArray arrayWithArray:controllerList];
    }];
}

- (void)pushViewControllerController:(UIViewController *)viewController withPopToController:(Class)popClass
{
    NSMutableArray *controllerList = [self.viewControllers mutableCopy];
    for (int i=0; i<controllerList.count - 1; i++) {
        UIViewController *vc = [controllerList safeObjectAtIndex:i];
        if ([vc isKindOfClass:popClass]) {
            [self pushViewControllerController:viewController withPopToIndex:i];
            return;
            break;
        }
    }
    
    //如果未找到 直接push
    [self pushViewController:viewController animated:YES];
}

- (void)addControllerToBackActionIndex:(UIViewController *)controller
{
    if (!controller) {
        return;
    }
    NSArray *controlls = self.viewControllers;
    if (controlls.count <= 1) {
        return;
    }
    NSMutableArray *newControlls = [NSMutableArray arrayWithArray:controlls];
    [newControlls insertObject:controller atIndex:controlls.count-1];
    self.viewControllers = newControlls;
}

- (void)pushViewControllerController:(UIViewController *)viewController withPopToIndex:(NSInteger)index
{
    [self pushViewController:viewController animated:YES complete:^{
        NSMutableArray *controllerList = [self.viewControllers mutableCopy];
        if (index>=0&&controllerList.count>index+2) {
            [controllerList removeObjectsInRange:NSMakeRange(index+1, controllerList.count-index-2)];
            self.viewControllers = [NSArray arrayWithArray:controllerList];
        }
    }];
}

//跳转页面时 移除队列指定class的vc
- (void)pushViewController:(UIViewController *)viewController withPopControllerClass:(Class)popClass
{
    __block NSUInteger index = self.viewControllers.count - 1;
    [self pushViewController:viewController animated:YES complete:^{
        NSMutableArray *controllerList = [self.viewControllers mutableCopy];
        while (index > 0) {
            UIViewController *vc = [controllerList safeObjectAtIndex:index];
            if ([vc isKindOfClass:popClass]) {
                [controllerList removeObjectAtIndex:index];
                self.viewControllers = [NSArray arrayWithArray:controllerList];
            }
            index --;
        }
    }];
}

- (id)findControllerWithControllerClass:(Class)controllerClass
{
    return [self findControllerWithControllerClass:controllerClass compareBlock:nil];
}

- (id)findControllerWithControllerClass:(Class)controllerClass compareBlock:(BOOL (^)(id controller))compareBlock
{
    NSArray *controllerList = self.viewControllers;
    id result = nil;
    for (int i=0; i<controllerList.count-1; i++) {
        id controller = [controllerList safeObjectAtIndex:i];
        if ([controller isKindOfClass:controllerClass]) {
            if (compareBlock) {
                if (compareBlock(controller)) {
                    result = controller;
                    break;
                }
            } else {
                result = controller;
                break;
            }
        }
    }
    return result;
}

@end
