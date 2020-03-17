//
//  BPLocalManager.h
//  BPCommonDemo
//
//  Created by 李正兴 on 2018/8/2.
//  Copyright © 2018年 R_style_Man. All rights reserved.
//

//此类等于使用NSUserDefaults BPAppPreference(Plist)做本地disk cache

#import <Foundation/Foundation.h>

@interface BPLocalManager : NSObject

+ (BPLocalManager *)sharedInstance;

//清除所有本地持久化数据
- (void)clearLocal;

//是否存在本地数据
- (BOOL)containsLocal:(NSString *)key;

//增加本地数据
- (void)setLocal:(id<NSCoding>)local forKey:(NSString *)key;

//删除本地数据
- (void)removeLocal:(NSString *)key;

//根据key读取本地数据
- (id)localForKey:(NSString *)key;

//根据key的前缀来获取一类cache
- (NSArray *)localListForByKeyWithPrefix:(NSString *)prefix;

@end
