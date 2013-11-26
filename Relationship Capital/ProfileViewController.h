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
#import "FriendsTableViewCell.h"
#import "CommitmentDetailViewController.h"
#import "UserPickerViewController.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet AvatarView *avatarView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *commitmentCountLabel;
    IBOutlet UILabel *requestCountLabel;
    IBOutlet UITableView *theTableView;
    UIPopoverController *popOver;
    NSMutableArray *usersArray;
    BOOL youFollow;
    UIRefreshControl *refreshControl;
}

@property (nonatomic, weak) User *user;

- (void)tappedCommitment:(Commitment *)commitment;

@end
