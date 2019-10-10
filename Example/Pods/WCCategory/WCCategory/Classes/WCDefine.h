//
//  WCDefine.h
//  WCKit
//
//  Created by cheng on 2019/9/25.
//  Copyright © 2019 cheng. All rights reserved.
//

#ifndef WCDefine_h
#define WCDefine_h

// 应用
#define APP_BUNDLE_ID           ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"])
#define APP_BUNDLE_NAME         ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])
#define APP_DISPLAY_NAME        ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]?:APP_BUNDLE_NAME)
#define APP_VERSION_BUILD       ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])
#define APP_VERSION_SHORT       ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

#define STYTEM_VERSION_ARRAY    ([[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."])
#define STYTEM_VERSION_HEADER   ([STYTEM_VERSION_ARRAY count]>0?([STYTEM_VERSION_ARRAY[0] intValue]):0)
#define iOS(n)                  (STYTEM_VERSION_HEADER>=n)
#define AvailableiOS(n)         @available(iOS n, *)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

#define IS_iPhoneX         [UIDevice isIPhoneX]

#define SCREEN_WIDTH        (CGRectGetWidth([UIScreen mainScreen].bounds))
#define SCREEN_HEIGHT       (CGRectGetHeight([UIScreen mainScreen].bounds))
#define SCREEN_SIZE         ([[UIScreen mainScreen] currentMode].size)
#define SCREEN_SCALE        ([UIScreen mainScreen].scale)

#define STATUSBAR_HEIGHT    (IS_iPhoneX ? 44.f : 20.f)

#define NAVBAR_HEIGHT       44.f

#define SAFE_BOTTOM_VIEW_HEIGHT  (IS_iPhoneX ? 20.f : 0.f)//自定义底部安全距离
#define SAFE_IPHONEX_BOTTOM_HEIGHT  (IS_iPhoneX ? 34.f : 0.f) //iphoneX 官方给出的安全区域

#define SAFE_BOTTOM_TITLE_EDGE_TOP_HEIGHT  (IS_iPhoneX ? -15.f : 0.f)//底部按钮文案适配X后 上移的距离

#define WEAK_SELF      __weak __typeof(&*self)weakSelf = self;

#define SHARED_INSTANCE_H  + (instancetype)sharedInstance;
#define SHARED_INSTANCE_M  \
+ (instancetype)sharedInstance \
{ \
static id instance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [self.class new]; \
}); \
return instance; \
}


#endif /* WCDefine_h */
