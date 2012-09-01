//
//  UIImage+Decode.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "UIImage+Decode.h"

@implementation UIImage (Decode)

+ (UIImage *)decodedImageWithData:(NSData *)data {
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGImageRef newImage = CGImageCreateWithJPEGDataProvider(dataProvider,
                                                            NULL,
                                                            NO,
                                                            kCGRenderingIntentDefault);
    
    int width = CGImageGetWidth(newImage);
    int height = CGImageGetHeight(newImage);
    unsigned char *rawData = malloc(height * width * 4);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 colorspace, kCGImageAlphaNoneSkipFirst);
    
    if (context == NULL) {
        free(rawData);
        CGColorSpaceRelease(colorspace);
        CGDataProviderRelease(dataProvider);
        CGImageRelease(newImage);
        
        return nil;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), newImage);
    CGImageRef drawnImage = CGBitmapContextCreateImage(context);
    
    free(rawData);
    CGContextRelease(context);
    CGColorSpaceRelease(colorspace);
    
    UIImage *image = [UIImage imageWithCGImage:drawnImage];
    
    CGDataProviderRelease(dataProvider);
    CGImageRelease(newImage);
    CGImageRelease(drawnImage);
    
    return image;
}

@end
