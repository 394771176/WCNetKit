//
//  WCSystemUtil.m
//  WCBaseKit
//
//  Created by cheng on 2020/4/9.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "WCSystemUtil.h"
#import "CKOpenUDID.h"
#import <WCCategory/WCCategory.h>

@implementation WCSystemUtil

+ (NSString *)systemVersion
{
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)deviceModel
{
    return [UIDevice machineModel];
}

+ (NSString *)openUDID
{
    return [CKOpenUDID value];
}

+ (NSString *)clientUDID
{
    return [UIDevice clientUDID];
}

+ (BOOL)isJailbroken
{
    return [UIDevice isJailbroken];
}

@end
