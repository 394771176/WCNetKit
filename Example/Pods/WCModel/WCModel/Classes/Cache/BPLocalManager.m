//
//  BPLocalManager.m
//  BPCommonDemo
//
//  Created by 李正兴 on 2018/8/2.
//  Copyright © 2018年 R_style_Man. All rights reserved.
//

#import "BPLocalManager.h"
#import "BPFileUtil.h"
//#import "FMDatabaseQueue.h"
//#import "FMDatabaseAdditions.h"
#import <WCModule/FMDB.h>

@interface BPLocalManager () {
    FMDatabaseQueue *_dbQueue;
    NSString *_localPath;
}
@end


@implementation BPLocalManager

+ (BPLocalManager *)sharedInstance
{
    static id instance = nil;
    @synchronized (self) {
        if (instance==nil) {
            instance = [[BPLocalManager alloc] initWithLocalPath:[BPFileUtil getDocumentPathWithDir:@"local" fileName:@"data.db"]];
        }
    }
    return instance;
}

- (id)initWithLocalPath:(NSString *)localPath
{
    self = [super init];
    if (self) {
        _localPath = localPath;
        
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:localPath];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            if (![db tableExists:@"local"]) {
                [db executeUpdate:@"CREATE TABLE local (key VARCHAR PRIMARY KEY NOT NULL, data BOLB)"];
            }
        }];
    }
    return self;
}

- (void)clearLocal
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"delete from local"];
        }];
    });
}

- (BOOL)containsLocal:(NSString *)key
{
    __block BOOL result = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select key from local where key=?", key];
        result = [rs next];
        [rs close];
    }];
    return result;
}

- (void)setLocal:(id<NSCoding>)local forKey:(NSString *)key
{
    if (local==nil||key==nil) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_dbQueue inDatabase:^(FMDatabase *db) {
            NSData *value = nil;
            @try {
                value = [NSKeyedArchiver archivedDataWithRootObject:local];
            } @catch (NSException *exception) {
//                BPLog(@"Unable to unarchive local data for key:%@", key);
                value = nil;
            }
            if (value) {
                [db executeUpdate:@"replace into local (key, data) values (?,?)", key, value];
            }
        }];
    });
}

- (void)removeLocal:(NSString *)key
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from local where key=?", key];
    }];
}

- (id)localForKey:(NSString *)key
{
    __block id<NSCoding> result = nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select data from local where key=?", key];
        if ([rs next]) {
            @try{
                result = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"data"]];
            } @catch(NSException* e) {
//                BPLog(@"Unable to unarchive local data for key:%@", key);
                result = nil;
            }
        }
        [rs close];
    }];
    return result;
}

- (NSArray *)localListForByKeyWithPrefix:(NSString *)prefix
{
    __block NSMutableArray *result;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [NSString stringWithFormat:@"select data from local where key like '%@%%'", prefix];
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

@end
