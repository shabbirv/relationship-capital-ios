//
//  ViewController.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 10/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "CapitalEngine.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "AvatarView.h"
#import <ios-linechart/LineChart.h>

@interface ViewController : UIViewController {
    IBOutlet AvatarView *avatarView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *scoreLabel;
}

@end
