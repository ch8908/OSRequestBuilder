//
// Created by Kros Huang on 4/24/15.
// Copyright (c) 2015 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WEApiClient;
@class BFTask;


@interface WEApiService : NSObject
- (instancetype) initWithApiClient:(WEApiClient *) apiClient;

- (BFTask *) fetchBanner;

- (BFTask *) createDevice;
@end