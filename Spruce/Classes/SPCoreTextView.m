//
//  SPCoreTextView.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPCoreTextView.h"

#import <CoreText/CoreText.h>
#import "SPAttributedStringCreator.h"

@implementation SPCoreTextView

- (id)initWithOrigin:(CGPoint)origin width:(CGFloat)width {
    if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, width, 1)]) {
        [self setBackgroundColor:[UIColor clearColor]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (CGFloat)height {
    if (!_heightIsValid && self.attributedString) {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);
        CGSize sizeConstraints = CGSizeMake(self.frame.size.width, FLT_MAX);
        CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), NULL, sizeConstraints, NULL);
        CFRelease(framesetter);
        [self setHeight:ceil(frameSize.height)];
        [self setNeedsDisplay];
        _heightIsValid = YES;
    }
    return self.frame.size.height;
}

- (void)setAttributedString:(NSMutableAttributedString *)attrString {
    _heightIsValid = NO;
    _attributedString = attrString;
    [self height];
}

- (void)tapped:(UITapGestureRecognizer *)recognizer {
    NSInteger tapIndex = [self indexForTapAtPoint:[recognizer locationInView:self]];
    if (tapIndex != NSNotFound) {
        NSLog(@"TOUCHED LINK AT INDEX %d", tapIndex);
    }
}

- (NSInteger)indexForTapAtPoint:(CGPoint)point {
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
    
    NSInteger tapIndex = NSNotFound;
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

        if (CGRectContainsPoint(lineRect, point)) {
            NSArray *runs = (__bridge NSArray *)CTLineGetGlyphRuns(line);
            CGFloat runningLeftOffset = 0;
            
            for (id runObject in runs) {
                CTRunRef run = (__bridge CTRunRef)runObject;
                CGFloat runAscent, runDescent, runLeading;
                CGFloat runWidth = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &runAscent, &runDescent, &runLeading);
                CGFloat runHeight = runAscent + runDescent + runLeading;
                CGRect runRect = CGRectMake(lineRect.origin.x + runningLeftOffset, lineRect.origin.y, runWidth, runHeight);
                runningLeftOffset += runWidth;
                    
                if (CGRectContainsPoint(runRect, point)) {
                    NSDictionary *attributes = (__bridge NSDictionary *)CTRunGetAttributes(run);
                    BOOL isLink = [[attributes objectForKey:kSPAttributedStringLinkAttribute] boolValue];
                    
                    if (isLink) {
                        CFRange stringRange = CTRunGetStringRange(run);
                        tapIndex = stringRange.location;
                        break;
                    }
                }
            }
        }
        if (tapIndex != NSNotFound) {
            break;
        }
    }
    
    free(origins);
    return tapIndex;
}

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
