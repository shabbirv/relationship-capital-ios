//
//  LoginViewController.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 10/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapitalEngine.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AvatarView.h"
#import "NSString+Extensions.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *userField;
    IBOutlet UITextField *passField;
    UISegmentedControl *seg;
    IBOutlet AvatarView *avatarView;
}

@end
