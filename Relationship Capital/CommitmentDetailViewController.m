//
//  CommitmentDetailViewController.m
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/4/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "CommitmentDetailViewController.h"

@interface CommitmentDetailViewController ()

@end

@implementation CommitmentDetailViewController

- (void)viewDidLoad
{
    
    //Complete Button
    completeButton.shadowHeight = 3.0f;
    completeButton.cornerRadius = 6.0f;
    completeButton.buttonColor = [UIColor emerlandColor];
    completeButton.shadowColor = [UIColor clearColor];
    completeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [completeButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    //Accept Button
    acceptButton.shadowHeight = 3.0f;
    acceptButton.cornerRadius = 6.0f;
    acceptButton.buttonColor = [UIColor emerlandColor];
    acceptButton.shadowColor = [UIColor clearColor];
    acceptButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [acceptButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [acceptButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];

    //Decline Button
    declineButton.shadowHeight = 3.0f;
    declineButton.cornerRadius = 6.0f;
    declineButton.buttonColor = [UIColor alizarinColor];
    declineButton.shadowColor = [UIColor clearColor];
    declineButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [declineButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [declineButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];

    //If the status is available show the accept/decline button. If it is accepted only show complete
    if (_status == CommitmentStatusAvailable) {
        acceptButton.hidden = NO;
        declineButton.hidden = NO;
    } else if (_status == CommitmentStatusAccepted) {
        completeButton.hidden = NO;
    }

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

@end
