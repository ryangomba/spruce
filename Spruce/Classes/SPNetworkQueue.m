//
//  SPNetworkQueue.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPNetworkQueue.h"

@implementation SPNetworkQueue

+ (id)sharedQueue {
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[SPNetworkQueue alloc] init];
    });
}

@end
