//
//  SPAppDelegate.m
//  Spruce
//
//  Created by Ryan on 9/1/12.
//  Copyright (c) 2012 Ryan Gomba. All rights reserved.
//

#import "SPAppDelegate.h"

#import "SPUser.h"
#import "SPFeedViewController.h"
#import "SPWebViewController.h"
#import "SPUserViewController.h"

@implementation SPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    
    [self.window setBackgroundColor:[UIColor blackColor]];
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    // Custom Navigation Bar
    
    UIImage *navBarImage = [[UIImage imageNamed:@"navbar-bg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    NSDictionary *textAttributes = @{
        UITextAttributeFont: [UIFont fontWithName:@"Knockout-50Welterweight" size:22.0f],
        UITextAttributeTextColor: [UIColor whiteColor],
        UITextAttributeTextShadowColor: [UIColor blackColor],
        UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1.0f)],
    };
    [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:2.0f forBarMetrics:UIBarMetricsDefault];
    
    UIImage *defaultButtonImage = [[UIImage imageNamed:@"bar-button-default.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:15];
    [[UIBarButtonItem appearance] setBackgroundImage:defaultButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0f, 0.5f) forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"bar-button-back.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:15];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0.0f, 0.5f) forBarMetrics:UIControlStateNormal];
    
    // Root View Controller
    
    UIViewController *viewController = [[SPFeedViewController alloc] init];
    [self setRootNavigationController:[[UINavigationController alloc] initWithRootViewController:viewController]];
    [self.window setRootViewController:self.rootNavigationController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark -
#pragma mark URL Handling

- (void)openLinkOfType:(SPLinkType)linkType withInfo:(id)linkInfo {
    switch (linkType) {
        case SPLinkTypeWeb: {
            SPWebViewController *webVC = [[SPWebViewController alloc] initWithURL:(NSURL *)linkInfo];
            [self.rootNavigationController pushViewController:webVC animated:YES];
        } break;
        
        case SPLinkTypeTag: {
            //
        } break;
            
        case SPLinkTypeUser: {
            SPUser *user = [[SPUser alloc] init];
            [user setPk:(NSString *)linkInfo];
            SPUserViewController *userVC = [[SPUserViewController alloc] initWithUser:user];
            [self.rootNavigationController pushViewController:userVC animated:YES];
        } break;
            
        default:
            break;
    }
}

@end
