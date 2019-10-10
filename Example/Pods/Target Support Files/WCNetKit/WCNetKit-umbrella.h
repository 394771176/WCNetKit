#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BPURLRequest.h"
#import "WCDataRequest.h"
#import "WCDataResult.h"
#import "WCDataService.h"
#import "WCNetManager.h"
#import "WCNetProtocol.h"
#import "WCReachabilityUtil.h"

FOUNDATION_EXPORT double WCNetKitVersionNumber;
FOUNDATION_EXPORT const unsigned char WCNetKitVersionString[];

