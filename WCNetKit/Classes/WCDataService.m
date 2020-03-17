//
//  WCDataService.m
//  WCKitDemo
//
//  Created by cheng on 2019/9/27.
//  Copyright © 2019 cheng. All rights reserved.
//

#import "WCDataService.h"
#import "WCNetKit.h"

@implementation WCDataService

+ (void)addBlockOnMainThread:(void (^)(void))block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

+ (void)addBlockOnGlobalThread:(void (^)(void))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        block();
    });
}

+ (WCDataResult *)getResultWith:(BPURLRequest *)request
{
    return nil;
}

// 同步请求
+ (WCDataResult *)sync:(WCDataRequest *)req
{
    if (![DTReachabilityUtil sharedInstance].isReachable) {
        return [WCDataResult resultForNetworkError];
    }
    
    if (req.needToken && ![WCNetManager userToken]) {
        return [WCDataResult resultForUnloginError];
    }
    
    BPURLRequest *request = [req makeRequest];
    id result = [request startSynchronous];
    
    WCDataResult *dataResult = nil;
    if (result) {
        dataResult = [req parseData:result];
    } else {
        if (request.asiRequest.responseStatusCode == 0) {
            dataResult = [WCDataResult resultForNetworkError];
        } else {
            dataResult = [WCDataResult resultForServerError];
        }
    }
    
    return dataResult;
}

// 异步请求
+ (void)async:(WCDataRequest *)request
       finish:(void (^)(WCDataResult *))finish
{
    [self async:request config:nil finish:finish];
}

+ (void)async:(WCDataRequest *)request
       config:(void (^)(WCDataResult *result))config
       finish:(void (^)(WCDataResult *result))finish
{
    [self addBlockOnGlobalThread:^{
        WCDataResult *result = [self sync:request];
        if (config) {
            config(result);
        }
        [self addBlockOnMainThread:^{
            if (finish) {
                finish(result);
            }
        }];
    }];
}

+ (void)asyncBlock:(WCDataRequest *(^)(void))request finish:(void (^)(WCDataResult *))finish
{
    [self asyncBlock:request config:nil finish:finish];
}

+ (void)asyncBlock:(WCDataRequest *(^)(void))request config:(void (^)(WCDataResult *))config finish:(void (^)(WCDataResult *))finish
{
    if (request) {
        [self async:request() config:config finish:finish];
    }
}

+ (void)loadCache:(void (^)(WCDataResult *cache))cacheBlock
           forKey:(NSString *)cacheKey
{
    [self addBlockOnGlobalThread:^{
        WCDataResult *cache = nil;
        if (cacheKey && cacheBlock) {
            cache = [[BPCacheManager sharedInstance] cacheForKey:cacheKey];
        }
        [self addBlockOnMainThread:^{
            if (cacheBlock) {
                cacheBlock(cache);
            }
        }];
    }];
}

+ (void)async:(WCDataRequest *)request
     cacheKey:(NSString *)cacheKey
    loadCache:(void (^)(WCDataResult *cache))cacheBlock
       finish:(void (^)(WCDataResult *result))finish
{
    if (cacheBlock) {
        [self loadCache:^(WCDataResult *cache) {
            if (cacheBlock) {
                cacheBlock(cache);
            }
            [self async:request cacheKey:cacheKey finish:finish];
        } forKey:cacheKey];
    } else {
        [self async:request cacheKey:cacheKey finish:finish];
    }
}

+ (void)async:(WCDataRequest *)request
     cacheKey:(NSString *)cacheKey
       finish:(void (^)(WCDataResult *result))finish
{
    [self addBlockOnGlobalThread:^{
        WCDataResult *result = [self sync:request];
        if (result.success && cacheKey) {
            [[BPCacheManager sharedInstance] setCache:result forKey:cacheKey];
        }
        [self addBlockOnMainThread:^{
            if (finish) {
                finish(result);
            }
        }];
    }];
}

@end
