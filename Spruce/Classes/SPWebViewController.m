//
//  SPWebViewController.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPWebViewController.h"

@interface SPWebViewController ()
@property (nonatomic, strong) UIBarButtonItem *spinnerView;
@end


@implementation SPWebViewController


#pragma mark -
#pragma mark NSObject

- (id)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        [self setUrl:url];
        [self setTitle:NSLocalizedString(@"Loading", nil)];
        [self setSpinnerView:[UIBarButtonItem spinner]];
    }
    return self;
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setWebView:[[UIWebView alloc] initWithFrame:self.view.bounds]];
    [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.webView setDelegate:self];
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
    [self.webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.webView stopLoading];
}


#pragma mark - 
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.navigationItem setRightBarButtonItem:self.spinnerView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.navigationItem setRightBarButtonItem:nil];
    
    [self setTitle:[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.navigationItem setRightBarButtonItem:nil];
}

@end
