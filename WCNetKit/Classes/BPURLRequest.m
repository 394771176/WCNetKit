//
//  BPURLRequest.m
//  YHHB
//
//  Created by Hunter Huang on 11/23/11.
//  Copyright (c) 2011 vge design. All rights reserved.
//

#import "BPURLRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "WCNetManager.h"

@interface BPURLRequest() <ASIHTTPRequestDelegate, ASIProgressDelegate> {
    double progress;
}

@end

@implementation BPURLRequest

@synthesize delegate, url, httpMethod, params, responseData, asiRequest;

+ (NSString *)userAgent
{
    return [WCNetManager sharedInstance].userAgent;
}

+ (BPURLRequest *)getRequestWithParams:(NSMutableDictionary *)params 
                                httpMethod:(NSString *)httpMethod 
                                  delegate:(id<BPURLRequestDelegate>)delegate 
                                requestURL:(NSString *)url {
    BPURLRequest *request = [[self alloc] init];
    request.delegate = delegate;
    request.httpMethod = httpMethod;
    request.params = params;
    request.url = url;
    request.responseData = nil;
    request.type = 0;
    
    ASIFormDataRequest *asiRequest;
    if (httpMethod && [httpMethod isEqualToString:@"POST"]) {
        asiRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        for (NSString *key in params.allKeys) {
            id obj = [params objectForKey:key];
            if ([obj isKindOfClass:[NSData class]]) {
                [asiRequest setData:obj forKey:key];
            } else if ([obj isKindOfClass:NSArray.class]) {
                for (id subObj in (NSArray *)obj) {
                    [asiRequest addPostValue:subObj forKey:key];
                }
            } else {
                [asiRequest setPostValue:obj forKey:key];
            }
        }
    } else {
        asiRequest = [ASIHTTPRequest requestWithURL:[url serializeURLWithParams:params httpMethod:httpMethod]];
    }
    if (delegate) {
        asiRequest.delegate = request;
    }
    asiRequest.userAgentString = [self userAgent];
    request.asiRequest = asiRequest;
    return request;
}

+ (BPURLRequest *)getRequestWithKeyValue:(NSString *)params delegate:(id<BPURLRequestDelegate>)delegate requestURL:(NSString *)url {
    BPURLRequest *request = [[self alloc] init];
    request.delegate = delegate;
    request.httpMethod = @"POST";
    request.params = nil;
    request.url = url;
    request.responseData = nil;
    request.paramsStr = params;
    request.type = 2;
    
    ASIFormDataRequest *asiRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    NSArray *tokens = [params componentsSeparatedByString:@";"];
    for (NSString *keyValue in tokens) {
        NSArray *kvTokens = [keyValue componentsSeparatedByString:@","];
        if (kvTokens && kvTokens.count>1) {
            [asiRequest addPostValue:[kvTokens objectAtIndex:1] forKey:[kvTokens objectAtIndex:0]];
        }
    }
    
    if (delegate) {
        asiRequest.delegate = request;
    }
    asiRequest.userAgentString = [self userAgent];
    request.asiRequest = asiRequest;
    return request;
}

+ (BPURLRequest *)getPostFileRequestWithParams:(NSMutableDictionary *)params
                                      delegate:(id<BPURLRequestDelegate>)delegate
                                   contentType:(NSString *)contentType
                                    requestURL:(NSString *)url {
    BPURLRequest *request = [[self alloc] init];
    request.delegate = delegate;
    request.httpMethod = @"POST";
    request.params = params;
    request.url = url;
    request.responseData = nil;
    request.contentType = contentType;
    request.type = 1;
    
    ASIFormDataRequest *asiRequest;
    asiRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    asiRequest.timeOutSeconds = 2*60; // 文件上传timeout时间加长
    asiRequest.uploadProgressDelegate = self;
    for (NSString *key in params.allKeys) {
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSData class]]) {
            [asiRequest addData:value withFileName:key andContentType:contentType forKey:key];
        } else {
            [asiRequest setPostValue:value forKey:key];
        }
    }
    
    if (delegate) {
        asiRequest.delegate = request;
    }
    asiRequest.userAgentString = [self userAgent];
    request.asiRequest = asiRequest;
    return request;
}

- (BPURLRequest *)copyRequestWithAddParams:(NSMutableDictionary *)addParams
{
    BPURLRequest *request;
    if (self.type==1) {
        NSMutableDictionary *dict = [self.params mutableCopy];
        if (addParams && [addParams isKindOfClass:[NSDictionary class]]) {
            [dict addEntriesFromDictionary:addParams];
        }
        request = [self.class getPostFileRequestWithParams:dict delegate:self.delegate contentType:self.contentType requestURL:self.url];
    } else if (self.type==2) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSArray *tokens = [self.paramsStr componentsSeparatedByString:@";"];
        for (NSString *keyValue in tokens) {
            NSArray *kvTokens = [keyValue componentsSeparatedByString:@","];
            [dict setObject:kvTokens[1] forKey:kvTokens[0]];
        }
        if (addParams && [addParams isKindOfClass:[NSDictionary class]]) {
            [dict addEntriesFromDictionary:addParams];
        }
        NSMutableString *str = [NSMutableString string];
        for (NSString *key in dict) {
            if (str.length>0) {
                [str appendString:@";"];
            }
            [str appendFormat:@"%@,%@", key, dict[key]];
        }
        request = [self.class getRequestWithKeyValue:str delegate:self.delegate requestURL:self.url];
    } else {
        NSMutableDictionary *dict = [self.params mutableCopy];
        if (addParams && [addParams isKindOfClass:[NSDictionary class]]) {
            [dict addEntriesFromDictionary:addParams];
        }
        request = [self.class getRequestWithParams:dict httpMethod:self.httpMethod delegate:self.delegate requestURL:self.url];
    }
    request.signKey = self.signKey;
    return request;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSData *)responseData
{
    return asiRequest.responseData;
}

- (id)parseResponse:(NSString *)str
{
    if ([NSString checkIsEmpty:str]) return nil;
    
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    return result;
}

- (NSString *)getSignName
{
    if ([WCNetManager sharedInstance].signName) {
        return [WCNetManager sharedInstance].signName;
    }
    return @"sign";
}

- (NSString *)getSignValueForUrlStr:(NSString *)urlStr httpMethod:(NSString *)httpMethod
{
    if (!urlStr || !_signKey) {
        return nil;
    }
    NSString *link = urlStr;
    NSRange range = [link rangeOfString:@"?"];
    if (range.length>0||[[httpMethod uppercaseString] isEqualToString:WCHTTPMethodPOST]) {
        NSString *pair = nil;
        if (range.length==0) {
            pair = @"";
        } else {
            pair = [link substringFromIndex:range.location+1];
        }
        
        NSString *getSign = [[[[pair stringByAppendingString:@"&"] md5Hash] stringByAppendingString:_signKey] md5Hash];
        if ([[httpMethod uppercaseString] isEqualToString:WCHTTPMethodPOST]) {
            unsigned char result[CC_MD5_DIGEST_LENGTH];
            [asiRequest buildPostBody];
            CC_MD5([asiRequest.postBody bytes], (CC_LONG)[asiRequest.postBody length], result);
            NSString *bodyMD5 = [NSString stringWithFormat:
                                 @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                                 result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                                 result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
                                 ];
            NSString *postSign = [[getSign stringByAppendingString:[[bodyMD5 stringByAppendingString:_signKey] md5Hash]] md5Hash];
            return postSign;
        } else {
            return getSign;
        }
    }
    return nil;
}

- (void)sign
{
    NSString *signName = [self getSignName];
    NSString *link = [asiRequest.url absoluteString];
    if (signName.length && link.length && _signKey.length) {
        NSString *signValue = [self getSignValueForUrlStr:link httpMethod:self.httpMethod];
        if (signValue.length) {
            if ([link rangeOfString:@"?"].length) {
                asiRequest.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&%@=%@", link, signName, signValue]];
            } else {
                asiRequest.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@=%@", link, signName, signValue]];
            }
        }
    }
}

- (void)startLog
{
    
}

- (void)endLogWithResult:(id)result hasParse:(BOOL)hasParse
{
    
}

- (id)startSynchronous
{
    if ([self getProxyStatus]) {
        return nil;
    }
    if (_signKey) {
        [self sign];
    }
    [self startLog];
    
    //设置cookie
    
    //发起同步请求
    [asiRequest startSynchronous];
    
    // parse the response
    id result = [self parseResponse:asiRequest.responseString];
    [self endLogWithResult:result hasParse:YES];
    return result;
}

- (id)startSynchronousForResponseData
{
    if ([self getProxyStatus]) {
        return nil;
    }
    if (_signKey) {
        [self sign];
    }
    [self startLog];
    
    [asiRequest startSynchronous];
    
    [self endLogWithResult:nil hasParse:NO];
    return asiRequest.responseData;
}

- (void)startAsynchronous
{
    if ([self getProxyStatus]) {
        return;
    }
    if (_signKey) {
        [self sign];
    }
    [asiRequest setCompletionBlock:^{
        
    }];
    [self startLog];
    
    [asiRequest startAsynchronous];
    __strong BPURLRequest *request = self;
    [asiRequest setCompletionBlock:^{
        [request endLogWithResult:nil hasParse:NO];
    }];
}

- (BOOL)getProxyStatus
{
#if DEBUG
    //debug开发模式下直接忽略代理设置检测
    return NO;
#else
    
    //全局配置是否忽略代理设置检测
    if ([WCNetManager sharedInstance].enableProxy) {
        return NO;
    }
    
    //当前请求是否忽略代理设置检测
    if (self.ignoreProxy) {
        return NO;
    }
    
    //检测是否设置了代理
    NSDictionary *proxySettings =  (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = [proxies objectAtIndex:0];
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
        return NO; //没有设置代理
    } else {
        return YES; //设置代理了
    }
#endif
}

#pragma mark ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    if (delegate && [delegate respondsToSelector:@selector(request:didFinishLoad:)]) {
        [delegate request:self didFinishLoad:[self parseResponse:asiRequest.responseString]];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    if (delegate && [delegate respondsToSelector:@selector(request:didFailWithError:)]) {
        [delegate request:self didFailWithError:asiRequest.error];
    }
}

#pragma mark - ASIProgressDelegate

- (void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength {
    progress += request.totalBytesSent/request.postLength;
}

@end
