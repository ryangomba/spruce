//
//  NSMutableAttributedString+Attributes.m
//  Spruce
//
//  Created by Ryan on 9/2/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "NSMutableAttributedString+Attributes.h"

#import <CoreText/CoreText.h>

#define kURLKey @"URL"
#define kDefaultColorKey @"defaultColor"
#define kHighlightColorKey @"highlightColor"

@implementation NSMutableAttributedString (Attributes)


#pragma mark -
#pragma mark Font

- (void)setFont:(UIFont *)font {
    [self setFont:font range:NSMakeRange(0, [self length])];
}

- (void)setFont:(UIFont *)font range:(NSRange)range {
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
	if (fontRef) {
        [self removeAttribute:(__bridge NSString *)kCTFontAttributeName range:range];
        [self addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:range];
        CFRelease(fontRef);
    }
}


#pragma mark -
#pragma mark Bold

- (void)setBold:(BOOL)bold {
    [self setBold:bold range:NSMakeRange(0, [self length])];
}

- (void)setBold:(BOOL)bold range:(NSRange)range {
	NSUInteger startPoint = range.location;
	NSRange effectiveRange;
    while (startPoint < NSMaxRange(range)) {
		CTFontRef currentFont = (__bridge CTFontRef)[self attribute:(__bridge NSString *)kCTFontAttributeName atIndex:startPoint effectiveRange:&effectiveRange];
		NSRange fontRange = NSIntersectionRange(range, effectiveRange);
		CTFontRef newFont = CTFontCreateCopyWithSymbolicTraits(currentFont, 0.0, NULL, (bold ? kCTFontBoldTrait : 0), kCTFontBoldTrait);
		if (newFont) {
			[self removeAttribute:(__bridge NSString *)kCTFontAttributeName range:fontRange];
			[self addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)newFont range:fontRange];
			CFRelease(newFont);
		}
		startPoint = NSMaxRange(effectiveRange);
    }
}


#pragma mark -
#pragma mark Underlined

- (void)setUnderlined:(BOOL)underlined {
    [self setUnderlined:underlined range:NSMakeRange(0, [self length])];
}

- (void)setUnderlined:(BOOL)underlined range:(NSRange)range {
    NSNumber *underlineStyle = underlined ? @(kCTUnderlineStyleSingle) : @(kCTUnderlineStyleNone);
    [self removeAttribute:(__bridge NSString *)kCTUnderlineStyleAttributeName range:range];
    [self addAttribute:(__bridge NSString *)kCTUnderlineStyleAttributeName value:underlineStyle range:range];
}


#pragma mark -
#pragma mark Color

- (void)setColor:(UIColor *)color {
    [self setColor:color range:NSMakeRange(0, [self length])];
}

- (void)setColor:(UIColor *)color range:(NSRange)range {
    [self removeAttribute:kDefaultColorKey range:range];
    [self addAttribute:kDefaultColorKey value:color range:range];
    [self applyColor:color range:range];
}

- (void)applyColor:(UIColor *)color range:(NSRange)range {
    [self removeAttribute:(__bridge NSString *)kCTForegroundColorAttributeName range:range];
    [self addAttribute:(__bridge NSString *)kCTForegroundColorAttributeName value:(__bridge id)color.CGColor range:range];
}


#pragma mark -
#pragma mark Highlight Color

- (void)setHighlightColor:(UIColor *)color {
    [self setHighlightColor:color range:NSMakeRange(0, [self length])];
}

- (void)setHighlightColor:(UIColor *)color range:(NSRange)range {
    [self removeAttribute:kHighlightColorKey range:range];
    if (color) {
        [self addAttribute:kHighlightColorKey value:color range:range];
    }
}


#pragma mark -
#pragma mark Paragraph

- (void)setTextAlignment:(UITextAlignment)textAlignment
        paragraphSpacing:(CGFloat)paragraphSpacing
           minLineHeight:(CGFloat)minLineHeight
           maxLineHeight:(CGFloat)maxLineHeight {
    
    CTTextAlignment paragraphAlignment;
    switch (textAlignment) {
        case UITextAlignmentCenter:
            paragraphAlignment = kCTCenterTextAlignment;
            break;
        case UITextAlignmentRight:
            paragraphAlignment = kCTRightTextAlignment;
            break;
        default:
            paragraphAlignment = kCTLeftTextAlignment;
            break;
    }
    
    CTParagraphStyleSetting settings[4] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &paragraphAlignment},
        {kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight},
        {kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacing}
    };
    
    NSRange fullRange = NSMakeRange(0, [self length]);
    CTParagraphStyleRef paragraphStyleRef = CTParagraphStyleCreate(settings, 3);
    [self removeAttribute:(__bridge NSString *)kCTParagraphStyleAttributeName range:fullRange];
    [self addAttribute:(__bridge NSString *)kCTParagraphStyleAttributeName value:(__bridge id)paragraphStyleRef range:fullRange];
}


#pragma mark -
#pragma mark Links

- (void)setURL:(NSURL *)url range:(NSRange)range {
    [self addAttribute:kURLKey value:url range:range];
}

- (NSURL *)urlAtIndex:(NSInteger)index {
    return [self attribute:kURLKey atIndex:index effectiveRange:NULL];
}


#pragma mark -
#pragma mark Highlighting

- (BOOL)highlightSpan:(BOOL)highlight atIndex:(NSInteger)index {
    NSRange highlightRange;
    UIColor *highlightColor = [self attribute:kHighlightColorKey atIndex:index effectiveRange:&highlightRange];
    if (highlightColor) {
        NSRange colorRange;
        UIColor *color = highlight ? highlightColor : [self attribute:kDefaultColorKey atIndex:index effectiveRange:&colorRange];
        [self applyColor:color range:highlightRange];
        return YES;
    }
    return NO;
}

@end
