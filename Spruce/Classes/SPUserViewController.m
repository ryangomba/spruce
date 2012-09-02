//
//  SPUserViewController.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPUserViewController.h"

#import "SPUser.h"
#import "SPImageView.h"
#import "SPAvatarView.h"
#import "SPComposeViewController.h"

@interface SPUserViewController ()
@property (nonatomic, strong) SPImageView *coverImageView;
@property (nonatomic, strong) SPAvatarView *avatarImageView;
@end


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

    NSInteger coverHeight = MAX(floorf(320 / self.user.coverAspectRatio), 100);
    [self setCoverImageView:[[SPImageView alloc] initWithFrame:CGRectMake(0, 0, 320, coverHeight)]];
    [self.coverImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.coverImageView setImageURL:self.user.coverURL];
    [self.view addSubview:self.coverImageView];
    
    [self setAvatarImageView:[[SPAvatarView alloc] initWithFrame:CGRectMake(10, coverHeight - 25, 75, 75) user:self.user]];
    [self.view addSubview:self.avatarImageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *composeButton = [UIBarButtonItem barButtonWithImageNamed:@"bar-glyph-plus.png"];
    [composeButton setTarget:self action:@selector(compose)];
    [self.navigationItem setRightBarButtonItem:composeButton];
}


#pragma mark -
#pragma mark Public Methods

- (void)setUser:(SPUser *)user {
    _user = user;
    
    [self setTitle:user.username];
}


#pragma mark -
#pragma mark Button Callbacks

- (void)compose {
    SPComposeViewController *composeVC = [[SPComposeViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:composeVC];
    [self presentModalViewController:navController animated:YES];
}

@end
