//
//  SPFeedViewController.h
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

@interface SPFeedViewController : SPViewController<UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableView_;
}

@property (nonatomic, strong) NSArray *feedItems;

@end
