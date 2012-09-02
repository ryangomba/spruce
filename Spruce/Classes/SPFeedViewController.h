//
//  SPFeedViewController.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPPullToRefreshView.h"

@interface SPFeedViewController : SPViewController<UITableViewDataSource, UITableViewDelegate, SPPullToRefreshViewDelegate>

@property (nonatomic, strong) NSArray *feedItems;

@end
