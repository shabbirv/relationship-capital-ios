//
//  UserPickerViewController.m
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/23/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "UserPickerViewController.h"

@interface UserPickerViewController ()

@end

@implementation UserPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    //Remove you and people you follow from the list
    if (_pickerForFollowing) {
        NSMutableArray *indexsToRemove = [NSMutableArray array];
        for (int i = 0; i < _usersArray.count; i++) {
            User *user = _usersArray[i];
            if (user.userId == [User currentUser].userId) {
                [indexsToRemove addObject:user];
            }
            for (int j = 0; j < [User currentUser].friends.count; j++) {
                User *user1 = [User currentUser].friends[j];
                if (user.userId == user1.userId) {
                    [indexsToRemove addObject:user];
                }
            }
        }
        for (int i = 0; i < indexsToRemove.count; i++) {
            [_usersArray removeObject:indexsToRemove[i]];
        }
    }
    
    //Set height of table
    theTableView.rowHeight = 44;
    [theTableView reloadData];
    
    
    //Add plus button
    if (!_pickerForFollowing) {
        UIBarButtonItem *choose = [[UIBarButtonItem alloc] initWithTitle:@"Choose" style:UIBarButtonItemStyleBordered target:self action:@selector(chooseAction)];
        self.navigationItem.rightBarButtonItem = choose;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)chooseAction {
    if (!_selectedUser) return;
    if ([_delegate respondsToSelector:@selector(didSelectUser:)])
        [_delegate didSelectUser:_selectedUser];
}

- (void)viewDidAppear:(BOOL)animated {
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor whiteColor];
    [super viewDidAppear:animated];
}

- (NSArray *)arrayForSearchText {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < _usersArray.count; i++) {
        User *user = _usersArray[i];
        NSString *fullName = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        NSRange nameRange = [[fullName lowercaseString] rangeOfString:[self.searchDisplayController.searchBar.text lowercaseString]];
        if (nameRange.location != NSNotFound) {
            [array addObject:user];
        }
    }
    return array;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == theTableView)
        return _usersArray.count;
    else
        return [self arrayForSearchText].count;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	const NSInteger USER_CELL_TAG = 1002;
    
    UserCell *cellView;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        
        cellView = [[UserCell alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        cellView.tag = USER_CELL_TAG;
        [cell.contentView addSubview: cellView];
        
        
        
    } else {
        cellView = (UserCell *)[cell viewWithTag:USER_CELL_TAG];
    }
    
    User *user = nil;
    if (tableView == theTableView) {
        user = _usersArray[indexPath.row];
    } else {
        user = [self arrayForSearchText][indexPath.row];
    }
    if (_selectedUser == user) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cellView.user = user;
    
	return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = nil;
    if (tableView == theTableView) {
        user = _usersArray[indexPath.row];
    } else {
        user = [self arrayForSearchText][indexPath.row];
    }
    if (_pickerForFollowing) {
        _selectedUser = user;
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Add this connection?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Yes", nil];
        [sheet showInView:self.view];
    } else {
        if (tableView == theTableView) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (user.userId == _selectedUser.userId) {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                _selectedUser = nil;
                self.navigationItem.rightBarButtonItem.enabled = NO;
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                NSInteger row = [_usersArray indexOfObject:_selectedUser];
                UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                _selectedUser = user;
                self.navigationItem.rightBarButtonItem.enabled = YES;
                cell1.accessoryType = UITableViewCellAccessoryNone;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        } else {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (user.userId == _selectedUser.userId) {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                _selectedUser = nil;
                self.navigationItem.rightBarButtonItem.enabled = NO;
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                NSInteger row = [[self arrayForSearchText] indexOfObject:_selectedUser];
                UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                _selectedUser = user;
                self.navigationItem.rightBarButtonItem.enabled = YES;
                cell1.accessoryType = UITableViewCellAccessoryNone;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    
}

#pragma mark UISearchBarDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [theTableView reloadData];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        _selectedUser = nil;
    } else {
        [[CapitalEngine sharedEngine] addUserAsFriend:_selectedUser completion:^{
            NSInteger row = [_usersArray indexOfObject:_selectedUser];
            [_usersArray removeObject:_selectedUser];
            [theTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kShouldLoadDashboard" object:nil];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
