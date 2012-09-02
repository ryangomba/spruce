//
//  SPImageView.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@interface SPImageView : UIImageView

@property (nonatomic, strong) NSURL *imageURL;

- (id)initWithFrame:(CGRect)frame overlay:(BOOL)overlay;

@end
