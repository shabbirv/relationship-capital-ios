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
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

//Called when the user logs in
- (void)shouldLoadDashboard:(NSNotification *)notification {
    [[CapitalEngine sharedEngine] getDashboardForUser:_user completion:^(id result, NSError *error) {
        nameLabel.text = [NSString stringWithFormat:@"%@ %@", _user.firstName, _user.lastName];
        scoreLabel.text = [NSString stringWithFormat:@"%d", _user.rcScore];
        avatarView.imageUrl = [_user.email emailToGravatarUrl];
        commitmentCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_user.commitments.count];
        requestCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_user.requests.count];
        [theTableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kDashboardLoaded" object:nil];
    }];
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
    return _user.friends.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Your connections";
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
    
    Friend *friend = [_user.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
    cell.friend = friend;
    if (friend.friendStatus == FriendStatusRequest) {
        cell.detailTextLabel.text = @"Awaiting approval by you";
    } else {
        cell.detailTextLabel.text = friend.email;
    }
    [cell.imageView setImageWithURL:[friend.email emailToGravatarUrl] placeholderImage:[UIImage imageNamed:@"fb.jpg"]];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Friend *friend = [_user.friends objectAtIndex:indexPath.row];
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
