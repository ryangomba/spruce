//
//  SPWebViewController.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPWebViewController.h"

@implementation SPWebViewController

- (id)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        [self setTitle:NSLocalizedString(@"Loading", nil)];
        [self setUrl:url];
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setWebView:[[UIWebView alloc] initWithFrame:self.view.bounds]];
    [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.webView setDelegate:self];
    [self.view addSubview:self.webView];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
    [self.webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIView *spinnerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 26, _spinner.height)];
    [spinnerContainer addSubview:_spinner];
    UIBarButtonItem *spinnerItem = [[UIBarButtonItem alloc] initWithCustomView:spinnerContainer];
    [self.navigationItem setRightBarButtonItem:spinnerItem];
}


#pragma mark - 
#pragma mark UIWebViewDelegate}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_spinner stopAnimating];
    
    [self setTitle:[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_spinner stopAnimating];
}

@end
