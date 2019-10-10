//
//  UITableView+Utils.h
//  DrivingTest
//
//  Created by cheng on 2017/11/21.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Utils)

/*
 * 该 section 之前所有cell的总高度
 */
- (CGFloat)totalHeightForRowToSection:(NSInteger)section target:(id<UITableViewDelegate, UITableViewDataSource>)target;
- (CGFloat)totalHeightForHeaderToSection:(NSInteger)section target:(id<UITableViewDelegate, UITableViewDataSource>)target;
- (CGFloat)totalHeightForFooterToSection:(NSInteger)section target:(id<UITableViewDelegate, UITableViewDataSource>)target;

/*
 * 组合高度 cell, header, footer
 */
- (CGFloat)totalHeightForRowAndHeaderToSection:(NSInteger)section target:(id<UITableViewDelegate, UITableViewDataSource>)target;
- (CGFloat)totalHeightForRowAndFooterToSection:(NSInteger)section target:(id<UITableViewDelegate, UITableViewDataSource>)target;
- (CGFloat)totalHeightForAllToSection:(NSInteger)section target:(id<UITableViewDelegate, UITableViewDataSource>)target;

@end
