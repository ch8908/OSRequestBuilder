//
// Created by Kros Huang on 4/24/15.
// Copyright (c) 2015 oSolve. All rights reserved.
//

#import <Bolts/BFTask.h>
#import "WEApiService.h"
#import "OSRequestBuilder.h"
#import "WEApiClient.h"


@interface WEApiService()
@property (nonatomic, strong) WEApiClient *apiClient;
@end

@implementation WEApiService
- (instancetype) initWithApiClient:(WEApiClient *) apiClient {
    self = [super init];
    if (self) {
        self.apiClient = apiClient;
    }
    return self;
}

- (BFTask *) fetchBanner {
    OSRequestBuilder *builder = [self.apiClient.builder.withGet withPath:@"/v1/banners.json"];
    return [[builder buildWithModel:[OSRawDataType class] isArray:YES] request];
}

- (BFTask *) createDevice {
    OSRequestBuilder *builder = [self.apiClient.builder.withPost withPath:@"/v1/devices.json"];
    [builder addParam:@"device_id" value:@"asdfaxcvzxcv"];
    [builder addParam:@"platform" value:@"ios"];
    [builder addParam:@"app_version" value:@"0.0.1"];
    return [[builder buildWithModel:[OSRawDataType class] isArray:YES] request];
}

@end