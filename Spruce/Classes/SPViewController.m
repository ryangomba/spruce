//
//  SPViewController.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPViewController.h"

@implementation SPViewController


#pragma mark -
#pragma mark Public Methods

- (void)setTitle:(NSString *)title {
    NSString *displayTitle = [title uppercaseString];
    [super setTitle:displayTitle];
    [self.navigationItem setTitle:displayTitle];
}


#pragma mark -
#pragma mark Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
