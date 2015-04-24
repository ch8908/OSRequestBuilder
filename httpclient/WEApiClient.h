//
// Created by Kros Huang on 4/17/15.
// Copyright (c) 2015 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OSHttpClient;
@class BFTask;
@class OSRequestBuilder;


@interface WEApiClient : NSObject
- (instancetype) initWithHttpClient:(OSHttpClient *) httpClient;

- (void) setAuthToken:(NSString *) authToken;

- (void) setDeviceId:(NSString *) deviceId;

- (OSRequestBuilder *) builder;

@end