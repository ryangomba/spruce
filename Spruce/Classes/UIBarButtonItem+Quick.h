//
//  UIBarButtonItem+Quick.h
//  Spruce
//
//  Created by Ryan on 9/2/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@interface UIBarButtonItem (Quick)

+ (UIBarButtonItem *)spinner;
+ (UIBarButtonItem *)barButtonWithTitle:(NSString *)title;
+ (UIBarButtonItem *)barButtonWithImageNamed:(NSString *)imageName;

- (void)setTarget:(id)target action:(SEL)action;

@end
