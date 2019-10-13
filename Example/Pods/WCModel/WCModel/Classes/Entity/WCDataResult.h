//
//  WCDataResult.h
//  WCKitDemo
//
//  Created by cheng on 2019/9/28.
//  Copyright © 2019 cheng. All rights reserved.
//

#import "WCBaseEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCDataResult : WCBaseEntity

@property (nonatomic, assign) int code;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) id data;

+ (id)resultForUnknowError;
+ (id)resultForNetworkError;
+ (id)resultForServerError;
+ (id)resultForUnloginError;

+ (id)resultWithSuccessData:(id)data;
+ (id)resultWithFailMsg:(NSString *)msg;

@end

@interface WCZeroDataResult : WCDataResult

@end

NS_ASSUME_NONNULL_END
