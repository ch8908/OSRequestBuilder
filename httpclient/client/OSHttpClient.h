//
// Created by Kros Huang on 4/17/15.
// Copyright (c) 2015 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OSRequestBuilder;

@interface OSHttpClient : NSObject

- (instancetype) initWithQueue:(NSOperationQueue *) operationQueue baseApiURLString:(NSString *) baseURLString;

- (OSRequestBuilder *) builder;
@end