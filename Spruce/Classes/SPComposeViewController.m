//
//  SPComposeViewController.m
//  Spruce
//
//  Created by Ryan on 9/2/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPComposeViewController.h"

@interface SPComposeViewController ()

@property (nonatomic, strong) UITextView *textView;

@end


@implementation SPComposeViewController


#pragma mark -
#pragma mark NSObject

- (id)init {
    if (self = [super init]) {
        [self setTitle:NSLocalizedString(@"New Post", nil)];
    }
    return self;
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTextView:[[UITextView alloc] initWithFrame:CGRectMake(kSPDefaultPadding, kSPDefaultPadding, kSPDefaultContentWidth, 200)]];
    [self.textView setBackgroundColor:[UIColor clearColor]];
    [self.textView setFont:[UIFont systemFontOfSize:15.0f]];
    [self.view addSubview:self.textView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.textView becomeFirstResponder];
    
    [super viewWillAppear:animated];
    
    UIBarButtonItem *cancelButton = [UIBarButtonItem barButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [cancelButton setTarget:self action:@selector(cancel)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    UIBarButtonItem *doneButton = [UIBarButtonItem barButtonWithTitle:NSLocalizedString(@"Done", nil)];
    [doneButton setTarget:self action:@selector(done)];
    [self.navigationItem setRightBarButtonItem:doneButton];
}


#pragma mark -
#pragma mark Button Callbacks

- (void)cancel {
    // TODO save draft
    [self dismissModalViewControllerAnimated:YES];
}

- (void)done {
    // TODO post
    [self dismissModalViewControllerAnimated:YES];
}


@end
