//
//  UIView+AttributedString.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@interface UIView (AttributedString)

- (void)drawAttributedString:(NSMutableAttributedString *)string atPoint:(CGPoint)point width:(CGFloat)width;

@end
