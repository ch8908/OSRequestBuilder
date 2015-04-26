//
// Created by Kros Huang on 4/24/15.
// Copyright (c) 2015 oSolve. All rights reserved.
//

#import <Bolts/BFTask.h>
#import "WEGithubService.h"
#import "OSRequestBuilder.h"
#import "WEApiClient.h"
#import "Repo.h"


@interface WEGithubService()
@property (nonatomic, strong) WEApiClient *apiClient;
@end

@implementation WEGithubService
- (instancetype) initWithApiClient:(WEApiClient *) apiClient {
    self = [super init];
    if (self) {
        self.apiClient = apiClient;
    }
    return self;
}

- (BFTask *) fetchRepos {
    return self.apiClient.builder
               .withGet
               .withPath(@"/users/ch8908/repos")
               .buildModels([Repo class]).request;

//    OSRequestBuilder *builder = [self.apiClient.builder.withPost withPath:@"/v1/devices.json"];
//    [builder addParam:@"device_id" value:@"asdfaxcvzxcv"];
//    [builder addParam:@"platform" value:@"ios"];
//    [builder addParam:@"app_version" value:@"0.0.1"];
//    return [[builder buildModel:OSRawDataType.class] request];
}

@end