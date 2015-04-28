//
// Created by Kros Huang on 4/9/15.
// Copyright (c) 2015 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;

// Has No Return value
@interface OSVoidType : NSObject
@end

// Do not decode, return raw data
@interface OSRawDataType : NSObject
@end

@interface OSRequestable : NSObject
- (BFTask *) request;
@end

@interface OSRequestBuilder : NSObject
- (instancetype) initWithQueue:(NSOperationQueue *) operationQueue baseURLString:(NSString *) baseURLString;

+ (id) responseObjectFromError:(NSError *) error;

- (OSRequestBuilder *) withOptions;

- (OSRequestBuilder *) withGet;

- (OSRequestBuilder *) withHead;

- (OSRequestBuilder *) withPost;

- (OSRequestBuilder *) withDelete;

- (OSRequestBuilder *) withTrace;

- (OSRequestBuilder *) withConnect;

- (OSRequestBuilder *) withPut;

- (OSRequestBuilder *) withPatch;

- (OSRequestBuilder *(^)(NSString *path)) withPath;

- (OSRequestBuilder *(^)(NSDictionary *header)) addHeader;

- (OSRequestBuilder *(^)(NSString *key, NSString *value)) addParam;

- (OSRequestBuilder *(^)(NSDictionary *params)) addParams;

- (OSRequestable *(^)(Class modelCls)) buildModel;

- (OSRequestable *(^)(Class modelCls)) buildModels;
@end