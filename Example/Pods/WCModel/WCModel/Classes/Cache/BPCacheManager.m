//
//  BPCacheManager.m
//  BPCommon
//
//  Created by wangpeng on 11/27/13.
//
//

#import "BPCacheManager.h"
#import "BPFileUtil.h"
//#import "FMDatabaseQueue.h"
//#import "FMDatabaseAdditions.h"
#import <WCModule/FMDB.h>

@interface BPCacheManager () {
    FMDatabaseQueue *_dbQueue;
    NSString *_cachePath;
}
@end


@implementation BPCacheManager

- (id)initWithCachePath:(NSString *)cachePath
{
    self = [super init];
    if (self) {
        _cachePath = cachePath;
        
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:cachePath];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            if (![db tableExists:@"cache"]) {
                [db executeUpdate:@"CREATE TABLE cache (key VARCHAR PRIMARY KEY NOT NULL, trait VARCHAR, expiry TIMESTAMP NOT NULL, data BOLB)"];
                [db executeUpdate:@"CREATE INDEX cache_trait_index ON cache(trait)"];
            }
        }];
        
        NSString *historyKey = @"BPCacheManagerInitHistoryKey";
        
        NSArray *hisList = [self cacheForKey:historyKey];
        NSMutableArray *nHisList = [NSMutableArray array];
        if (hisList) {
            int dt = [[NSDate date] timeIntervalSince1970]-60;
            int times = 0;
            for (NSDate *date in hisList) {
                if ([date timeIntervalSince1970]>=dt) {
                    times++;
                    [nHisList addObject:date];
                };
            }
            if (times>=2) {
                [self clearCache];
            } else {
                [self clearExpiryCache];
                [nHisList addObject:[NSDate date]];
                [self setCache:nHisList forKey:historyKey];
            }
        } else {
            [self clearExpiryCache];
            [self setCache:@[[NSDate date]] forKey:historyKey];
        }
    }
    return self;
}

- (void)clearExpiryCache
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"delete from cache where expiry<? and expiry!=0", [NSNumber numberWithFloat:[[NSDate date] timeIntervalSince1970]]];
        }];
    });
}

- (void)clearCache
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"delete from cache"];
        }];
    });
}

- (BOOL)containsCache:(NSString *)key
{
    __block BOOL result = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select key from cache where key=?", key];
        result = [rs next];
        [rs close];
    }];
    return result;
}

- (id)cacheForKey:(NSString *)key
{
    __block id<NSCoding> result = nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select data from cache where key=? and (expiry>? or expiry=0)", key, [NSNumber numberWithFloat:[[NSDate date] timeIntervalSince1970]]];
        if ([rs next]) {
            @try{
                result = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"data"]];
            } @catch(NSException* e) {
//                BPLoggerCache(@"Unable to unarchive cache for key:%@", key);
                result = nil;
            }
        }
        [rs close];
    }];
    return result;
}

- (id)cacheForKey:(NSString *)key expiryDate:(NSDate * __autoreleasing *)expiryDate
{
    __block id<NSCoding> result = nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select data,expiry from cache where key=? and (expiry>? or expiry=0)", key, [NSNumber numberWithFloat:[[NSDate date] timeIntervalSince1970]]];
        if ([rs next]) {
            @try{
                result = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"data"]];
            } @catch(NSException* e) {
//                BPLoggerCache(@"Unable to unarchive cache for key:%@", key);
                result = nil;
            }
            float expiry = [rs doubleForColumn:@"expiry"];
            if (expiry>0) {
                *expiryDate = [NSDate dateWithTimeIntervalSince1970:expiry];
            }
        }
        [rs close];
    }];
    return result;
}

/**
 根据key的前缀来获取一类cache
 
 @param prefix key前缀
 */
- (NSArray *)cacheListForByKeyWithPrefix:(NSString *)prefix
{
	__block NSMutableArray *result;
	[_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [NSString stringWithFormat:@"select data from cache where key like '%@%%'", prefix];
		FMResultSet *rs = [db executeQuery:sql];
		while ([rs next]) {
			id item = nil;
			@try{
				item = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"data"]];
			} @catch(NSException* e) {
//                BPLoggerCache(@"Unable to unarchive cache for key prefix:%@", prefix);
				item = nil;
			}
			if (item) {
				if (!result) {
					result = [NSMutableArray array];
				}
				[result addObject:item];
			}
		}
		[rs close];
	}];
	return result;
}

- (NSArray *)cacheListForTrait:(NSString *)trait
{
    __block NSMutableArray *result = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select data from cache where trait=? and (expiry>? or expiry=0)", trait, [NSNumber numberWithFloat:[[NSDate date] timeIntervalSince1970]]];
        while ([rs next]) {
            id item = nil;
            @try{
                item = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"data"]];
            } @catch(NSException* e) {
//                BPLoggerCache(@"Unable to unarchive cache for trait:%@", trait);
                item = nil;
            }
            if (item) {
                [result addObject:item];
            }
        }
        [rs close];
    }];
    return [NSArray arrayWithArray:result];
}

- (NSArray *)keysListForTrait:(NSString *)trait
{
    __block NSMutableArray *result = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select key from cache where trait=? and (expiry>? or expiry=0)", trait, [NSNumber numberWithFloat:[[NSDate date] timeIntervalSince1970]]];
        while ([rs next]) {
            NSString *key = [rs stringForColumn:@"key"];
            if (key) {
                [result addObject:key];
            }
        }
        [rs close];
    }];
    return [NSArray arrayWithArray:result];
}

- (void)removeCache:(NSString *)key
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from cache where key=?", key];
    }];
}

- (void)removeCacheWithTrait:(NSString *)trait
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from cache where trait=?", trait];
    }];
}

/**
 根据key的前缀来删一类cache
 
 @param prefix key前缀
 */
- (BOOL)removeCacheForKeyWithPrefix:(NSString *)prefix
{
	__block BOOL success;
	[_dbQueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
		success = [db executeUpdate:@"delete from cache where key like '?%'", prefix];
		*rollback = !success;
	}];
	return success;
}

- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key
{
    [self setCache:cache forKey:key trait:nil duration:90*24*60*60];
}

- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key trait:(NSString *)trait
{
    [self setCache:cache forKey:key trait:trait duration:90*24*60*60];
}

- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key duration:(NSInteger)duration
{
    [self setCache:cache forKey:key trait:nil duration:duration];
}

- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key trait:(NSString *)trait duration:(NSInteger)duration
{
    if (cache==nil||key==nil) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            NSData *value = nil;
            @try {
                value = [NSKeyedArchiver archivedDataWithRootObject:cache];
            } @catch (NSException *exception) {
//                BPLoggerCache(@"Unable to unarchive cache for trait:%@", trait);
                value = nil;
            }
            if (value) {
                [db executeUpdate:@"replace into cache (key, trait, expiry, data) values (?,?,?,?)", key, trait?trait:@"", [NSNumber numberWithFloat:duration>0?[[NSDate date] timeIntervalSince1970]+duration:0], value];
            }
        }];
    });
}

- (void)setCacheList:(NSArray *)cacheList forKeyList:(NSArray *)keyList trait:(NSString *)trait duration:(NSInteger)duration
{
    if (cacheList.count>0&&cacheList.count==keyList.count) {
        [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            for (int i=0; i<cacheList.count; i++) {
                id cache = [cacheList objectAtIndex:i];
                NSString *key = [keyList objectAtIndex:i];
                NSData *value = nil;
                @try {
                    value = [NSKeyedArchiver archivedDataWithRootObject:cache];
                } @catch (NSException *exception) {
//                    BPLoggerCache(@"Unable to unarchive cache for trait:%@", trait);
                    value = nil;
                }
                if (value) {
                    [db executeUpdate:@"replace into cache (key, trait, expiry, data) values (?,?,?,?)", key, trait?trait:@"", [NSNumber numberWithFloat:duration>0?[[NSDate date] timeIntervalSince1970]+duration:0], value];
                }
            }
            *rollback = NO;
        }];
    }
}

- (NSInteger)getSize
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:_cachePath]) {
        return (NSInteger)[[[NSFileManager defaultManager] attributesOfItemAtPath:_cachePath error:nil] fileSize];
    } else {
        return 0;
    }
}

+ (void)executeWithCacheDateKey:(NSString *)key duration:(double)duration skipCache:(BOOL)skipCache block:(void (^)(BPCacheUtilExecuteComplete))block
{
    double ot = [[[BPCacheManager sharedInstance] cacheForKey:key] doubleValue];
    double ct = [[NSDate date] timeIntervalSince1970];
    if (skipCache||ct-ot>duration) {
        if (block) {
            block(^(BOOL success){
                if (success) {
                    [[BPCacheManager sharedInstance] setCache:@(ct) forKey:key];
                }
            });
        }
    }
}

+ (BPCacheManager *)sharedInstance
{
    static id instance = nil;
    @synchronized (self) {
        if (instance==nil) {
            instance = [[BPCacheManager alloc] initWithCachePath:[BPFileUtil getDocumentPathWithDir:@"cache" fileName:@"data.db"]];
        }
    }
    return instance;
}

@end
