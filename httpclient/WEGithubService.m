//
// Created by Kros Huang on 4/24/15.
// Copyright (c) 2015 oSolve. All rights reserved.
//

#import <Bolts/BFTask.h>
#import "WEGitHubService.h"
#import "OSRequestBuilder.h"
#import "WEApiClient.h"
#import "Repo.h"


@interface WEGitHubService()
@property (nonatomic, strong) WEApiClient *apiClient;
@end

@implementation WEGitHubService
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
}

@end