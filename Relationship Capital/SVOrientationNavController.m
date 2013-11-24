//
//  OrientationNavigationController.m
//
//  Created by Shabbir Vijapura on 9/19/12.
//  Copyright (c) 2012 Depaul University. All rights reserved.
//

#import "SVOrientationNavController.h"

@interface SVOrientationNavController ()

@end

@implementation SVOrientationNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
