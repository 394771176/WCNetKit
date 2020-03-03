//
//  DTReachabilityUtil.h
//  DrivingTest
//
//  Created by Huang Tao on 2/26/14.
//  Copyright (c) 2014 eclicks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface DTReachabilityUtil : NSObject

@property (nonatomic, strong, readonly) Reachability *reachability;

@property (nonatomic) BOOL isReachable;//是否链接网络
@property (nonatomic) BOOL isWifi;//是否wifi已连接
@property (nonatomic) BOOL isWWAN;//是否蜂窝网络已连接

+ (DTReachabilityUtil *)sharedInstance;

@end
