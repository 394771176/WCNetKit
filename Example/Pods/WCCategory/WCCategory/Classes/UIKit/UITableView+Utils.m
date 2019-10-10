//
//  UITableView+Utils.m
//  DrivingTest
//
//  Created by cheng on 2017/11/21.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "UITableView+Utils.h"

@implementation UITableView (Utils)

- (CGFloat)totalHeightForRowToSection:(NSInteger)section target:(id<UITableViewDelegate, UITableViewDataSource>)target
{
    CGFloat lastBottom = 0.f;
    if ([target respondsToSelector:@selector(tableView:numberOfRowsInSection:)] && [target respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        for (NSInteger sec = 0; sec < section; sec ++) {
            NSInteger rowCount = [target tableView:self numberOfRowsInSection:sec];
            for (NSInteger row = 0; row < rowCount; row ++ ) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sec];
                lastBottom += ([target tableView:self heightForRowAtIndexPath:indexPath]);
            }
        }
    }
    return lastBottom;
}

- (CGFloat)totalHeightForHeaderToSection:(NSInteger)section target:(id<UITableViewDelegate,UITableViewDataSource>)target
{
    CGFloat lastBottom = 0.f;
    if ([target respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        for (NSInteger sec = 0; sec < section; sec ++) {
            lastBottom += ([target tableView:self heightForHeaderInSection:sec]);
        }
    }
    return lastBottom;
}

- (CGFloat)totalHeightForFooterToSection:(NSInteger)section target:(id<UITableViewDelegate,UITableViewDataSource>)target
{
    CGFloat lastBottom = 0.f;
    if ([target respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        for (NSInteger sec = 0; sec < section; sec ++) {
            lastBottom += ([target tableView:self heightForFooterInSection:sec]);
        }
    }
    return lastBottom;
}

- (CGFloat)totalHeightForAllToSection:(NSInteger)section target:(id<UITableViewDelegate,UITableViewDataSource>)target
{
    return [self totalHeightForRowToSection:section target:target withHeader:YES withFooter:YES];
}

- (CGFloat)totalHeightForRowAndHeaderToSection:(NSInteger)section target:(id<UITableViewDelegate,UITableViewDataSource>)target
{
    return [self totalHeightForRowToSection:section target:target withHeader:YES withFooter:NO];
}

- (CGFloat)totalHeightForRowAndFooterToSection:(NSInteger)section target:(id<UITableViewDelegate,UITableViewDataSource>)target
{
    return [self totalHeightForRowToSection:section target:target withHeader:NO withFooter:YES];
}

- (CGFloat)totalHeightForRowToSection:(NSInteger)section target:(id<UITableViewDelegate,UITableViewDataSource>)target withHeader:(BOOL)header withFooter:(BOOL)footter
{
    CGFloat lastBottom = [self totalHeightForRowToSection:section target:target];
    if (header) {
        lastBottom += ([self totalHeightForHeaderToSection:section target:target]);
    }
    if (footter) {
        lastBottom += ([self totalHeightForFooterToSection:section target:target]);
    }
    return lastBottom;
}

@end
