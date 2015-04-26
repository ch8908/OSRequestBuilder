//
// Created by Kros Huang on 4/25/15.
// Copyright (c) 2015 oSolve. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"


@interface Repo : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSNumber *repoId;
@property (nonatomic, copy) NSString *name;
@end