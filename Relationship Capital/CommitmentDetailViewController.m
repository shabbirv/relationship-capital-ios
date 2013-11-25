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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad
{
    
    //Complete Button
    completeButton.shadowHeight = 3.0f;
    completeButton.cornerRadius = 6.0f;
    completeButton.buttonColor = [UIColor emerlandColor];
    completeButton.shadowColor = [UIColor clearColor];
    completeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [completeButton addTarget:self action:@selector(accept) forControlEvents:UIControlEventTouchUpInside];
    [completeButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    
    //Accept Button
    acceptButton.shadowHeight = 3.0f;
    acceptButton.cornerRadius = 6.0f;
    acceptButton.buttonColor = [UIColor emerlandColor];
    acceptButton.shadowColor = [UIColor clearColor];
    [acceptButton addTarget:self action:@selector(accept) forControlEvents:UIControlEventTouchUpInside];
    acceptButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [acceptButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [acceptButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];

    //Decline Button
    declineButton.shadowHeight = 3.0f;
    declineButton.cornerRadius = 6.0f;
    declineButton.buttonColor = [UIColor alizarinColor];
    declineButton.shadowColor = [UIColor clearColor];
    [declineButton addTarget:self action:@selector(decline) forControlEvents:UIControlEventTouchUpInside];
    declineButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    [declineButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [declineButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];

    //Set the description text
    detailsTextView.text = _commitment.commitmentDescription;
    
    //Set the title
    self.title = _commitment.name;

    
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //Load Comments
    commentsArray = [NSMutableArray array];
    [self refreshComments];
    
    //Table view setup
    theTableView.rowHeight = 60;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)refreshComments {
    [commentsArray removeAllObjects];
    [[CapitalEngine sharedEngine] getCommentsForCommitment:_commitment completion:^(id result, NSError *error) {
        [commentsArray addObjectsFromArray:result];
        [theTableView reloadData];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (!dontClear) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kClearCommitmentId" object:nil userInfo:nil];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    int x = 0;
    __block int y = 64;
    [UIView animateWithDuration:0.4 animations:^{
        if (_commitment.status == CommitmentStatusPending) {
            if (_commitment.receiverId == [User currentUser].userId) {
                acceptButton.hidden = NO;
                declineButton.hidden = NO;
                controlsView.frame = CGRectMake(x, y, controlsView.frame.size.width, controlsView.frame.size.height);
            }
        } else if (_commitment.status == CommitmentStatusOngoing) {
            if (_commitment.receiverId == [User currentUser].userId) {
                acceptButton.hidden = YES;
                declineButton.hidden = YES;
                completeButton.hidden = NO;
                controlsView.frame = CGRectMake(x, y, controlsView.frame.size.width, controlsView.frame.size.height);
            } else {
                controlsView.frame = CGRectMake(x, y, controlsView.frame.size.width, detailsTextView.frame.origin.y + detailsTextView.frame.size.height);
            }
        } else if (_commitment.status == CommitmentStatusSubmitted && _commitment.issuerId == [User currentUser].userId) {
            [completeButton setTitle:@"Approve" forState:UIControlStateNormal];
            completeButton.hidden = NO;
            acceptButton.hidden = YES;
            declineButton.hidden = YES;
            controlsView.frame = CGRectMake(x, y, controlsView.frame.size.width, controlsView.frame.size.height);
        } else {
            controlsView.frame = CGRectMake(x, y, controlsView.frame.size.width, detailsTextView.frame.origin.y + detailsTextView.frame.size.height);
        }
        y = y + controlsView.frame.size.height;
        theTableView.frame = CGRectMake(x, y, theTableView.frame.size.width, (theTableView.frame.size.height - y) + 64);
    }];
    [super viewDidAppear:animated];
}

- (void)accept {
    [[CapitalEngine sharedEngine] respondToCommitment:_commitment shouldAccept:YES completion:^{
        dontClear = TRUE;
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kShouldLoadDashboard" object:nil];
    }];
}

- (void)decline {
    [[CapitalEngine sharedEngine] respondToCommitment:_commitment shouldAccept:NO completion:^{
        dontClear = TRUE;
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kShouldLoadDashboard" object:nil];
    }];
}

- (IBAction)sendAction {
    if (commentField.text.length == 0) {
        [commentField resignFirstResponder];
        return [SVProgressHUD showErrorWithStatus:@"No Comment Entered"];
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[CapitalEngine sharedEngine] addComment:commentField.text forCommitment:_commitment completion:^{
        
        [SVProgressHUD dismiss];
        commentField.text = @"";
        [self refreshComments];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendAction];
    return YES;
}

#pragma mark Keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [UIView animateWithDuration:duration.floatValue animations:^{
        controlsView.frame = CGRectMake(0, -controlsView.frame.size.height, controlsView.frame.size.width, controlsView.frame.size.height);
        fieldBar.frame = CGRectMake(0, (self.view.frame.size.height - keyboardBounds.size.height) - fieldBar.frame.size.height, fieldBar.frame.size.width, fieldBar.frame.size.height);
        theTableView.frame = CGRectMake(theTableView.frame.origin.x, 64, theTableView.frame.size.width, fieldBar.frame.origin.y);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [UIView animateWithDuration:duration.floatValue animations:^{
        controlsView.frame = CGRectMake(0, 64, controlsView.frame.size.width, controlsView.frame.size.height);
        fieldBar.frame = CGRectMake(0, (self.view.frame.size.height) - fieldBar.frame.size.height, fieldBar.frame.size.width, fieldBar.frame.size.height);
        theTableView.frame = CGRectMake(theTableView.frame.origin.x, controlsView.frame.origin.y + controlsView.frame.size.height, theTableView.frame.size.width, fieldBar.frame.origin.y);
    }];
}

#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.numberOfLines = 4;
    }
    
    Comment *comment = [commentsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", comment.user.firstName, comment.user.lastName];
    cell.detailTextLabel.text = comment.text;
    [cell.imageView setImageWithURL:[comment.user.email emailToGravatarUrl]];
    
	return cell;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([commentField isFirstResponder]) {
        [commentField resignFirstResponder];
    }
}


@end
