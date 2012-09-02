//
//  SPImageView.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPImageView.h"

#import "UIImage+Decode.h"
#import "SPImageLoadQueue.h"
#import "SPImageDecodeQueue.h"
#import "SPDecodedImageCache.h"

@implementation SPImageView

- (void)setImageURL:(NSURL *)imageURL {
    if (![imageURL isEqual:_imageURL]) {
        _imageURL = imageURL;
        [self setImage:nil];
        [self fetchImage];
    }
}


#pragma mark -
#pragma mark Private Methods

- (void)fetchImage {
    if (!_imageURL) {
        return;
    }
    
    UIImage *cachedDecodedImage = [[SPDecodedImageCache sharedCache] objectForKey:_imageURL];
    if (cachedDecodedImage) {
        [self setImage:cachedDecodedImage];
        return;
    }
    
    // TODO flipped images still happening?
    
    NSMutableURLRequest *feedRequest = [NSMutableURLRequest requestWithURL:_imageURL];
    [NSURLConnection sendAsynchronousRequest:feedRequest queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         NSURL *decodedImageURL = _imageURL;
         [[SPImageDecodeQueue sharedQueue] addOperationWithBlock:^{
             UIImage *decodedImage = [UIImage decodedImageWithData:data];
             if (decodedImage) {
                 [[SPDecodedImageCache sharedCache] setObject:decodedImage forKey:decodedImageURL];
             }
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 if ([decodedImageURL isEqual:_imageURL]) {
                     [self setImage:decodedImage ?: [UIImage imageWithData:data]];
                 }
             }];
         }];
     }];
}

@end
