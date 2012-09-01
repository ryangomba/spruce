//
//  SPAttributedStringCreator.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPAttributedStringCreator.h"

@interface SPAttributedStringCreator ()

@property (nonatomic, copy) NSString *string;
@property (nonatomic, strong) NSMutableAttributedString *attributedString;

@property (nonatomic, assign) CTTextAlignment textAlignment;
@property (nonatomic, assign) CTParagraphStyleRef paragraphStyle;
@property (nonatomic, assign) CTFontRef defaultFont;
@property (nonatomic, assign) CTFontRef boldFont;
@property (nonatomic, assign) CTFontRef largeFont;
@property (nonatomic, assign) CGColorRef defaultTextColor;
@property (nonatomic, assign) CGColorRef linkTextColor;
@property (nonatomic, assign) dispatch_queue_t attributeQueue;

@end

@implementation SPAttributedStringCreator


#pragma mark -
#pragma mark NSObject

- (void)dealloc {
//    if (_defaultFont != NULL) {
//        CFRelease(_defaultFont);
//    }
//    if (_boldFont != NULL) {
//        CFRelease(_boldFont);
//    }
//    if (_largeFont != NULL) {
//        CFRelease(_largeFont);
//    }
//    if (_defaultTextColor != NULL) {
//        CFRelease(_defaultTextColor);
//    }
//    if (_linkTextColor != NULL) {
//        CFRelease(_linkTextColor);
//    }
}

- (id)init {
    if (self = [super init]) {
        [self setAttributeQueue:dispatch_queue_create("attributedStringAttributorQueue", NULL)];
    }
    return self;
}


#pragma mark -
#pragma mark Private Property Methods
         
- (CTTextAlignment)textAlignment {
    return kCTLeftTextAlignment;
}

- (CTParagraphStyleRef)paragraphStyle {
    if (_paragraphStyle == NULL) {
        CTTextAlignment paragraphAlignment = self.textAlignment;
        CGFloat maxLineHeight = 18.0;
        CGFloat paragraphSpacingBefore = 2.0f;
        CTParagraphStyleSetting setting[3] = {
            {kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &paragraphAlignment},
            {kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight},
            {kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore}
        };
        _paragraphStyle = CTParagraphStyleCreate(setting, 3);
    }
    return _paragraphStyle;
}

- (CTFontRef)defaultFont {
    if (_defaultFont == NULL) {
        _defaultFont = CTFontCreateWithName((CFStringRef)@"HelveticaNeue", 15.0f, NULL);
    }
    return _defaultFont;
}

- (CTFontRef)boldFont {
    if (_boldFont == NULL) {
        _boldFont = CTFontCreateWithName((CFStringRef)@"HelveticaNeue-Bold", 15.0f, NULL);
    }
    return _boldFont;
}

- (CTFontRef)largeFont {
    if (_largeFont == NULL) {
        _largeFont = CTFontCreateWithName((CFStringRef)@"HelveticaNeue-Bold", 17.0f, NULL);
    }
    return _largeFont;
}

- (CGColorRef)defaultTextColor {
    if (_defaultTextColor == NULL) {
        _defaultTextColor = CGColorRetain([HEX_COLOR(0x555555) CGColor]);
    }
    return _defaultTextColor;
}

- (CGColorRef)linkTextColor {
    if (_linkTextColor == NULL) {
        _linkTextColor = CGColorRetain([HEX_COLOR(0x2386aa) CGColor]);
    }
    return _linkTextColor;
}

- (void)setAttributedString:(NSMutableAttributedString *)attributedString {
    _attributedString = attributedString;
}

- (void)addAttribute:(CFTypeRef)attribute value:(CFTypeRef)value range:(NSRange)range {
    dispatch_sync(self.attributeQueue, ^{
        [self.attributedString addAttribute:(__bridge id)attribute value:(__bridge id)value range:range];
    });
}


#pragma mark -
#pragma mark Property Methods

- (void)setString:(NSString *)string {
    _string = [string copy];
    
    [self setAttributedString:[[NSMutableAttributedString alloc] initWithString:_string]];
    
    NSRange fullRange = NSMakeRange(0, [_string length]);
    [self addAttribute:kCTFontAttributeName value:self.defaultFont range:fullRange];
    [self addAttribute:kCTParagraphStyleAttributeName value:self.paragraphStyle range:fullRange];
    [self addAttribute:kCTForegroundColorAttributeName value:self.defaultTextColor range:fullRange];
}


#pragma mark -
#pragma mark Public Methods

- (void)makeLarge {
    [self makeLarge:NSMakeRange(0, [self.string length])];
}

- (void)makeLarge:(NSRange)range {
    [self addAttribute:kCTFontAttributeName value:self.largeFont range:range];
}

- (void)makeBold {
    [self makeBold:NSMakeRange(0, [self.string length])];
}

- (void)makeBold:(NSRange)range {
    [self addAttribute:kCTFontAttributeName value:self.boldFont range:range];
}

- (void)makeLink {
    [self makeLink:NSMakeRange(0, [self.string length])];
}

- (void)makeLink:(NSRange)range {
    [self addAttribute:kCTForegroundColorAttributeName value:self.linkTextColor range:range];
}


#pragma mark -
#pragma mark Class Methods

+ (CGFloat)heightForAttributedString:(NSMutableAttributedString *)attributedString width:(CGFloat)width {
    NSAttributedString *attrStringCopy = [attributedString copy];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrStringCopy);
    CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), NULL, CGSizeMake(width, FLT_MAX), NULL);
    frameSize.height = ceil(frameSize.height);
    CFRelease(framesetter);
    return frameSize.height;
}


@end
