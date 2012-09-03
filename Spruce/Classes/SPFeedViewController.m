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
#import "SPComposeViewController.h"

#define kDefaultCellHeight 100.0f

@interface SPFeedViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SPPullToRefreshView *pullToRefreshView;

@property (nonatomic, assign) BOOL isLoading;

@end


@implementation SPFeedViewController


#pragma mark -
#pragma mark NSObject

- (id)init {
    if (self = [super init]) {
        [self setTitle:NSLocalizedString(@"Timeline", nil)];
        [self.navigationItem setBackBarButtonItem:[UIBarButtonItem barButtonWithImageNamed:@"bar-glyph-feed.png"]];
    }
    return self;
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableView:[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain]];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView setRowHeight:kDefaultCellHeight];
    [self.view addSubview:self.tableView];
    
    [self setPullToRefreshView:[[SPPullToRefreshView alloc] initWithDelegate:self]];
    [self.tableView addSubview:self.pullToRefreshView];
    
    [self fetch];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *composeButton = [UIBarButtonItem barButtonWithImageNamed:@"bar-glyph-plus.png"];
    [composeButton setTarget:self action:@selector(compose)];
    [self.navigationItem setRightBarButtonItem:composeButton];
}


#pragma mark -
#pragma mark DataSource

- (void)fetch {
    if (self.isLoading) {
        return;
    }
    [self setIsLoading:YES];
    
    NSURL *feedURL = [NSURL appDotNetMainFeedURL];
    NSMutableURLRequest *feedRequest = [NSMutableURLRequest requestWithURL:feedURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:feedRequest queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         [[SPNetworkQueue sharedQueue] addOperationWithBlock:^{
             // TODO eager loading
             NSArray *feedArray = [data objectFromJSONData];
             NSMutableArray *feedItems = [NSMutableArray arrayWithCapacity:[feedArray count]];
             for (NSDictionary *feedDict in feedArray) {
                 [feedItems addObject:[[SPPost alloc] initWithDictionary:feedDict]];
             }
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 [self setFeedItems:feedItems];
                 [self.tableView reloadData];
                 [self setIsLoading:NO];
                 [self.pullToRefreshView dataSourceDidRefresh:self.tableView];
             }];
         }];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pullToRefreshView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.pullToRefreshView scrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark SPPullToRefreshViewDelegate

- (void)pullToRefreshViewDidTriggerRefresh:(SPPullToRefreshView *)view {
    [self fetch];
}

- (BOOL)networkDataSourceIsLoading:(SPPullToRefreshView *)view {
    return self.isLoading;
}



#pragma mark -
#pragma mark Button Callbacks

- (void)compose {
    SPComposeViewController *composeVC = [[SPComposeViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:composeVC];
    [self presentModalViewController:navController animated:YES];
}


@end
