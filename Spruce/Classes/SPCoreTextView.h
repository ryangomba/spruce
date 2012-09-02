//
//  SPCoreTextView.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@interface SPCoreTextView : UIView {
    BOOL _heightIsValid;
}

@property (nonatomic, strong) NSMutableAttributedString *attributedString;
@property (nonatomic, assign) CGFloat shadowOffset;
@property (nonatomic, strong) UIColor *shadowColor;

- (id)initWithOrigin:(CGPoint)origin width:(CGFloat)width;

@end
