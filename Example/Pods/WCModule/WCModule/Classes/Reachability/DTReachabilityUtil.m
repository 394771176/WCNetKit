//
//  DTReachabilityUtil.m
//  DrivingTest
//
//  Created by Huang Tao on 2/26/14.
//  Copyright (c) 2014 eclicks. All rights reserved.
//

#import "DTReachabilityUtil.h"

@implementation DTReachabilityUtil

- (void)dealloc
{
    _reachability = nil;
}

+ (DTReachabilityUtil *)sharedInstance
{
    static id instance = nil;
    if (instance==nil) {
        instance = [[DTReachabilityUtil alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _reachability = [Reachability reachabilityForInternetConnection];
        __weak Reachability *weakItem = _reachability;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakItem && [weakItem respondsToSelector:@selector(startNotifier)]) {
                [weakItem startNotifier];
            }
        });
    }
    return self;
}

- (BOOL)isReachable
{
    return self.reachability.isReachable;
}

- (BOOL)isWifi
{
    return self.reachability.isReachableViaWiFi;
}

- (BOOL)isWWAN
{
    return self.reachability.isReachableViaWWAN;
}

@end
