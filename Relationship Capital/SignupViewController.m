//
//  SignupViewController.m
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/4/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

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
    
    //Create Title View with segments
    UIView *view = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.frame];
    view.backgroundColor = [UIColor clearColor];
    seg = [[UISegmentedControl alloc] initWithItems:@[@"Login", @"Signup"]];
    CGRect rect = seg.frame;
    rect.size.width = 200;
    rect.origin.x = (self.view.frame.size.width - rect.size.width)/2.0;
    seg.frame = rect;
    seg.selectedSegmentIndex = 1;
    [seg addTarget:self action:@selector(toggleSegment) forControlEvents:UIControlEventValueChanged];
    [view addSubview:seg];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.titleView = view;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [emailField becomeFirstResponder];
    [super viewDidAppear:YES];
}

- (void)toggleSegment {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == emailField) {
        [passField becomeFirstResponder];
    } else if (textField == passField) {
        [confirmPassField becomeFirstResponder];
    } else {
        [self signup];
    }
    return YES;
}

- (void)signup {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    [[CapitalEngine sharedEngine] signupWithEmail:emailField.text password:passField.text completion:^(NSDictionary *dict, NSError *error) {
        if (error && dict) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"error"]];
        } else {
            if (!error) {
                [self dismissViewControllerAnimated:YES completion:NULL];
            }
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
