//
//  WCDataResult.m
//  WCKitDemo
//
//  Created by cheng on 2019/9/28.
//  Copyright © 2019 cheng. All rights reserved.
//

#import "WCDataResult.h"

@implementation WCDataResult

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"msg" : @[@"msg", @"message"]};
}

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic
{
    if (![dic objectForKey:@"success"]) {
        self.success = (self.code==1);
    }
    return YES;
}

+ (WCDataResult *)resultForUnknowError
{
    return [self resultWithFailMsg:@"未知错误"];
}

+ (WCDataResult *)resultForNetworkError
{
    return [self resultWithFailMsg:@"网络不给力"];
}

+ (WCDataResult *)resultForServerError
{
    return [self resultWithFailMsg:@"服务器打瞌睡了"];
}
+ (id)resultForUnloginError
{
    return [self resultWithFailMsg:@"请先登录一下吧"];
}

+ (WCDataResult *)resultWithSuccessData:(id)data
{
    WCDataResult *item = [[self alloc] init];
    item.success = YES;
    item.data = data;
    return item;
}

+ (WCDataResult *)resultWithFailMsg:(NSString *)msg
{
    WCDataResult *item = [[self alloc] init];
    item.success = NO;
    item.msg = msg;
    return item;
}

@end

@implementation WCZeroDataResult

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic
{
    if (![dic objectForKey:@"success"]) {
        self.success = (self.code==0);
    }
    return YES;
}

@end
