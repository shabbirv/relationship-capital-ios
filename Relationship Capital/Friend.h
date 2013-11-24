//
//  Friend.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "User.h"

typedef enum {
    FriendStatusPending = 0,
    FriendStatusRequest = 1,
    FriendStatusAccepted = 2
} FriendStatus;

@interface Friend : User

@property (nonatomic, assign) FriendStatus friendStatus;
@property (nonatomic, assign) int friendshipId;

@end
