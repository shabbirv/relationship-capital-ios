//
//  FriendsTableViewCell.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit/FlatUIKit.h>
#import "Friend.h"
#import "CapitalEngine.h"

@interface FriendsTableViewCell : UITableViewCell {
    IBOutlet FUIButton *declineButton;
    IBOutlet FUIButton *acceptButton;
}

@property (nonatomic, weak) Friend *friend;

@end
