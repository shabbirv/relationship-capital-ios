//
//  CommitmentDetailViewController.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/4/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit/FlatUIKit.h>
#import "Commitment.h"
#import "CapitalEngine.h"
#import "NSString+Extensions.h"

@interface CommitmentDetailViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate> {
    IBOutlet FUIButton *completeButton;
    IBOutlet FUIButton *declineButton;
    IBOutlet FUIButton *acceptButton;
    IBOutlet UITextView *detailsTextView;
    IBOutlet UIView *controlsView;
    IBOutlet UITableView *theTableView;
    IBOutlet UIToolbar *fieldBar;
    IBOutlet UITextField *commentField;
    NSMutableArray *commentsArray;
    BOOL dontClear;
}

@property (nonatomic, weak) Commitment *commitment;

- (IBAction)sendAction;

@end
