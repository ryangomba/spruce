//
//  SPCoreTextView.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPCoreTextView.h"

#import <CoreText/CoreText.h>
#import "NSMutableAttributedString+Attributes.h"
#import "SPAppDelegate.h"

#define kSPCoreTextHeightCacheSize 100


@interface SPCoreTextView ()

@property (nonatomic, assign) BOOL heightIsValid;
@property (nonatomic, assign) CGPoint touchPoint;

@end


@implementation SPCoreTextView

#pragma mark -
#pragma mark NSObject

- (id)initWithOrigin:(CGPoint)origin width:(CGFloat)width {
    if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, width, 1)]) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setExclusiveTouch:YES];
    }
    return self;
}


#pragma mark -
#pragma mark Class Methods

+ (CGFloat)heightWithAttributedString:(NSMutableAttributedString *)string width:(CGFloat)width {
    SPCoreTextHeightCache *heightCache = [SPCoreTextHeightCache sharedCache];
    NSNumber *height = [heightCache objectForKey:string];
    if (!height) {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)string);
        CGSize sizeConstraints = CGSizeMake(width, FLT_MAX);
        CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), NULL, sizeConstraints, NULL);
        CFRelease(framesetter);
        height = @(ceil(frameSize.height));
        [heightCache setObject:height forKey:string];
    }
    return [height floatValue];
}


#pragma mark -
#pragma mark Public Methods

- (void)setAttributedString:(NSMutableAttributedString *)attrString {
    self.heightIsValid = NO;
    _attributedString = attrString;
    [self height];
}

- (CGFloat)height {
    if (!_heightIsValid && self.attributedString) {
        [self setHeight:[self.class heightWithAttributedString:self.attributedString width:self.width]];
        [self setNeedsDisplay];
        self.heightIsValid = YES;
    }
    return self.frame.size.height;
}


#pragma mark -
#pragma mark Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    [self setTouchPoint:[touch locationInView:self]];
    [self handleTapAtPoint:self.touchPoint forTouchEvent:UIControlEventTouchDown];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTapAtPoint:self.touchPoint forTouchEvent:UIControlEventTouchCancel];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTapAtPoint:self.touchPoint forTouchEvent:UIControlEventTouchUpInside];
}

- (void)handleTapAtPoint:(CGPoint)point forTouchEvent:(UIControlEvents)touchEvent {
    point.y = self.height - point.y; // flip to match text
    
    // create frame
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect frameRect = CGRectMake(0, 0, self.width, self.height); // TODO height
    CGPathAddRect(path, NULL, frameRect);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(framesetter);
    CFRelease(path);
    
    // iterate lines
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    CGPoint *origins = malloc(sizeof(CGPoint) * [lines count]);
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    NSInteger lineIndex = 0;
    
    for (id lineObject in lines) {
        CTLineRef line = (__bridge CTLineRef)lineObject;
        CGFloat lineAscent, lineDescent, lineLeading;
        CGFloat lineWidth = CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        CGFloat lineHeight = lineAscent + lineDescent + lineLeading;
        CGFloat lineX = origins[lineIndex].x;
        CGFloat lineY = origins[lineIndex].y;
        CGRect lineRect = CGRectMake(lineX, lineY, lineWidth, lineHeight);
        lineIndex++;
        
        // find link index

        if (CGRectContainsPoint(lineRect, point)) {
            CFIndex tapIndex = CTLineGetStringIndexForPosition(line, point);
            [self handleTapAtIndex:tapIndex forTouchEvent:touchEvent];
            break;
        }
    }
    
    free(origins);
}

- (void)handleTapAtIndex:(NSInteger)tapIndex forTouchEvent:(UIControlEvents)touchEvent {
    BOOL needsRedraw = [self.attributedString highlightSpan:(touchEvent == UIControlEventTouchDown) atIndex:tapIndex];
    if (needsRedraw) {
        [self setNeedsDisplay];
    }
    
    if (touchEvent == UIControlEventTouchUpInside) {
        NSURL *url = [self.attributedString urlAtIndex:tapIndex];
        if (url) {
            [(SPAppDelegate *)[[UIApplication sharedApplication] delegate] openURL:url];
        }
    }
}


#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect {    
    // set up
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, self.height);
	CGContextScaleCTM(context, 1.0, -1.0);
    
    // create frame
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect frameRect = CGRectMake(0, 0, self.width, self.height);
    CGPathAddRect(path, NULL, frameRect);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(framesetter);
    CFRelease(path);
    
    // draw
    
    if (self.shadowColor) {
        CGContextSetShadowWithColor(context, CGSizeMake(0, self.shadowOffset), 0, [self.shadowColor CGColor]);
    }
    CTFrameDraw(frame, context);
    
    // release
    
    CFRelease(frame);
    
    // break down
    
    CGContextRestoreGState(context);
}

@end


@implementation SPCoreTextHeightCache

- (id)init {
    if (self = [super init]) {
        [self setCountLimit:kSPCoreTextHeightCacheSize];
    }
    return self;
}

+ (SPCoreTextHeightCache *)sharedCache {
    SHARED_INSTANCE_USING_BLOCK(^{
        return [[SPCoreTextHeightCache alloc] init];
    });
}

@end
