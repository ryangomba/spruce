//
//  NSDictionary+Safe.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "NSDictionary+Safe.h"

@implementation NSDictionary (Safe)

- (id)objectOrNilForKey:(NSString *)key {
    id object = [self objectForKey:key];
    if (object == [NSNull null]) {
        object = nil;
    }
    return object;
}

@end
