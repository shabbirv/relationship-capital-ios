//
//  LoginViewController.m
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 10/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "LoginViewController.h"
#import "SignupViewController.h"
#import <CommonCrypto/CommonDigest.h>

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
    UIView *view = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.frame];
    view.backgroundColor = [UIColor clearColor];
    seg = [[UISegmentedControl alloc] initWithItems:@[@"Login", @"Signup"]];
    CGRect rect = seg.frame;
    rect.size.width = 200;
    rect.origin.x = (self.view.frame.size.width - rect.size.width)/2.0;
    seg.frame = rect;
    seg.selectedSegmentIndex = 0;
    [seg addTarget:self action:@selector(toggleSegment) forControlEvents:UIControlEventValueChanged];
    [view addSubview:seg];
    
    self.navigationItem.titleView = view;
    
    avatarView.image = [UIImage imageNamed:@"fb.jpg"];
    avatarView.showShadow = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
        } else {
            [SVProgressHUD showErrorWithStatus:@"Login Failed"];
        }
    }];
}

- (void)searchForPhoto {
    NSString *emailHash = md5(userField.text);
    avatarView.imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://gravatar.com/avatar/%@?s=200", emailHash]];
}

NSString* md5( NSString *str ) {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, (int)strlen(cStr), result );
    
    return [[NSString
             stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1],
             result[2], result[3],
             result[4], result[5],
             result[6], result[7],
             result[8], result[9],
             result[10], result[11],
             result[12], result[13],
             result[14], result[15]
             ] lowercaseString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
