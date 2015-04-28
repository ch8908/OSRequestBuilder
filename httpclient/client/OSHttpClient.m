//
// Created by Kros Huang on 4/17/15.
// Copyright (c) 2015 oSolve. All rights reserved.
//

#import "OSHttpClient.h"
#import "OSRequestBuilder.h"
#import <UIKit/UIKit.h>

@interface OSHttpClient()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, copy) NSString *baseURLString;
@end

@implementation OSHttpClient

- (void) dealloc {
    @try {
        [_operationQueue removeObserver:self forKeyPath:NSStringFromSelector(@selector(operationCount))];
    } @catch (NSException *__unused exception) {}
}

- (instancetype) initWithQueue:(NSOperationQueue *) operationQueue baseApiURLString:(NSString *) baseURLString {
    self = [super init];
    if (self) {
        self.operationQueue = operationQueue;
        self.baseURLString = baseURLString;
        [_operationQueue addObserver:self forKeyPath:NSStringFromSelector(@selector(operationCount))
                             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    }
    return self;
}

- (OSRequestBuilder *) builder {
    return [[OSRequestBuilder alloc] initWithQueue:self.operationQueue
                                     baseURLString:self.baseURLString];
}

- (void) observeValueForKeyPath:(NSString *) keyPath ofObject:(id) object change:(NSDictionary *) change context:(void *) context {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:[change[@"new"] intValue] > 0];
}

@end