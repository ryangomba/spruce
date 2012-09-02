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
    if (![imageURL isEqual:self.imageURL]) {
        self.imageURL = imageURL;
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
    
    UIImage *cachedDecodedImage = [[SPDecodedImageCache sharedCache] objectForKey:self.imageURL];
    if (cachedDecodedImage) {
        [self setImage:cachedDecodedImage];
        return;
    }
    
    // TODO flipped images still happening?
    
    NSURL *decodedImageURL = self.imageURL;
    NSMutableURLRequest *feedRequest = [NSMutableURLRequest requestWithURL:self.imageURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0f];
    [NSURLConnection sendAsynchronousRequest:feedRequest queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         [[SPImageDecodeQueue sharedQueue] addOperationWithBlock:^{
             UIImage *decodedImage = [UIImage decodedImageWithData:data];
             if (decodedImage) {
                 [[SPDecodedImageCache sharedCache] setObject:decodedImage forKey:decodedImageURL];
             }
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 if ([decodedImageURL isEqual:self.imageURL]) {
                     [self setImage:decodedImage ?: [UIImage imageWithData:data]];
                 }
             }];
         }];
     }];
}

@end
