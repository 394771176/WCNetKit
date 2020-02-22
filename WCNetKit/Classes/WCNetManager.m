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
    if (!User_Agent) {
        //必须在主线程中获取UA
        if ([NSThread isMainThread]) {
            [self initUserAgent];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self initUserAgent];
            });
        }
    }
    return User_Agent;
}

#pragma mark - WCNetManagerDelegate

    
+ (BOOL)respondsMethod:(SEL)sel
{
    return (wcManager && [wcManager respondsToSelector:sel]);
}
    
+ (id)getReturnValueForMethod:(SEL)sel
{
    if ([self respondsMethod:sel]) {
//        IMP imp = [(NSObject *)wcManager methodForSelector:sel];
//        id (*func)(id, SEL) = (void *)imp;
//        id result = func(wcManager, sel);
//        return result;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [wcManager performSelector:sel];
#pragma clang diagnostic pop
    }
    return nil;
}

+ (NSString *)userAgent
{
    if ([self respondsMethod:@selector(userAgent)]) {
        return [self getReturnValueForMethod:@selector(userAgent)];
    } else {
        return [self createUserAgent];
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
