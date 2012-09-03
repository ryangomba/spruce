//
//  NSMutableAttributedString+Attributes.h
//  Spruce
//
//  Created by Ryan on 9/2/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@interface NSMutableAttributedString (Attributes)

- (void)setFont:(UIFont *)font;
- (void)setFont:(UIFont *)font range:(NSRange)range;

- (void)setColor:(UIColor *)color;
- (void)setColor:(UIColor *)color range:(NSRange)range;

- (void)setHighlightColor:(UIColor *)color;
- (void)setHighlightColor:(UIColor *)color range:(NSRange)range;

- (void)setTextAlignment:(UITextAlignment)textAlignment
        paragraphSpacing:(CGFloat)paragraphSpacing
           minLineHeight:(CGFloat)minLineHeight
           maxLineHeight:(CGFloat)maxLineHeight;

- (void)setURL:(NSURL *)url range:(NSRange)range;
- (NSURL *)urlAtIndex:(NSInteger)index;

- (BOOL)highlightSpan:(BOOL)highlight atIndex:(NSInteger)index;

@end
