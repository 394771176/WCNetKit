//
//  WCDataRequest.m
//  WCKitDemo
//
//  Created by cheng on 2019/9/28.
//  Copyright © 2019 cheng. All rights reserved.
//

#import "WCDataRequest.h"
#import "WCNetManager.h"

@implementation WCDataRequest

+ (NSString *)requestUrlWithServer:(NSString *)server api:(NSString *)api
{
    NSString *reqUrl = server;
    if (!reqUrl.length) {
        NSLog(@"###################无效url########################%@", api);
        return nil;
    }
    if (api.length) {
        reqUrl = [reqUrl stringByAppendingFormat:@"/%@", api];
    }
    return reqUrl;
}

- (NSMutableDictionary *)requestParams
{
    NSMutableDictionary *params = nil;
    if (_params && [_params isKindOfClass:NSMutableDictionary.class]) {
        params = (id)_params;
    } else {
        params = [NSMutableDictionary dictionaryWithDictionary:params];
    }
    if (_needSystemParams) {
        [params addEntriesFromDictionary:[WCNetManager systemParams]];
    }
    if (_needToken) {
        [WCNetManager setUserTokenParams:params];
    }

    return params;
}

//+ (NSString *)getImageContentTypeWithData:(NSData *)data
//{
//    SDImageFormat imageFormat = [NSData sd_imageFormatForImageData:data];
//    switch (imageFormat) {
//        case SDImageFormatJPEG:
//            contentType = @"image/jpeg";
//            break;
//        case SDImageFormatPNG:
//            contentType = @"image/png";
//            break;
//        case SDImageFormatGIF:
//            contentType = @"image/gif";
//            break;
//        case SDImageFormatTIFF:
//            contentType = @"image/tiff";
//            break;
//        case SDImageFormatWebP:
//            contentType = @"image/webp";
//            break;
//        default:
//            contentType = @"image/jpeg";
//            return nil;
//            break;
//    }
//}

- (void)setContentType:(WCHTTPContentType)contentType
{
    _contentType = contentType;
    NSString *typeStr = nil;
    NSInteger timeOut = 0;
    switch (contentType) {
        case WCHTTPContentTypeImage:
        {
            typeStr  = @"image/jpeg";
            timeOut = 120;
        }
            break;
        case WCHTTPContentTypeVideo:
        {
            typeStr  = @"video/mp4";
            timeOut = 300;
        }
            break;
        case WCHTTPContentTypeAudio:
        {
//            {".mp3", "audio/mpeg"},
//            {".wav", "audio/wav"},
            typeStr  = @"audio/mpeg";
            timeOut = 120;
        }
            break;
        case WCHTTPContentTypeText:
        {
            typeStr  = @"text/plain";
            timeOut = 60;
        }
            break;
        default:
            break;
    }
    if (!_contentTypeStr && typeStr) {
        _contentTypeStr = typeStr;
    }
    if (_timeOut <= 0 && timeOut > 0) {
        self.timeOut = timeOut;
    }
}

- (BPURLRequest *)makeRequest
{
    NSString *reqUrl = [self.class requestUrlWithServer:_serverUrl api:_api];
    if (!reqUrl) {
        return nil;
    }
    
    BPURLRequest *request = nil;
    if (_contentTypeStr) {
        request = [BPURLRequest getPostFileRequestWithParams:[self requestParams] delegate:_delegate contentType:_contentTypeStr requestURL:reqUrl];
    } else {
        request = [BPURLRequest getRequestWithParams:[self requestParams] httpMethod:_httpMethod delegate:_delegate requestURL:reqUrl];
    }
    
    request.asiRequest.defaultResponseEncoding = NSUTF8StringEncoding;
    request.signKey = _signKey;
    if (_timeOut > 0) {
        request.asiRequest.timeOutSeconds = _timeOut;
    }
    return request;
}

+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params
{
    return [self requestWithUrl:url api:api params:params httpMethod:WCHTTPMethodGET];
}

+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    return [self requestWithUrl:url api:api params:params httpMethod:httpMethod signKey:nil];
}

+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params signKey:(NSString *)signKey
{
    return [self requestWithUrl:url api:api params:params httpMethod:WCHTTPMethodGET signKey:signKey];
}

+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod signKey:(NSString *)signKey
{
    return [self requestWithUrl:url api:api params:params httpMethod:httpMethod signKey:signKey contentType:WCHTTPContentTypeDefault];
}

+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod signKey:(NSString *)signKey contentType:(WCHTTPContentType)contentType
{
    return [self requestWithUrl:url api:api params:params httpMethod:httpMethod signKey:signKey contentType:contentType resultType:WCHTTPResultTypeDefault];
}
+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod signKey:(NSString *)signKey resultType:(WCHTTPResultType)resultType
{
    return [self requestWithUrl:url api:api params:params httpMethod:httpMethod signKey:signKey contentType:WCHTTPContentTypeDefault resultType:resultType];
}
+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod signKey:(NSString *)signKey contentType:(WCHTTPContentType)contentType resultType:(WCHTTPResultType)resultType
{
    return [self requestWithUrl:url api:api params:params httpMethod:httpMethod signKey:signKey contentType:contentType resultType:resultType neetToken:NO needSystemParams:YES timeOut:0];
}

+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod signKey:(NSString *)signKey neetToken:(BOOL)neetToken
{
    return [self requestWithUrl:url api:api params:params httpMethod:httpMethod signKey:signKey contentType:WCHTTPContentTypeDefault resultType:WCHTTPResultTypeDefault neetToken:neetToken needSystemParams:YES timeOut:0];
}
+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod signKey:(NSString *)signKey needSystemParams:(BOOL)needSystemParams
{
    return [self requestWithUrl:url api:api params:params httpMethod:httpMethod signKey:signKey contentType:WCHTTPContentTypeDefault resultType:WCHTTPResultTypeDefault neetToken:NO needSystemParams:needSystemParams timeOut:0];
}

+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod signKey:(NSString *)signKey resultType:(WCHTTPResultType)resultType needSystemParams:(BOOL)needSystemParams
{
    return [self requestWithUrl:url api:api params:params httpMethod:httpMethod signKey:signKey contentType:WCHTTPContentTypeDefault resultType:resultType neetToken:NO needSystemParams:needSystemParams timeOut:0];
}

+ (instancetype)requestWithUrl:(NSString *)url api:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod signKey:(NSString *)signKey contentType:(WCHTTPContentType)contentType resultType:(WCHTTPResultType)resultType neetToken:(BOOL)neetToken needSystemParams:(BOOL)needSystemParams timeOut:(NSInteger)timeOut
{
    WCDataRequest *request = [[self alloc] init];
    request.serverUrl = url;
    request.api = api;
    request.params = params;
    request.signKey = signKey;
    request.contentType = contentType;
    request.resultType = resultType;
    request.needToken = neetToken;
    request.needSystemParams = needSystemParams;
    request.timeOut = timeOut;
    return request;
}

@end
