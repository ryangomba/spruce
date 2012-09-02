//
//  SPAttributedStringDrawer.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPAttributedStringDrawer.h"

#import <CoreText/CoreText.h>
#import "SPAttributedStringCreator.h"

@implementation SPAttributedStringDrawer

- (id)initWithPosition:(CGPoint)position width:(CGFloat)width {
    if (self = [super init]) {
        [self setPosition:position];
        [self setWidth:width];
    }
    return self;
}

- (CGFloat)drawnHeight {
    if (!_heightIsValid) {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);
        CGSize sizeConstraints = CGSizeMake(self.width, FLT_MAX);
        CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), NULL, sizeConstraints, NULL);
        frameSize.height = ceil(frameSize.height);
        CFRelease(framesetter);
        _drawnHeight = frameSize.height;
        _heightIsValid = YES;
    }
    return _drawnHeight;
}

- (CGRect)frame {
    return CGRectMake(self.position.x, self.position.y, self.width, self.drawnHeight);
}

- (void)setAttributedString:(NSMutableAttributedString *)attrString {
    _heightIsValid = NO;
    _attributedString = attrString;
}

- (NSInteger)indexForTapAtPoint:(CGPoint)point inView:(UIView *)view {
    point.y = view.bounds.size.height - point.y; // flip to match text
    
    // create frame
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat bottomY = view.bounds.size.height - self.position.y - self.drawnHeight; // because the text is flipped
    CGRect frameRect = CGRectMake(self.position.x, bottomY, self.width, self.drawnHeight); // TODO height
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
        CGFloat lineX = self.position.x + origins[lineIndex].x;
        CGFloat lineY = bottomY + origins[lineIndex].y;
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

//- (NSInteger)indexForTapAtPoint:(CGPoint)point inView:(UIView *)view {
//    
//    CGFloat height = self.drawnHeight;
//    
//    NSLog(@"LOOKING FOR (%f, %f)", point.x, point.y);
//    point.y = view.bounds.size.height - point.y;
//    NSLog(@"LOOKING FOR LOCAL (%f, %f)", point.x, point.y);
//    
//    // set up
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CFRetain(context);
//    CGContextSaveGState(context);
//    
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//	CGContextTranslateCTM(context, 0, view.bounds.size.height);
//	CGContextScaleCTM(context, 1.0, -1.0);
//    
//    // create frame
//    
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGRect frameRect = CGRectMake(self.position.x, self.position.y, self.width, height); // TODO height
//    CGPathAddRect(path, NULL, frameRect);
//    
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
//    CFRelease(framesetter);
//    CFRelease(path);
//    
//    // iterate lines
//
//    CFIndex stringRange = -1;
//    
//    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
//    CGPoint *origins = malloc(sizeof(CGPoint) * [lines count]);
//    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
//    NSInteger lineIndex = 0;
//    
//    NSLog(@"C %d", lines.count);
//    
//    for (id lineObject in lines) {
//        CTLineRef line = (__bridge CTLineRef)lineObject;
//        CGRect lineRect = CTLineGetImageBounds(line, context);
//        lineRect.origin.x += self.position.x + origins[lineIndex].x;
//        lineRect.origin.y += self.position.y + origins[lineIndex].y;
//        lineIndex ++;
//        NSLog(@"LINE %d (%f %f) (%f %f)", lineIndex, lineRect.origin.x, lineRect.origin.y, lineRect.size.width, lineRect.size.height);
//        
//        CGFloat runningLeftOffset = 0;
//        if (CGRectContainsPoint(lineRect, point) || YES) {
//            NSArray *runs = (__bridge NSArray *)CTLineGetGlyphRuns(line);
//            for (id runObject in runs) {
//                CTRunRef run = (__bridge CTRunRef)runObject;
//                CFRange runRange = CTRunGetStringRange(run);
//                
//                CGFloat runAscent, runDescent, runLeading;
//                CGFloat runWidth = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &runAscent, &runDescent, &runLeading);
//                CGRect runRect = CGRectMake(lineRect.origin.x + runningLeftOffset,
//                                              lineRect.origin.y,
//                                              runWidth,
//                                              runAscent + runDescent + runLeading);
//                
//                runningLeftOffset += runWidth;
//                
//                
//                
////                CGRect runRect = CTRunGetImageBounds(run, context, CFRangeMake(0, 0));
//                NSLog(@"RUN %d (%f %f) (%f %f)", lineIndex, runRect.origin.x, runRect.origin.y, runRect.size.width, runRect.size.height);
////                runRect.origin.x += lineRect.origin.x;
////                runRect.origin.y += lineRect.origin.y;
//                NSLog(@"RUNN %d (%f %f) (%f %f)", lineIndex, runRect.origin.x, runRect.origin.y, runRect.size.width, runRect.size.height);
//                
//                NSDictionary *attributes = (__bridge NSDictionary *)CTRunGetAttributes(run);
//                BOOL isLink = [[attributes objectForKey:kSPAttributedStringLinkAttribute] boolValue];
//                NSLog(@"IS LINK? %d", isLink);
//                
//                
//                
//                
//                if (isLink && CGRectContainsPoint(runRect, point)) {
//                    NSLog(@"IT CONTAINS IT FUCKER!");
//                    CTRunGetStringIndices(run, runRange, &stringRange);
//                    
//                    CFRange i = CTRunGetStringRange(run);
//                    NSLog(@"%d %d", (NSInteger)i.location, (NSInteger)i.length);
//                    
//                    [HEX_COLOR(0x000000) set];
//                    CGContextBeginPath(context);
//                    CGContextAddRect(context, runRect);
//                    CGContextFillPath(context);
//                }
//            }
//        }
//    }
//    
//    free(origins);
//    
//    // draw
//    
//    if (self.shadowColor) {
//        CGContextSetShadowWithColor(context, CGSizeMake(0, self.shadowOffset), 0, [self.shadowColor CGColor]);
//    }
//    CTFrameDraw(frame, context);
//    
//    // release
//    
//    CFRelease(frame);
//    
//    // break down
//    
//    CGContextRestoreGState(context);
//    CFRelease(context);
//    
//    // return
//    
//    return stringRange;
//}

- (void)drawInView:(UIView *)view {
    // set up
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, view.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
    
    // create frame
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect frameRect = CGRectMake(self.position.x, 0, self.width, view.bounds.size.height - self.position.y); // TODO height
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
