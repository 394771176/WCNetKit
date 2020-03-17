//
//  WCBaseEntity.m
//  Coach
//
//  Created by cheng on 16/5/25.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "WCBaseEntity.h"
#import <WCCategory/WCCategory.h>

@implementation WCBaseEntity

- (NSDate *)dateFromDict:(NSDictionary *)dict forKey:(NSString *)key
{
    return [NSDate dateFromDict:dict forKey:key];
}

+ (id)itemFromDict:(NSDictionary *)dict
{
    if (dict==nil) return nil;
    
    if (dict) {
        if (![dict isKindOfClass:[NSDictionary class]] || dict.count <= 0) {
            return nil;
        }
    }
    
    return [self yy_modelWithDictionary:dict];
}

+ (NSArray *)itemsFromArray:(NSArray *)array
{
    if (array==nil) return nil;
    
    if (array&&![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:[array count]];
    for (NSDictionary *dict in array) {
        if ((id)dict == [NSNull null]) {
            continue;
        }
        id item = [self itemFromDict:dict];
        if (item) {
            [mArray safeAddObject:item];
        }
    }
    return mArray;
}

+ (NSArray *)arrayFromItems:(NSArray *)array {
    if (array == nil) return nil;
    
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:[array count]];
    for (id item in array) {
        NSDictionary *dict = [self dictFromItem:item];
        if (dict)
            [mArray safeAddObject:dict];
    }
    return mArray;
}

+ (NSDictionary *)itemsDictFromDict:(NSDictionary *)dict
{
    if (dict == nil) return nil;
    if ([NSDictionary validDict:dict]) {
        __block NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString * key, id obj, BOOL * _Nonnull stop) {
            id item = nil;
            if ([obj isKindOfClass:[NSDictionary class]]) {
                item = [self itemFromDict:obj];
            } else if ([obj isKindOfClass:[NSArray class]]) {
                item = [self itemsFromArray:obj];
            }
            
            if (item) {
                [result safeSetObject:item forKey:key];
            }
        }];
        return result;
    }
    return nil;
}

//- (instancetype)initWithResultSet:(FMResultSet *)rs
//{
//    self = [super init];
//    if (self) {
//
//    }
//    return self;
//}
//
//+ (id)itemFromResultSet:(FMResultSet *)rs
//{
//    if (!rs) return nil;
//
//    return [[[self class] alloc] initWithResultSet:rs];
//}
//
//+ (NSMutableArray *)itemsFromResultSet:(FMResultSet *)rs
//{
//    if (!rs) {
//        return nil;
//    }
//
//    NSMutableArray *mArray = [NSMutableArray array];
//    while ([rs next]) {
//        id item = [self itemFromResultSet:rs];
//        if (item) {
//            [mArray safeAddObject:item];
//        }
//    }
//    return mArray;
//}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    /**
     * return @{@"itemId"     : @"id",
     *          @"schoolName" : @"school.name"};
     */
    return nil;
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    /**
     * return @{@"sign_list" : [CCTrainingSignItem class]};
     */
    return nil;
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    /**
     * self.start_date = [self dateFromDict:dic forKey:@"start_time"];
     * self.end_date = [self dateFromDict:dic forKey:@"end_time"];
     */
    return YES;
}

- (NSDictionary *)dictItem
{
    return [self yy_modelToJSONObject];
}

+ (NSDictionary *)dictFromItem:(WCBaseEntity *)item
{
    return [item dictItem];
}


#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [[self class] itemFromDict:[aDecoder decodeObjectForKey:@"coder"]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[[self class] dictFromItem:self] forKey:@"coder"];
}


@end
