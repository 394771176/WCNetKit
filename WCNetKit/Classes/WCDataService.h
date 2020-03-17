//
//  WCDataService.h
//  WCKitDemo
//
//  Created by cheng on 2019/9/27.
//  Copyright © 2019 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCDataRequest.h"

@interface WCDataService : NSObject

+ (void)addBlockOnMainThread:(void (^)(void))block;
+ (void)addBlockOnGlobalThread:(void (^)(void))block;

// 同步请求
+ (WCDataResult *)sync:(WCDataRequest *)request;

// 异步请求
+ (void)async:(WCDataRequest *)request
       finish:(void (^)(WCDataResult *result))finish;

+ (void)async:(WCDataRequest *)request
       config:(void (^)(WCDataResult *result))config
       finish:(void (^)(WCDataResult *result))finish;

+ (void)asyncBlock:(WCDataRequest * (^)(void))request
       finish:(void (^)(WCDataResult *result))finish;

+ (void)asyncBlock:(WCDataRequest * (^)(void))request
       config:(void (^)(WCDataResult *result))config
       finish:(void (^)(WCDataResult *result))finish;

+ (void)loadCache:(void (^)(WCDataResult *cache))cacheBlock
           forKey:(NSString *)cacheKey;

+ (void)async:(WCDataRequest *)request
     cacheKey:(NSString *)cacheKey
    loadCache:(void (^)(WCDataResult *cache))cacheBlock
       finish:(void (^)(WCDataResult *result))finish;

//提供一些常用方法，比如b拼接系统参数， 拼接分页参数等
//+ (NSMutableDictionary *)params:(NSMutableDictionary *)params withStart:(NSInteger)start limit:(NSInteger)limit pos:(NSString *)pos;

@end
