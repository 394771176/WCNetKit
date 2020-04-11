//
//  WCDataRequest.h
//  WCKitDemo
//
//  Created by cheng on 2019/9/28.
//  Copyright © 2019 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCModel/WCDataResult.h>
#import "BPURLRequest.h"

typedef NS_ENUM(NSInteger, WCHTTPContentType) {
    WCHTTPContentTypeDefault,
    WCHTTPContentTypeImage,
    WCHTTPContentTypeVideo,
    WCHTTPContentTypeAudio,
    WCHTTPContentTypeText,
};

typedef NS_ENUM(NSInteger, WCHTTPResultType) {
    WCHTTPResultTypeDefault, //code = 1
    WCHTTPResultTypeZero,//code = 0
};

@interface WCDataRequest : NSObject

@property (nonatomic, strong) NSString *serverUrl;//请求地址
@property (nonatomic, strong) NSString *api;//请求API
@property (nonatomic, strong) NSDictionary *params;//请求参数
@property (nonatomic, strong) NSArray *paramsArray;//请求参数,支持定序，同名多参
@property (nonatomic, strong) NSString *signKey;//签名

@property (nonatomic, strong) NSString *httpMethod;//默认GET
@property (nonatomic, strong) NSString *contentTypeStr;//有特定的才需要传，常用的可以使用下面contentType 枚举
@property (nonatomic, assign) WCHTTPContentType contentType;//常用的内容类型
@property (nonatomic, assign) WCHTTPResultType resultType;//请求结果类型

@property (nonatomic, assign) NSInteger timeOut;//超时时间设定

@property (nonatomic, weak) id<BPURLRequestDelegate> delegate;

- (NSString *)requestUrl;
- (NSMutableDictionary *)requestParams;
- (BPURLRequest *)createRequestWithUrl:(NSString *)url params:(NSMutableDictionary *)params;

- (BPURLRequest *)makeRequest;
- (WCDataResult *)parseData:(id)data;

+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params;
+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;
+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params signKey:(NSString *)signKey;
+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod signKey:(NSString *)signKey;

+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod signKey:(NSString *)signKey contentType:(WCHTTPContentType)contentType;
+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod signKey:(NSString *)signKey resultType:(WCHTTPResultType)resultType;
+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod signKey:(NSString *)signKey contentType:(WCHTTPContentType)contentType resultType:(WCHTTPResultType)resultType;
+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod signKey:(NSString *)signKey contentType:(WCHTTPContentType)contentType resultType:(WCHTTPResultType)resultType timeOut:(NSInteger)timeOut;

@end
