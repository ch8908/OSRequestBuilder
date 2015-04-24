//
// Created by Kros Huang on 4/17/15.
// Copyright (c) 2015 oSolve. All rights reserved.
//

#import "WEApiClient.h"
#import "OSHttpClient.h"
#import "OSRequestBuilder.h"


@interface WEApiClient()
@property (nonatomic, strong) OSHttpClient *httpClient;
@end

@implementation WEApiClient {
    NSString *_authToken;
    NSString *_deviceId;
}

- (instancetype) initWithHttpClient:(OSHttpClient *) httpClient {
    self = [super init];
    if (self) {
        self.httpClient = httpClient;
    }
    return self;
}

- (void) setAuthToken:(NSString *) authToken {
    _authToken = authToken;
}

- (void) setDeviceId:(NSString *) deviceId {
    _deviceId = deviceId;
}

- (OSRequestBuilder *) builder {
    OSRequestBuilder *builder = [self.httpClient builder];
    if (_authToken) {
        [builder addParam:@"authentication_token" value:_authToken];
    }
    if (_deviceId) {
        [builder addParam:@"device_id" value:_deviceId];
    }
    return builder;
}

@end