//
//  WCReachabilityUtil.h
//  WCKitDemo
//
//  Created by cheng on 2019/9/29.
//  Copyright © 2019 cheng. All rights reserved.
//

#import <WCModule/Reachability.h>
#import <WCCategory/WCCategory.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCReachabilityUtil : NSObject

@property (nonatomic, strong, readonly) Reachability *reachability;

@property (nonatomic) BOOL isWifi;//是否wifi已连接
@property (nonatomic) BOOL isWWAN;//是否蜂窝网络
@property (nonatomic) BOOL isReachable;//是否链接网络

SHARED_INSTANCE_H

@end

NS_ASSUME_NONNULL_END
