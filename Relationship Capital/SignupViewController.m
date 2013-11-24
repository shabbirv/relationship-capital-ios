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
    CGRect rect = self.navigationController.navigationBar.frame;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor clearColor];
    seg = [[UISegmentedControl alloc] initWithItems:@[@"Login", @"Signup"]];
    rect = seg.frame;
    rect.size.width = 200;
    rect.origin.x = (self.view.frame.size.width - rect.size.width)/2.0;
    rect.origin.y = rect.origin.y + 7;
    seg.frame = rect;
    seg.selectedSegmentIndex = 1;
    [seg addTarget:self action:@selector(toggleSegment) forControlEvents:UIControlEventValueChanged];
    [view addSubview:seg];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.titleView = view;
    
    [userField becomeFirstResponder];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)toggleSegment {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == userField) {
        [nameField becomeFirstResponder];
    } else if (textField == nameField) {
        [emailField becomeFirstResponder];
    } else if (textField == emailField) {
        [passField becomeFirstResponder];
    } else if (textField == passField) {
        [confirmPassField becomeFirstResponder];
    } else {
        [self signup];
    }
    return YES;
}

- (void)signup {
    if (![passField.text isEqualToString:confirmPassField.text])
        [SVProgressHUD showErrorWithStatus:@"Please confirm your passwords match"];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    NSString *first = [[nameField.text componentsSeparatedByString:@" "] firstObject];
    NSString *last = [[nameField.text componentsSeparatedByString:@" "] lastObject];
    NSLog(@"%@ %@", first, last);
    NSDictionary *dict = @{@"user[email]": emailField.text,
                           @"user[password]" : passField.text,
                           @"user[password_confirmation]" : passField.text,
                           @"user[user_name]" : userField.text,
                           @"user[first_name]" : first,
                           @"user[last_name" : last
                            };
    
    [[CapitalEngine sharedEngine] signupWithDict:dict completion:^(NSDictionary *dict, NSError *error) {
        if (error && dict) {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"error"]];
        } else {
            if (!error) {
                [self dismissViewControllerAnimated:YES completion:NULL];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kShouldLoadDashboard" object:nil];
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
