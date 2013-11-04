//
//  SignupViewController.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/4/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "CapitalEngine.h"

@interface SignupViewController : UIViewController {
    UISegmentedControl *seg;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passField;
    IBOutlet UITextField *confirmPassField;
}

@end
