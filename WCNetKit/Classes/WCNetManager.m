//
//  WCNetManager.m
//  WCKitDemo
//
//  Created by cheng on 2019/9/26.
//  Copyright © 2019 cheng. All rights reserved.
//

#import "WCNetManager.h"
#import <WCCategory/WCCategory.h>

@interface WCNetManager ()
{
    
}

@end

@implementation WCNetManager

SHARED_INSTANCE_M

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)userAgent
{
    if (!_userAgent) {
        return [self.class createUserAgent];
    }
    return _userAgent;
}

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

@end
