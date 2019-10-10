//
//  WCNetProtocol.h
//  WCKitDemo
//
//  Created by cheng on 2019/9/26.
//  Copyright © 2019 cheng. All rights reserved.
//

#ifndef WCNetProtocol_h
#define WCNetProtocol_h

#import <Foundation/Foundation.h>

@protocol WCNetManagerProtocol <NSObject>

@required

@optional

- (NSString *)userAgent;

- (NSString *)userToken;

- (NSDictionary *)systemParams;

- (void)setUserTokenParams:(NSMutableDictionary *)params;

@end


#endif /* WCNetProtocol_h */
