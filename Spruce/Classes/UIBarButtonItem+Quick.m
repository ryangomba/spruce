//
//  UIBarButtonItem+Quick.m
//  Spruce
//
//  Created by Ryan on 9/2/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "UIBarButtonItem+Quick.h"

@implementation UIBarButtonItem (Quick)

+ (UIBarButtonItem *)spinner {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    UIView *spinnerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 26, spinner.height + 2.0f)];
    [spinnerContainer addSubview:spinner];
    UIBarButtonItem *spinnerItem = [[UIBarButtonItem alloc] initWithCustomView:spinnerContainer];
    return spinnerItem;
}

+ (UIBarButtonItem *)barButtonWithTitle:(NSString *)title {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] init];
    [buttonItem setStyle:UIBarButtonItemStyleBordered];
    [buttonItem setTitle:title];
    return buttonItem;
}

+ (UIBarButtonItem *)barButtonWithImageNamed:(NSString *)imageName {
    UIImage *backImage = [UIImage imageNamed:imageName];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
    [backButtonItem setStyle:UIBarButtonItemStyleBordered];
    [backButtonItem setImage:backImage];
    return backButtonItem;
}

- (void)setTarget:(id)target action:(SEL)action {
    [self setTarget:target];
    [self setAction:action];
}

@end
