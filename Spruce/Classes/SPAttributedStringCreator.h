//
//  SPAttributedStringCreator.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import <CoreText/CoreText.h>

@interface SPAttributedStringCreator : NSObject

- (void)setString:(NSString *)string;

- (void)makeLarge;
- (void)makeLarge:(NSRange)range;

- (void)makeBold;
- (void)makeBold:(NSRange)range;

- (void)makeLink;
- (void)makeLink:(NSRange)range;

- (NSMutableAttributedString *)attributedString;

+ (CGFloat)heightForAttributedString:(NSMutableAttributedString *)attributedString width:(CGFloat)width;

@end
