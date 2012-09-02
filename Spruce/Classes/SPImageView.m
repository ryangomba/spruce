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

@implementation SPImageView

- (id)initWithFrame:(CGRect)frame overlay:(BOOL)overlay {
    self = [super initWithFrame:frame];
    if (self) {
        if (overlay) {
            UIImageView *overlay = [[UIImageView alloc] initWithFrame:self.bounds];
            [overlay setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
            [overlay setImage:[[UIImage imageNamed:@"avatar-overlay.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:2]];
            [self addSubview:overlay];
        }
    }
    return self;
}

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
    NSMutableURLRequest *feedRequest = [NSMutableURLRequest requestWithURL:_imageURL];
    [NSURLConnection sendAsynchronousRequest:feedRequest queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         NSURL *decodedImageURL = _imageURL;
         [[SPImageDecodeQueue sharedQueue] addOperationWithBlock:^{
             UIImage *decodedImage = [UIImage decodedImageWithData:data];
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 if ([decodedImageURL isEqual:_imageURL]) {
                     [self setImage:decodedImage ?: [UIImage imageWithData:data]];
                 }
             }];
         }];
     }];
}

@end
