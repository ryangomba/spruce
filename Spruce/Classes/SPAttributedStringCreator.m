//
//  SPAttributedStringCreator.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPAttributedStringCreator.h"

#import <CoreText/CoreText.h>
#import "SPLinkedEntity.h"

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
@property (nonatomic, assign) CGColorRef tagTextColor;
@property (nonatomic, assign) dispatch_queue_t attributeQueue;

@end

@implementation SPAttributedStringCreator


#pragma mark -
#pragma mark NSObject

- (void)dealloc {
//    if (self.defaultFont != NULL) {
//        CFRelease(self.defaultFont);
//    }
//    if (self.boldFont != NULL) {
//        CFRelease(self.boldFont);
//    }
//    if (self.largeFont != NULL) {
//        CFRelease(self.largeFont);
//    }
//    if (self.defaultTextColor != NULL) {
//        CFRelease(self.defaultTextColor);
//    }
//    if (self.linkTextColor != NULL) {
//        CFRelease(self.linkTextColor);
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
    if (self.paragraphStyle == NULL) {
        CTTextAlignment paragraphAlignment = self.textAlignment;
        CGFloat maxLineHeight = 18.0;
        CGFloat paragraphSpacingBefore = 2.0f;
        CTParagraphStyleSetting setting[3] = {
            {kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &paragraphAlignment},
            {kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight},
            {kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore}
        };
        self.paragraphStyle = CTParagraphStyleCreate(setting, 3);
    }
    return self.paragraphStyle;
}

- (CTFontRef)defaultFont {
    if (self.defaultFont == NULL) {
        self.defaultFont = kSPDefaultCTFont;
    }
    return self.defaultFont;
}

- (CTFontRef)boldFont {
    if (self.boldFont == NULL) {
        self.boldFont = kSPBoldCTFont;
    }
    return self.boldFont;
}

- (CTFontRef)largeFont {
    if (self.largeFont == NULL) {
        self.largeFont = kSPLargeCTFont;
    }
    return self.largeFont;
}

- (CGColorRef)defaultTextColor {
    if (self.defaultTextColor == NULL) {
        self.defaultTextColor = CGColorRetain([kSPDefaultTextColor CGColor]);
    }
    return self.defaultTextColor;
}

- (CGColorRef)linkTextColor {
    if (self.linkTextColor == NULL) {
        self.linkTextColor = CGColorRetain([kSPLinkTextColor CGColor]);
    }
    return self.linkTextColor;
}

- (CGColorRef)tagTextColor {
    if (self.tagTextColor == NULL) {
        self.tagTextColor = CGColorRetain([kSPLightTextColor CGColor]);
    }
    return self.tagTextColor;
}

- (void)setAttributedString:(NSMutableAttributedString *)attributedString {
    self.attributedString = attributedString;
}

- (void)addAttribute:(CFTypeRef)attribute value:(CFTypeRef)value range:(NSRange)range {
    dispatch_sync(self.attributeQueue, ^{
        [self.attributedString addAttribute:(__bridge id)attribute value:(__bridge id)value range:range];
    });
}

- (void)addCustomAttribute:(NSString *)attribute value:(id)value range:(NSRange)range {
    dispatch_sync(self.attributeQueue, ^{
        [self.attributedString addAttribute:attribute value:value range:range];
    });
}


#pragma mark -
#pragma mark Property Methods

- (void)setString:(NSString *)string {
    self.string = [string copy];
    
    [self setAttributedString:[[NSMutableAttributedString alloc] initWithString:self.string]];
    
    NSRange fullRange = NSMakeRange(0, [self.string length]);
    [self addAttribute:kCTFontAttributeName value:self.defaultFont range:fullRange];
    [self addAttribute:kCTParagraphStyleAttributeName value:self.paragraphStyle range:fullRange];
    [self addAttribute:kCTForegroundColorAttributeName value:self.defaultTextColor range:fullRange];
}


#pragma mark -
#pragma mark Public Methods

- (void)makeLarge {
    NSRange fullRange = NSMakeRange(0, [self.string length]);
    [self addAttribute:kCTFontAttributeName value:self.largeFont range:fullRange];
}

- (void)attachLinkedEntity:(SPLinkedEntity *)linkedEntity {
    if (!linkedEntity.linkInfo) {
        return; // sanity check
    }
    
    NSRange range = linkedEntity.textRange;
    [self addCustomAttribute:kSPAttributedStringLinkType value:@(linkedEntity.linkType) range:range];
    [self addCustomAttribute:kSPAttributedStringLinkInfo value:linkedEntity.linkInfo range:range];
    
    switch (linkedEntity.linkType) {
        case SPLinkTypeWeb:
            [self addAttribute:kCTForegroundColorAttributeName value:self.linkTextColor range:range];
            break;
        case SPLinkTypeTag:
            [self addAttribute:kCTForegroundColorAttributeName value:self.tagTextColor range:range];
            break;
        case SPLinkTypeUser:
            [self addAttribute:kCTForegroundColorAttributeName value:self.linkTextColor range:range];
            [self addAttribute:kCTFontAttributeName value:self.boldFont range:range];
            break;
        default:
            break;
    }
}


@end
