//
//  UIImageView+Utils.m
//  DrivingTest
//
//  Created by cheng on 2017/6/29.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "UIImageView+Utils.h"

@implementation UIImageView (Utils)

- (void)setImageWithName:(NSString *)name
{
    if (name) {
        [self setImage:[UIImage imageNamed:name]];
    } else {
        [self setImage:nil];
    }
}

@end
