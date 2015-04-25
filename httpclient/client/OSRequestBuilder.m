//
// Created by Kros Huang on 4/9/15.
// Copyright (c) 2015 oSolve. All rights reserved.
//

#import <Bolts/BFTask.h>
#import "DDLog.h"
#import "AFHTTPRequestOperation.h"
#import "MTLJSONAdapter.h"
#import "OSRequestBuilder.h"
#import "BFTaskCompletionSource.h"
#import "MTLModel.h"

static NSString *kRequestResponseObjectKey = @"kRequestResponseObjectKey";
NSInteger const ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation OSVoidType
@end

@implementation OSRawDataType
@end

@interface OSRequestable()
@property (nonatomic, strong) BFTaskCompletionSource *tcs;
@property (nonatomic, strong) NSURLRequest *urlRequest;
@property (nonatomic, strong) Class modelClass;
@property (nonatomic) BOOL isArray;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation OSRequestable
- (instancetype) initWithRequest:(NSURLRequest *) urlRequest modelClass:(Class) modelClass isArray:(BOOL) isArray operationQueue:(NSOperationQueue *) operationQueue {
    self = [super init];
    if (self) {
        self.urlRequest = urlRequest;
        self.modelClass = modelClass;
        self.isArray = isArray;
        self.operationQueue = operationQueue;
    }
    return self;
}

- (BFTask *) request {
    _tcs = [BFTaskCompletionSource taskCompletionSource];

    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:self.urlRequest];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [requestOperation.responseSerializer setStringEncoding:NSUTF8StringEncoding];
    [requestOperation
      setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
          DDLogInfo(@"Request Builder:%@, URL:%@, Body:%@, Model:%@, responseObject:%@", self.urlRequest.HTTPMethod, [self.urlRequest URL], [self convertHttpBodyToString:self.urlRequest.HTTPBody], self.modelClass, responseObject);
          if ([self.modelClass isSubclassOfClass:[OSVoidType class]]) {
              [_tcs setResult:nil];
              return;
          }

          if ([self.modelClass isSubclassOfClass:[OSRawDataType class]]) {
              [_tcs setResult:responseObject];
              return;
          }

          if (![self.modelClass isSubclassOfClass:[MTLModel class]]) {
              NSAssert(false, @"model class must be one of OSVoidType, OSRawDataType or subclass of MTLModel");
          }

          if (self.isArray) {
              NSArray *array = [MTLJSONAdapter modelsOfClass:self.modelClass fromJSONArray:responseObject
                                                       error:nil];
              [_tcs setResult:array];
          } else {
              id modelObject = [MTLJSONAdapter modelOfClass:self.modelClass fromJSONDictionary:responseObject
                                                      error:nil];
              [_tcs setResult:modelObject];
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        id data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString *errorMessage = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        DDLogInfo(@"Request Builder Failed:%@, URL:%@, Body:%@, Model:%@, Error:%@", self.urlRequest.HTTPMethod, [self.urlRequest URL], [self convertHttpBodyToString:self.urlRequest.HTTPBody], self.modelClass, error);
        DDLogInfo(@"decode error message:%@", errorMessage);
        [_tcs setError:[self getPatchedError:operation error:error]];
    }];
    [self.operationQueue addOperation:requestOperation];
    return self.tcs.task;
}

- (NSError *) getPatchedError:(AFHTTPRequestOperation *) operation error:(NSError *) error {
    NSMutableDictionary *patchedUserInfo = [error.userInfo mutableCopy];
    if (operation.responseObject) {
        patchedUserInfo[kRequestResponseObjectKey] = operation.responseObject;
    }
    NSError *patchedError = [NSError errorWithDomain:error.domain
                                                code:error.code
                                            userInfo:[patchedUserInfo copy]];
    return patchedError;
}

- (NSString *) convertHttpBodyToString:(NSData *) body {
    return [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
}

@end

@interface OSRequestBuilder()
@property (nonatomic, copy) NSString *baseUrlString;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) Class modelClass;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableDictionary *header;
@end

@implementation OSRequestBuilder

- (instancetype) initWithQueue:(NSOperationQueue *) operationQueue baseURLString:(NSString *) baseURLString {
    self = [super init];
    if (self) {
        _operationQueue = operationQueue;
        _baseUrlString = baseURLString;
    }
    return self;
}

- (OSRequestBuilder *) withOptions {
    self.method = @"OPTIONS";
    return self;
}

- (OSRequestBuilder *) withGet {
    self.method = @"GET";
    return self;
}

- (OSRequestBuilder *) withHead {
    self.method = @"HEAD";
    return self;
}

- (OSRequestBuilder *) withPost {
    self.method = @"POST";
    return self;
}

- (OSRequestBuilder *) withPut {
    self.method = @"PUT";
    return self;
}

- (OSRequestBuilder *) withPatch {
    self.method = @"PATCH";
    return self;
}

- (OSRequestBuilder *) withDelete {
    self.method = @"DELETE";
    return self;
}

- (OSRequestBuilder *) withTrace {
    self.method = @"TRACE";
    return self;
}

- (OSRequestBuilder *) withConnect {
    self.method = @"CONNECT";
    return self;
}

- (OSRequestBuilder *) withPath:(NSString *) path {
    NSAssert([path characterAtIndex:0] == '/', @"path must be start with '/'");
    self.path = path;
    return self;
}

- (OSRequestBuilder *) addParam:(NSString *) key value:(NSString *) value {
    NSAssert(key, @"param key can not be nil");
    NSAssert(value, @"param value can not be nil");
    if (!self.params) {
        self.params = [NSMutableDictionary dictionary];
    }
    self.params[key] = value;
    return self;
}

- (OSRequestBuilder *) addParams:(NSDictionary *) params {
    NSAssert(params, @"add params can not be nil");
    if (!self.params) {
        self.params = [NSMutableDictionary dictionary];
    }
    [self.params addEntriesFromDictionary:params];
    return self;
}

- (OSRequestBuilder *) addHeader:(NSDictionary *) header {
    if (!self.header) {
        self.header = [NSMutableDictionary dictionary];
    }
    [self.header addEntriesFromDictionary:header];
    return self;
}

- (OSRequestable *) buildModel:(Class) modelClass {
    return [self buildWithModel:modelClass isArray:NO];
}

- (OSRequestable *) buildModels:(Class) modelClass {
    return [self buildWithModel:modelClass isArray:YES];
}

- (OSRequestBuilder *(^)(NSDictionary *header)) addHeader {
    return ^OSRequestBuilder *(NSDictionary *header) {
        if (!self.header) {
            self.header = [NSMutableDictionary dictionary];
        }
        [self.header addEntriesFromDictionary:header];
        return self;
    };
}

- (OSRequestBuilder *(^)(NSString *key, NSString *value)) addParam {
    return ^OSRequestBuilder *(NSString *key, NSString *value) {
        NSAssert(key, @"param key can not be nil");
        NSAssert(value, @"param value can not be nil");
        if (!self.params) {
            self.params = [NSMutableDictionary dictionary];
        }
        self.params[key] = value;
        return self;
    };
}

- (OSRequestBuilder *(^)(NSString *)) withPath {
    return ^OSRequestBuilder *(NSString *path) {
        NSAssert([path characterAtIndex:0] == '/', @"path must be start with '/'");
        self.path = path;
        return self;
    };
}

- (OSRequestable *(^)(Class modelCls)) buildModel {
    return ^OSRequestable *(Class modelCls) {
        return [self buildWithModel:modelCls isArray:NO];
    };
}

- (OSRequestable *(^)(Class modelCls)) buildModels {
    return ^OSRequestable *(Class modelCls) {
        return [self buildWithModel:modelCls isArray:YES];
    };
}

- (OSRequestable *) buildWithModel:(Class) modelClass isArray:(BOOL) isArray {
    self.modelClass = modelClass;

    NSAssert(self.path, @"path cannot be nil");
    NSAssert(self.method, @"method cannot be nil");
    NSAssert(self.modelClass, @"model class cannot be nil");

    NSString *escapedPath = [self.path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:self.method
                                                                                 URLString:[self requestURL:escapedPath]
                                                                                parameters:self.params
                                                                                     error:nil];
    if (self.header) {
        for (NSString *key in self.header.allKeys) {
            [request addValue:key forHTTPHeaderField:self.header[key]];
        }
    }
    return [[OSRequestable alloc] initWithRequest:request
                                       modelClass:self.modelClass
                                          isArray:isArray
                                   operationQueue:self.operationQueue];
}

- (NSString *) requestURL:(NSString *) path {
    NSString *URLString = [NSString stringWithFormat:@"%@%@", self.baseUrlString, path];
    return URLString;
}

@end
