//
//  NSMutableAttributedString+Spruce.m
//  Spruce
//
//  Created by Ryan on 9/2/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "NSMutableAttributedString+Spruce.h"

#import "NSMutableAttributedString+Attributes.h"
#import "SPLinkedEntity.h"

@implementation NSMutableAttributedString (Spruce)

- (void)setDefaultParagraphSettings {
    [self setTextAlignment:UITextAlignmentLeft
          paragraphSpacing:2.0f
             minLineHeight:0.0f
             maxLineHeight:18.0f];
}

- (void)attachLinkedEntity:(SPLinkedEntity *)linkedEntity {
    if (!linkedEntity.url) {
        return; // sanity check
    }
    NSRange range = linkedEntity.textRange;
    [self setURL:linkedEntity.url range:range];
    
    UIColor *textColor;
    UIColor *highlightTextColor;
    BOOL isBold = NO;
    switch (linkedEntity.linkType) {
        case SPLinkTypeWeb:
            textColor = kSPLinkTextColor;
            highlightTextColor = kSPHighlightedLinkTextColor;
            break;
        case SPLinkTypeTag:
            textColor = kSPLightTextColor;
            highlightTextColor = kSPDarkTextColor;
            break;
        case SPLinkTypeUser:
            textColor = kSPLinkTextColor;
            highlightTextColor = kSPHighlightedLinkTextColor;
            isBold = YES;
            break;
        default:
            textColor = kSPDefaultTextColor;
            highlightTextColor = kSPDefaultTextColor;
            break;
    }
    
    [self setFont:isBold ? kSPBoldFont : kSPDefaultFont range:range];
    [self setColor:textColor range:range];
    [self setHighlightColor:highlightTextColor range:range];
}

@end
