//
// Created by Kros Huang on 4/25/15.
// Copyright (c) 2015 oSolve. All rights reserved.
//

#import "Repo.h"


@implementation Repo
+ (NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{@"repoId" : @"id", @"name" : @"name"};
}

- (NSString *) description {
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"self.repoId=%@", self.repoId];
    [description appendFormat:@", self.name=%@", self.name];

    NSMutableString *superDescription = [[super description] mutableCopy];
    NSUInteger length = [superDescription length];

    if (length > 0 && [superDescription characterAtIndex:length - 1] == '>') {
        [superDescription insertString:@", " atIndex:length - 1];
        [superDescription insertString:description atIndex:length + 1];
        return superDescription;
    }
    else {
        return [NSString stringWithFormat:@"<%@: %@>", NSStringFromClass([self class]), description];
    }
}

@end