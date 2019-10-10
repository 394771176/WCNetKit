//
//  WCBaseEntity.h
//  Coach
//
//  Created by cheng on 16/5/25.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "YYModel.h"

@interface WCBaseEntity : NSObject <YYModel,NSCoding>

+ (id)itemFromDict:(NSDictionary *)dict;
+ (NSArray *)itemsFromArray:(NSArray *)array;
+ (NSDictionary *)itemsDictFromDict:(NSDictionary *)dict;

+ (NSDictionary *)dictFromItem:(WCBaseEntity *)item;
+ (NSArray *)arrayFromItems:(NSArray *)array;

- (NSDictionary *)dictItem;
- (NSDate *)dateFromDict:(NSDictionary *)dict forKey:(NSString *)key;

// YYModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper;

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass;
    
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic;

//- (instancetype)initWithResultSet:(FMResultSet *)rs;
//+ (id)itemFromResultSet:(FMResultSet *)rs;
//+ (NSMutableArray *)itemsFromResultSet:(FMResultSet *)rs;

@end
