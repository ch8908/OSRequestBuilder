//
// Created by Kros Huang on 4/9/15.
// Copyright (c) 2015 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;

// No Return value
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

- (OSRequestBuilder *) withOptions;

- (OSRequestBuilder *) withGet;

- (OSRequestBuilder *) withHead;

- (OSRequestBuilder *) withPost;

- (OSRequestBuilder *) withDelete;

- (OSRequestBuilder *) withTrace;

- (OSRequestBuilder *) withConnect;

- (OSRequestBuilder *) withPut;

- (OSRequestBuilder *) withPatch;

- (OSRequestBuilder *) withPath:(NSString *) path;

- (OSRequestBuilder *) addParam:(NSString *) key value:(NSString *) value;

- (OSRequestBuilder *) addParams:(NSDictionary *) params;

- (OSRequestBuilder *) addHeader:(NSDictionary *) header;

- (OSRequestable *) buildModel:(Class) modelClass;

- (OSRequestable *) buildModels:(Class) modelClass;

- (OSRequestBuilder *(^)(NSString *key, NSString *value)) addParam;

- (OSRequestBuilder *(^)(NSDictionary *header)) addHeader;

- (OSRequestBuilder *(^)(NSString *path)) withPath;

- (OSRequestable *(^)(Class modelCls)) buildModel;

- (OSRequestable *(^)(Class modelCls)) buildModels;
@end