//
//  WCNetManager.m
//  WCKitDemo
//
//  Created by cheng on 2019/9/26.
//  Copyright © 2019 cheng. All rights reserved.
//

#import "WCNetManager.h"
#import <UIKit/UIKit.h>

@interface WCNetManager ()
{
    
}

@end

@implementation WCNetManager

static id<WCNetManagerProtocol> wcManager = nil;

+ (void)setup:(id<WCNetManagerProtocol>)manager
{
    wcManager = manager;
}

+ (id<WCNetManagerProtocol>)sharedManager
{
    return wcManager;
}

SHARED_INSTANCE_M

static NSString *User_Agent = nil;

+ (NSString *)initUserAgent
{
    if (!User_Agent) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        User_Agent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    }
    return User_Agent;
}

+ (NSString *)createUserAgent
{
    //必须在主线程中获取UA
    if ([NSThread isMainThread]) {
        [self initUserAgent];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self initUserAgent];
        });
    }
    return User_Agent;
}

#pragma mark - WCNetManagerDelegate

+ (id)getReturnValueForMethod:(SEL)sel
{
    if (wcManager && [wcManager respondsToSelector:sel]) {
        return [wcManager performSelector:sel];
    }
    return nil;
}

+ (NSString *)userAgent
{
    if (User_Agent) {
        return User_Agent;
    } else {
        return [self getReturnValueForMethod:@selector(userAgent)];
    }
}

+ (NSString *)userToken
{
    return [self getReturnValueForMethod:@selector(userToken)];
}

+ (void)setUserTokenParams:(NSMutableDictionary *)params
{
    if (wcManager && [wcManager respondsToSelector:@selector(setUserTokenParams:)]) {
        return [wcManager setUserTokenParams:params];
    } else {
        [params safeSetObject:[self userToken] forKey:@"ac_token"];
    }
}

+ (NSDictionary *)systemParams
{
    return [self getReturnValueForMethod:@selector(systemParams)];
}

@end
