//
//  LoginViewController.m
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 10/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "LoginViewController.h"
#import "SignupViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [userField becomeFirstResponder];
    
    //Create Title View with segments
    CGRect rect = self.navigationController.navigationBar.frame;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor clearColor];
    seg = [[UISegmentedControl alloc] initWithItems:@[@"Login", @"Signup"]];
    rect = seg.frame;
    rect.size.width = 200;
    rect.origin.x = (self.view.frame.size.width - rect.size.width)/2.0;
    rect.origin.y = rect.origin.y + 7;
    seg.frame = rect;
    seg.selectedSegmentIndex = 0;
    [seg addTarget:self action:@selector(toggleSegment) forControlEvents:UIControlEventValueChanged];
    [view addSubview:seg];
    
    self.navigationItem.titleView = view;
    
    avatarView.image = [UIImage imageNamed:@"fb.jpg"];
    avatarView.showShadow = YES;
    
    //Just for testing purposes
    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTripleTap:)];
    tripleTap.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:tripleTap];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [userField becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)toggleSegment {
    SignupViewController *signup = [[SignupViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
    [self.navigationController pushViewController:signup animated:YES];
    seg.selectedSegmentIndex = 0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == userField) {
        [passField becomeFirstResponder];
        [self searchForPhoto];
    } else {
        [self login];
    }
    return YES;
}

- (void)login {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[CapitalEngine sharedEngine] loginWithEmail:userField.text password:passField.text completion:^(BOOL success) {
        if (success) {
            [self dismissViewControllerAnimated:YES completion:NULL];
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kShouldLoadDashboard" object:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Login Failed"];
        }
    }];
}

- (void)searchForPhoto {
    NSString *emailHash = [userField.text md5];
    avatarView.imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://gravatar.com/avatar/%@?s=200", emailHash]];
}

- (void)handleTripleTap:(UIGestureRecognizer *)gestureRecognizer {
    userField.text = @"shabbirv@gmail.com";
    passField.text = @"12345678";
    [self login];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
