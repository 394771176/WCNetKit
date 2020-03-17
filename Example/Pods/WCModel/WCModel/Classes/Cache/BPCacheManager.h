//
//  BPCacheManager.h
//  BPCommon
//
//  Created by wangpeng on 11/27/13.
//
//

#import <Foundation/Foundation.h>

typedef void (^BPCacheUtilExecuteComplete)(BOOL success);

@interface BPCacheManager : NSObject

+ (BPCacheManager *)sharedInstance;

//在缓存时间后过后才执行，可跳过缓存逻辑直接执行
+ (void)executeWithCacheDateKey:(NSString *)key duration:(double)duration skipCache:(BOOL)skipCache block:(void (^)(BPCacheUtilExecuteComplete))block;

//清除过期缓存
- (void)clearExpiryCache;
- (void)clearCache;

//是否存在缓存
- (BOOL)containsCache:(NSString *)key;

//取得缓存内容
- (id)cacheForKey:(NSString *)key;
- (id)cacheForKey:(NSString *)key expiryDate:(NSDate **)expiryDate;
/**
 根据key的前缀来获取一类cache。比如：根据@"QCPWeiZhangHistoryKey1_"来获取所有历史违章
 注意：使用前必须确认没有其他key包含目前的前缀，否则会带来意外的结果。如：前缀@"AABBC"的cache key 包含@"AAB"的前缀的cachekey
 强烈建议使用该方法获取的cache list，在使用前做类型判断
 @param prefix key前缀
 */
- (NSArray *)cacheListForByKeyWithPrefix:(NSString *)prefix;
//根据trait取得缓存列表
- (NSArray *)cacheListForTrait:(NSString *)trait;

//根据trait取得key列表
- (NSArray *)keysListForTrait:(NSString *)trait;

//根据key删除缓存
- (void)removeCache:(NSString *)key;

/**
 根据key的前缀来删一类cache。比如：根据@"QCPWeiZhangHistoryKey1_"来获取所有历史违章
 注意：使用前必须确认没有其他key包含目前的前缀，否则会带来意外的结果。如：前缀@"AABBC"的cache key 包含@"AAB"的前缀的cachekey
 慎用
 @param prefix key前缀
 */
- (BOOL)removeCacheForKeyWithPrefix:(NSString *)prefix;

//根据trait删除缓存
- (void)removeCacheWithTrait:(NSString *)trait;

//增加缓存
- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key;
- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key trait:(NSString *)trait;
- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key duration:(NSInteger)duration;
- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key trait:(NSString *)trait duration:(NSInteger)duration;

- (void)setCacheList:(NSArray *)cacheList forKeyList:(NSArray *)keyList trait:(NSString *)trait duration:(NSInteger)duration;

- (NSInteger)getSize;

@end
