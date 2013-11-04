//
//  CommitmentDetailViewController.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/4/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit/FlatUIKit.h>

typedef enum {
    CommitmentStatusAvailable,
    CommitmentStatusAccepted,
    CommitmentStatusCompleted
} CommitmentStatus;

@interface CommitmentDetailViewController : UIViewController {
    IBOutlet FUIButton *completeButton;
    IBOutlet FUIButton *declineButton;
    IBOutlet FUIButton *acceptButton;
}

@property (nonatomic, assign) CommitmentStatus status;

@end
