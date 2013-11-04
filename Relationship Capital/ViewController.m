//
//  ViewController.m
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 10/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    avatarView.image = [UIImage imageNamed:@"fb.jpg"];
    avatarView.showShadow = YES;
    
    //Create LineGraph
    LCLineChartData *d = [LCLineChartData new];
    d.xMin = 0;
    d.xMax = 31;
    d.title = @"The title for the legend";
    d.color = [UIColor redColor];
    d.itemCount = 30;
    
    NSMutableArray *vals = [NSMutableArray new];
    for(NSUInteger i = 0; i < d.itemCount; ++i) {
        [vals addObject:@(arc4random()%30)];
    }
    [vals sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    d.getData = ^(NSUInteger item) {
        float x = [vals[item] floatValue] * 1.5;
        int y = (int)item + 10;
        NSString *label1 = [NSString stringWithFormat:@"%d", y];
        NSString *label2 = [NSString stringWithFormat:@"%d", y];
        return [LCLineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2];
    };
    
    LCLineChartView *chartView = [[LCLineChartView alloc] initWithFrame:CGRectMake(0, self.navigationController.view.frame.size.height - 250, 320, 200)];
    chartView.yMin = 0;
    chartView.yMax = 50;
    chartView.ySteps = @[@"0.0",
                         [NSString stringWithFormat:@"%.02f", chartView.yMax / 2],
                         [NSString stringWithFormat:@"%.02f", chartView.yMax]];
    chartView.data = @[d];
    [chartView showLegend:NO animated:NO];
    [self.view addSubview:chartView];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (![User currentUser].isLoggedIn) {

        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        login.title = @"Relationship Capital Login";
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:login];
        nv.navigationBar.barTintColor = [UIColor colorWithRed:52/255.0f green:73/255.0f blue:94/255.0f alpha:1.0];
        nv.navigationBar.tintColor = [UIColor whiteColor];
        nv.navigationBar.translucent = NO;
        [self presentViewController:nv animated:YES completion:NULL];
    } else {
        avatarView.imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://gravatar.com/avatar/35cb2f99dae42d7369efb96aab77c81e?s=200"]];
        nameLabel.text = [User currentUser].email;
        scoreLabel.text = [NSString stringWithFormat:@"%d", arc4random()%100 + 1];
    }
    
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
