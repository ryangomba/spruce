//
//  SPUserViewController.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPViewController.h"

@class SPUser;
@class SPImageView;
@class SPAvatarView;

@interface SPUserViewController : SPViewController

@property (nonatomic, strong) SPUser *user;

- (id)initWithUser:(SPUser *)user;

@end
