//
//  ViewController.m
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 10/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kShouldLoadDashboard" object:nil];
}

- (void)viewDidLoad
{
    avatarView.image = [UIImage imageNamed:@"fb.jpg"];
    avatarView.showShadow = YES;
    
    //Set height of row
    theTableView.rowHeight = 60;
    
    //Listen for login
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldLoadDashboard:) name:@"kShouldLoadDashboard" object:nil];
    
    if (_user.dashboardAPIUrl) {
        [self shouldLoadDashboard:nil];
    }
    
    //Holder array for appropriate users
    usersArray = [NSMutableArray array];
    
    //Populate the friends based on your profile or someone elses
    [self populateFriendsArray];
    
    //If this is your profile show the friends button
    if ([User currentUser] == _user) {
        UIBarButtonItem *profile = [[UIBarButtonItem alloc] initWithTitle:@"Find Connections" style:UIBarButtonItemStyleBordered target:self action:@selector(connectionsAction)];
        self.navigationItem.rightBarButtonItem = profile;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout:) name:@"kUserDidLogout" object:nil];
    }
    
    //Add refresh control
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(shouldLoadDashboard:)
             forControlEvents:UIControlEventValueChanged];
    [theTableView addSubview:refreshControl];

    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didLogout:(NSNotification *)notification {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        login.title = @"Relationship Capital Login";
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:login];
        nv.navigationBar.barTintColor = [UIColor colorWithRed:52/255.0f green:73/255.0f blue:94/255.0f alpha:1.0];
        nv.navigationBar.tintColor = [UIColor whiteColor];
        nv.navigationBar.translucent = NO;
        nv.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:nv animated:YES completion:NULL];
    }
    avatarView.image = [UIImage imageNamed:@"fb.jpg"];
    scoreLabel.text = @"0";
    nameLabel.text = @"";
    commitmentCountLabel.text = @"0";
    requestCountLabel.text = @"0";
    [usersArray removeAllObjects];
    [theTableView reloadData];
}

//Your profile should show all friends regardless of status
//You should only be able to see accepted friends for anyone else
- (void)populateFriendsArray {
    [usersArray removeAllObjects];
    if ([User currentUser] == _user) {
        [usersArray addObjectsFromArray:_user.friends];
    } else { //Hide friends that are not accepted
        for (int i = 0; i < _user.friends.count; i++) {
            Friend *friend = _user.friends[i];
            if (friend.friendStatus == FriendStatusAccepted) {
                [usersArray addObject:friend];
            }
        }
    }
}

//A way to get connections
- (void)connectionsAction {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[CapitalEngine sharedEngine] loadUsersWithCompletion:^(id result, NSError *error) {
        [SVProgressHUD dismiss];
        UserPickerViewController *picker = [[UserPickerViewController alloc] initWithNibName:@"UserPickerViewController" bundle:nil];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:picker];
        picker.usersArray = result;
        picker.pickerForFollowing = YES;
        popOver = [[UIPopoverController alloc] initWithContentViewController:nv];
        [popOver presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }];

}

//Called when the user logs in
- (void)shouldLoadDashboard:(NSNotification *)notification {
    [[CapitalEngine sharedEngine] getDashboardForUser:_user completion:^(id result, NSError *error) {
        nameLabel.text = [NSString stringWithFormat:@"%@ %@", _user.firstName, _user.lastName];
        scoreLabel.text = [NSString stringWithFormat:@"%d", _user.rcScore];
        avatarView.imageUrl = [_user.email emailToGravatarUrl];
        commitmentCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_user.commitments.count];
        requestCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_user.requests.count];
        [self populateFriendsArray];
        [theTableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDashboardLoaded" object:nil];
        
        if (_user != [User currentUser]) {
            youFollow = FALSE;
            for (Friend *friend in [User currentUser].friends) {
                if (friend.userId == _user.userId) {
                    youFollow = TRUE;
                }
            }
            if (!youFollow && _user.userId != [User currentUser].userId) {
                UIBarButtonItem *follow = [[UIBarButtonItem alloc] initWithTitle:@"Connect" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleFollow)];
                self.navigationItem.rightBarButtonItem = follow;
            }
        }
        [refreshControl endRefreshing];
    }];
}

- (void)toggleFollow {
    if (youFollow) {
        
    } else {
        [[CapitalEngine sharedEngine] addUserAsFriend:_user completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kShouldLoadDashboard" object:nil];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    //Check if the user property is the logged in user and check if they are logged in
    if (!_user.isLoggedIn && _user == [User currentUser]) {
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        login.title = @"Relationship Capital Login";
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:login];
        nv.navigationBar.barTintColor = [UIColor colorWithRed:52/255.0f green:73/255.0f blue:94/255.0f alpha:1.0];
        nv.navigationBar.tintColor = [UIColor whiteColor];
        nv.navigationBar.translucent = NO;
        nv.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:nv animated:YES completion:NULL];
    }
    
    [super viewDidAppear:YES];
}

#pragma mark UITableView Delegate methods

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return usersArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Connections";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
	FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.contentView.opaque = TRUE;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithRed:111/255.0f green:116/255.0f blue:123/255.0f alpha:1.0];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    }
    
    Friend *friend = [usersArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
    cell.friend = friend;
    if (friend.friendStatus == FriendStatusRequest) {
        cell.detailTextLabel.text = @"Awaiting approval by you";
    } else if (friend.friendStatus == FriendStatusAccepted) {
        cell.detailTextLabel.text = friend.email;
    } else {
        cell.detailTextLabel.text = @"Request sent, waiting for approval";
    }
    [cell.imageView setImageWithURL:[friend.email emailToGravatarUrl] placeholderImage:[UIImage imageNamed:@"fb.jpg"]];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Friend *friend = [usersArray objectAtIndex:indexPath.row];
    ProfileViewController *profile = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    profile.user = friend;
    [self.navigationController pushViewController:profile animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tappedCommitment:(Commitment *)commitment {
    [self.navigationController popToRootViewControllerAnimated:NO];
    CommitmentDetailViewController *detail = [[CommitmentDetailViewController alloc] initWithNibName:@"CommitmentDetailViewController" bundle:nil];
    detail.commitment = commitment;
    [self.navigationController pushViewController:detail animated:YES];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    // Return YES for supported orientations
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
