//
//  WCSystemUtil.h
//  WCBaseKit
//
//  Created by cheng on 2020/4/9.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCSystemUtil : NSObject

+ (NSString *)systemVersion;
+ (NSString *)deviceModel;

+ (NSString *)openUDID;
+ (NSString *)clientUDID;

+ (BOOL)isJailbroken;

@end
