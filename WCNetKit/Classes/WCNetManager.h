//
//  WCNetManager.h
//  WCKitDemo
//
//  Created by cheng on 2019/9/26.
//  Copyright © 2019 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCCategory/WCCategory.h>

@protocol WCNetManagerProtocol <NSObject>

@required

@optional

- (NSString *)userAgent;

@end

@interface WCNetManager : NSObject

@property (nonatomic, assign) BOOL enableLog;//允许日志
@property (nonatomic, assign) BOOL enableProxy;//允许抓包
@property (nonatomic, assign) NSInteger defaultTimeOut;//默认超时时长

@property (nonatomic, strong) NSString *userAgent;

@property (nonatomic, strong) NSString *signName;

SHARED_INSTANCE_H

+ (NSString *)createUserAgent;

@end
