//
//  WCDataService.h
//  WCKitDemo
//
//  Created by cheng on 2019/9/27.
//  Copyright © 2019 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPURLRequest.h"
#import "WCDataRequest.h"
#import "WCDataResult.h"

@interface WCDataService : NSObject

// 同步请求
+ (WCDataResult *)sync:(WCDataRequest *)request;

// 异步请求
+ (void)async:(WCDataRequest *)request
       finish:(void (^)(WCDataResult *result))finish;

+ (void)async:(WCDataRequest *)request
       config:(void (^)(WCDataResult *result))config
       finish:(void (^)(WCDataResult *result))finish;

//提供一些常用方法，比如b拼接系统参数， 拼接分页参数等
//+ (NSMutableDictionary *)params:(NSMutableDictionary *)params withStart:(NSInteger)start limit:(NSInteger)limit pos:(NSString *)pos;

@end
