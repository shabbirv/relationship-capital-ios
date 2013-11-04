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
    ViewController *viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    viewController.title = @"Profile";
    viewController.tabBarItem.image = [UIImage imageNamed:@"user"];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    CommitmentsViewController *commitMents = [[CommitmentsViewController alloc] initWithNibName:@"CommitmentsViewController" bundle:nil];
    commitMents.title = @"Commitments";
    commitMents.tabBarItem.image = [UIImage imageNamed:@"doc"];
    UINavigationController *cNv = [[UINavigationController alloc] initWithRootViewController:commitMents];
    
    UITabBarController *tabCont = [[UITabBarController alloc] init];
    [tabCont setViewControllers:@[nv, cNv]];
    [self.window setRootViewController:tabCont];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
