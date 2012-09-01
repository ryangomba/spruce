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
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect frameRect = CGRectMake(point.x, 0, width, self.bounds.size.height - point.y); // TODO height
    CGPathAddRect(path, NULL, frameRect);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)string);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    
    CGContextRestoreGState(context);
}

@end
