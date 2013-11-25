//
//  FriendsTableViewCell.m
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "FriendsTableViewCell.h"

@implementation FriendsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *screens = [[NSBundle mainBundle] loadNibNamed:@"FriendsTableViewCell" owner:self options:nil];
        [self addSubview:[screens firstObject]];
        
        //Accept Button
        acceptButton.shadowHeight = 3.0f;
        acceptButton.cornerRadius = 6.0;
        acceptButton.buttonColor = [UIColor emerlandColor];
        acceptButton.shadowColor = [UIColor clearColor];
        [acceptButton addTarget:self action:@selector(acceptAction) forControlEvents:UIControlEventTouchUpInside];
        acceptButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        [acceptButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [acceptButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
        
        //Decline Button
        declineButton.shadowHeight = 3.0f;
        declineButton.cornerRadius = 6.0;
        declineButton.buttonColor = [UIColor alizarinColor];
        declineButton.shadowColor = [UIColor clearColor];
        [declineButton addTarget:self action:@selector(declineAction) forControlEvents:UIControlEventTouchUpInside];
        declineButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        [declineButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [declineButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setFriend:(Friend *)friend {
    _friend = friend;
    if (friend.friendStatus != FriendStatusRequest) {
        acceptButton.hidden = YES;
        declineButton.hidden = YES;
    } else {
        acceptButton.hidden = NO;
        declineButton.hidden = NO;
    }
}

- (void)acceptAction {
    acceptButton.enabled = NO;
    declineButton.enabled = NO;
    [[CapitalEngine sharedEngine] respondToFriendRequestWithId:_friend.friendshipId shouldAccept:YES completion:^{
        acceptButton.enabled = YES;
        declineButton.enabled = YES;
        acceptButton.hidden = YES;
        declineButton.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kShouldLoadDashboard" object:nil];
    }];
}

- (void)declineAction {
    [[CapitalEngine sharedEngine] respondToFriendRequestWithId:_friend.friendshipId shouldAccept:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kShouldLoadDashboard" object:nil];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
