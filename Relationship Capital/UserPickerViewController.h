//
//  UserPickerViewController.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/23/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCell.h"
#import "CapitalEngine.h"

@protocol UserPickerDelegate <NSObject>
- (void)didSelectUser:(User *)user;
@end

@interface UserPickerViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    IBOutlet UITableView *theTableView;
    
}

@property (nonatomic, strong) NSMutableArray *usersArray;
@property (nonatomic, weak) User *selectedUser;
@property (nonatomic, weak) id<UserPickerDelegate> delegate;
@property (nonatomic, assign) BOOL pickerForFollowing;

@end
