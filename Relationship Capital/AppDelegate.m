//
//  AppDelegate.m
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 10/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ProfileViewController *viewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    viewController.title = @"Profile";
    viewController.user = [User currentUser];
    viewController.tabBarItem.image = [UIImage imageNamed:@"user"];
    SVOrientationNavController *nv = [[SVOrientationNavController alloc] initWithRootViewController:viewController];
    
    CommitmentsViewController *commitMents = [[CommitmentsViewController alloc] initWithNibName:@"CommitmentsViewController" bundle:nil];
    commitMents.title = @"Commitments";
    commitMents.delegate = viewController;
    commitMents.user = [User currentUser];
    commitMents.tabBarItem.image = [UIImage imageNamed:@"doc"];
    SVOrientationNavController *cNv = [[SVOrientationNavController alloc] initWithRootViewController:commitMents];
    
    UISplitViewController *split = [[UISplitViewController alloc] init];
    [split setViewControllers:@[cNv, nv]];
    
    [self.window setRootViewController:split];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
