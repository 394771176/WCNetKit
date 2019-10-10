//
//  UILabel+Utils.h
//  DrivingTest
//
//  Created by cheng on 15/12/31.
//  Copyright © 2015年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAttributedString+Utils.h"

@interface UILabel (Utils)

- (CGSize)measureSize;

+ (id)labelWithFrame:(CGRect)frame font:(UIFont *)font color:(UIColor *)color;

+ (id)labelWithFrame:(CGRect)frame font:(UIFont *)font colorString:(NSString *)colorString;

+ (id)labelWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize color:(UIColor *)color;

+ (id)labelWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize colorString:(NSString *)colorString;

- (void)setFontSize:(CGFloat)fontSize;
- (void)setTextColorString:(NSString *)colorString;
- (void)setFontSize:(CGFloat)fontSize colorString:(NSString *)colorString;

@end


@interface UILabel (Attributed)

- (void)setText:(NSString *)text highLightText:(NSString *)highLightText withFont:(UIFont *)font;
- (void)setText:(NSString *)text highLightText:(NSString *)highLightText withColor:(UIColor *)color;
- (void)setText:(NSString *)text highLightText:(NSString *)highLightText withColor:(UIColor *)color withFont:(UIFont*)font;

//高亮数组
- (void)setText:(NSString *)text highLightTextArray:(NSArray *)highLightTextArray withColor:(UIColor *)color;

- (void)setText:(NSString *)text withLineSpace:(float)lineSpace;
- (void)setText:(NSString *)text withWordSpace:(float)wordSpace;
- (void)setText:(NSString *)text withLineSpace:(float)lineSpace wordSpace:(float)wordSpace;

- (CGFloat)getAttributedTextWidth;

@end
