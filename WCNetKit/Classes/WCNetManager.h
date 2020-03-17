//
//  WCNetManager.h
//  WCKitDemo
//
//  Created by cheng on 2019/9/26.
//  Copyright © 2019 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCCategory/WCCategory.h>
#import "WCNetProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCNetManager : NSObject

@property (nonatomic, assign) BOOL enableLog;//允许日志
@property (nonatomic, assign) BOOL enableProxy;//允许抓包
@property (nonatomic, assign) NSInteger defaultTimeOut;//默认超时时长

SHARED_INSTANCE_H

+ (void)setup:(id<WCNetManagerProtocol>)manager;

+ (NSString *)createUserAgent;

#pragma mark - WCNetManagerProtocol

+ (NSString *)userAgent;

+ (NSString *)userToken;

//可以自定义token 的key, 不实现则用默认的key => ac_token
+ (void)setUserTokenParams:(NSMutableDictionary *)params;

+ (NSDictionary *)systemParams;

@end

NS_ASSUME_NONNULL_END
