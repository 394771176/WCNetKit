//
//  WCReachabilityUtil.m
//  WCKitDemo
//
//  Created by cheng on 2019/9/29.
//  Copyright © 2019 cheng. All rights reserved.
//

#import "WCReachabilityUtil.h"

@implementation WCReachabilityUtil

SHARED_INSTANCE_M

- (void)dealloc
{
    _reachability = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _reachability = [Reachability reachabilityForInternetConnection];
        WEAK_SELF
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf) {
                [weakSelf.reachability startNotifier];
            }
        });
    }
    return self;
}

- (BOOL)isWifi
{
    return self.reachability.isReachableViaWiFi;
}

- (BOOL)isWWAN
{
    return self.reachability.isReachableViaWWAN;
}

- (BOOL)isReachable
{
    return self.reachability.isReachable;
}

@end
