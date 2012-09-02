//
//  UIView+Framing.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "UIView+Framing.h"

@implementation UIView (Framing)

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    [self setFrame:frame];
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    [self setFrame:frame];
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    [self setFrame:frame];
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    [self setFrame:frame];
}

@end
