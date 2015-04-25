//
//  ViewController.m
//  httpclient
//
//  Created by Kros Huang on 4/9/15.
//  Copyright (c) 2015 oSolve. All rights reserved.
//

#import <Bolts/BFTask.h>
#import "ViewController.h"
#import "WEApiClient.h"
#import "OSHttpClient.h"
#import "WEApiService.h"

@interface ViewController()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) WEApiService *apiService;
@end

@implementation ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    UIButton *requestButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [requestButton setTitle:@"Request" forState:UIControlStateNormal];
    [requestButton addTarget:self action:@selector(request:) forControlEvents:UIControlEventTouchUpInside];
    requestButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:requestButton];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:requestButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:requestButton
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0]];

    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 5;

    self.operationQueue = operationQueue;
    OSHttpClient *client = [[OSHttpClient alloc] initWithQueue:self.operationQueue
                                                 baseURLString:@"http://123.57.206.216/api"];
    WEApiClient *apiClient = [[WEApiClient alloc] initWithHttpClient:client];
    [apiClient setDeviceId:@"wwqqasssdeviceIdddd"];
    [apiClient setAuthToken:@"authtoken"];
    self.apiService = [[WEApiService alloc] initWithApiClient:apiClient];
}

- (void) request:(id) request {
//    [[self.apiService fetchBanner] continueWithBlock:^id(BFTask *task) {
//        NSLog(@">>>>>>>>>>>> task.result = %@", task.result);
//        return nil;
//    }];

    [[self.apiService createDevice] continueWithBlock:^id(BFTask *task) {
        NSLog(@">>>>>>>>>>>> task.result = %@", task.result);
        return nil;
    }];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
