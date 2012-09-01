//
//  UIView+AttributedString.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "UIView+AttributedString.h"

#import <CoreText/CoreText.h>

@implementation UIView (AttributedString)

- (void)drawAttributedString:(NSMutableAttributedString *)string atPoint:(CGPoint)point width:(CGFloat)width {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)string);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect frameRect = CGRectMake(point.x, 0, width, FLT_MAX);
    CGPathAddRect(path, NULL, frameRect);
    
    CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), NULL, CGSizeMake(width, FLT_MAX), NULL);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    frameRect.size.height = ceilf(frameSize.height);
    frameRect.origin.y = CGRectGetMaxY(self.bounds) - frameRect.size.height - point.y;
    
    CFRelease(path);
    CFRelease(frame);
    
    path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, frameRect);
    frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    if (frame) {
        CTFrameDraw(frame, context);
        CFRelease(frame);
    }
    
    CGContextRestoreGState(context);
    CFRelease(path);
    CFRelease(framesetter);
}

@end
