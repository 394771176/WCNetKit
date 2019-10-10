//
//  UIColor+Util.m
//  DrivingTest
//
//  Created by cheng on 16/9/21.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)

+ (UIColor *)colorWithString:(NSString *)hexStr
{
    return [self colorWithString:hexStr alpha:1.0f];
}

+ (UIColor *)colorWithAlphaString:(NSString *)hexStr
{
    NSArray *hexArray = [hexStr componentsSeparatedByString:@"-"];
    if (hexArray.count==2) {
        return [self colorWithHexString:hexArray[0] alpha:[hexArray[1] floatValue]/100.0f];
    } else {
        return [self colorWithHexString:hexStr alpha:1.f];
    }
}

+ (UIColor *)colorWithString:(NSString *)hexString alpha:(float)alpha {
    return [self colorWithHexString:hexString alpha:alpha];
}

+ (nullable UIColor *)colorWithHexString:(NSString*)hexString
{
    return [self colorWithHexString:hexString alpha:1.f];
}

+ (nullable UIColor *)colorWithHexValue:(uint)hexValue alpha:(float)alpha {
    NSArray *array = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
    if ([[array firstObject] floatValue] >= 10) {
        return [UIColor
                colorWithDisplayP3Red:((float)((hexValue & 0xFF0000) >> 16))/255.0
                green:((float)((hexValue & 0xFF00) >> 8))/255.0
                blue:((float)(hexValue & 0xFF))/255.0
                alpha:alpha];
        
    }
    return [UIColor
            colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
            green:((float)((hexValue & 0xFF00) >> 8))/255.0
            blue:((float)(hexValue & 0xFF))/255.0
            alpha:alpha];
}

+ (nullable UIColor *)colorWithHexString:(NSString*)hexString alpha:(float)alpha {
    if (hexString == nil || (id)hexString == [NSNull null]) {
        return nil;
    }
    UIColor *col;
    if (![hexString hasPrefix:@"#"]) {
        hexString = [NSString stringWithFormat:@"#%@", hexString];
    }
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#"
                                                     withString:@"0x"];
    uint hexValue;
    if ([[NSScanner scannerWithString:hexString] scanHexInt:&hexValue]) {
        col = [self colorWithHexValue:hexValue alpha:alpha];
    } else {
        // invalid hex string
        col = [UIColor clearColor];
    }
    return col;
}

@end
