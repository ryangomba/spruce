//
//  SPAttributedStringCreator.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#define kSPAttributedStringLinkAttribute @"is_text_link"

@interface SPAttributedStringCreator : NSObject

- (void)setString:(NSString *)string;

- (void)makeLarge;
- (void)makeBold:(NSRange)range;
- (void)makeLink:(NSRange)range;
- (void)makeTag:(NSRange)range;

- (NSMutableAttributedString *)attributedString;

@end
