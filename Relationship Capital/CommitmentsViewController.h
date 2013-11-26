//
//  CommitmentsViewController.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 10/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommitmentDetailViewController.h"
#import "CapitalEngine.h"
#import "ProfileViewController.h"
#import "AddCommitmentViewController.h"
#import "CommitmentCell.h"

@interface CommitmentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    IBOutlet UITableView *theTableView;
    int selectedCommitmentId;
    UIRefreshControl *refreshControl;
}

@property (nonatomic, weak) User *user;
@property (nonatomic, weak) id delegate;

@end
