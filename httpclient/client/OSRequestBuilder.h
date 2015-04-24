//
// Created by Kros Huang on 4/9/15.
// Copyright (c) 2015 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;

@interface OSVoidType : NSObject
@end

@interface OSRawDataType : NSObject
@end

@interface OSRequestable : NSObject
- (BFTask *) request;
@end

@interface OSRequestBuilder : NSObject
- (instancetype) initWithQueue:(NSOperationQueue *) operationQueue baseURLString:(NSString *) baseURLString;

- (OSRequestBuilder *) withGet;

- (OSRequestBuilder *) withPost;

- (OSRequestBuilder *) withDelete;

- (OSRequestBuilder *) withPatch;

- (OSRequestBuilder *) withPath:(NSString *) path;

- (OSRequestBuilder *) addParam:(NSString *) key value:(NSString *) value;

- (OSRequestBuilder *) addParams:(NSDictionary *) params;

- (OSRequestBuilder *) addHeader:(NSDictionary *) header;

- (OSRequestable *) buildWithModel:(Class) modelClass isArray:(BOOL) isArray;

@end