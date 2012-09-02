//
//  SPUserViewController.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPUserViewController.h"

#import "SPUser.h"

@implementation SPUserViewController


#pragma mark -
#pragma mark NSObject

- (id)initWithUser:(SPUser *)user {
    if (self = [super init]) {
        [self setUser:user];
    }
    return self;
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
}


#pragma mark -
#pragma mark Public Methods

- (void)setUser:(SPUser *)user {
    _user = user;
    
    [self setTitle:user.username];
}

@end
