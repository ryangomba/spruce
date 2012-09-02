//
//  SPFeedViewController.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPFeedViewController.h"

#import "NSURL+AppDotNet.h"
#import "JSONKit.h"
#import "SPUser.h"
#import "SPPost.h"
#import "SPFeedPostTableViewCell.h"
#import "SPNetworkQueue.h"

@implementation SPFeedViewController


#pragma mark -
#pragma mark NSObject

- (id)init {
    if (self = [super init]) {
        [self setTitle:NSLocalizedString(@"Timeline", nil)];
        
        UIImage *backImage = [UIImage imageNamed:@"bar-glyph-feed.png"];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
        [backButtonItem setStyle:UIBarButtonItemStyleBordered];
        [backButtonItem setImage:backImage];
        [self.navigationItem setBackBarButtonItem:backButtonItem];
    }
    return self;
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableView_ = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [tableView_ setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [tableView_ setBackgroundColor:HEX_COLOR(0xebebe9)];
    [tableView_ setDataSource:self];
    [tableView_ setDelegate:self];
    [self.view addSubview:tableView_];
    
    NSURL *feedURL = [NSURL appDotNetMainFeedURL];
    NSMutableURLRequest *feedRequest = [NSMutableURLRequest requestWithURL:feedURL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:feedRequest queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         // TODO eager loading
         NSArray *feedArray = [data objectFromJSONData];
         NSMutableArray *feedItems = [NSMutableArray arrayWithCapacity:[feedArray count]];
         for (NSDictionary *feedDict in feedArray) {
             [feedItems addObject:[[SPPost alloc] initWithDictionary:feedDict]];
         }
         [self setFeedItems:feedItems];
         [tableView_ reloadData];
    }];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feedItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPPost *post = [self.feedItems objectAtIndex:indexPath.row];
    return [SPFeedPostTableViewCell heightWithPost:post];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"postCell";
    SPFeedPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[SPFeedPostTableViewCell alloc] initWithReuseIdentifier:reuseIdentifier];
    }
    SPPost *post = [self.feedItems objectAtIndex:indexPath.row];
    [cell setPost:post];
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

//


@end
