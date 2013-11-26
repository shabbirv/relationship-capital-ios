//
//  CommitmentsViewController.m
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 10/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "CommitmentsViewController.h"

@interface CommitmentsViewController ()

@end

@implementation CommitmentsViewController

- (void)viewDidLoad
{
    //Listen for login
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:@"kUserDidLogin" object:nil];
    
    //Listen for when dashboard is loaded
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dashboardLoaded:) name:@"kDashboardLoaded" object:nil];
    
    //Clear commitment id
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCommitmentId:) name:@"kClearCommitmentId" object:nil];
    
    //Add listener for logout
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout:) name:@"kUserDidLogout" object:nil];
    
    //Add plus button
    UIBarButtonItem *plus = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus"]
                                                             style:UIBarButtonItemStyleBordered target:self action:@selector(addCommitment)];
    plus.tintColor = [UIColor darkGrayColor];
    self.navigationItem.rightBarButtonItem = plus;
    
    
    //Add logout button
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    logout.tintColor = [UIColor alizarinColor];
    self.navigationItem.leftBarButtonItem = logout;

    
    selectedCommitmentId = 0;
    
    //Refresh Control
    //Add refresh control
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    [theTableView addSubview:refreshControl];

    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)refresh {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kShouldLoadDashboard" object:nil];
    [refreshControl performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
}

- (void)logout {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Logout" otherButtonTitles:nil];
    [sheet showFromBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [[User currentUser] logoutUser];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUserDidLogout" object:nil];
    }
}

//Called when adding a new commitment
- (void)addCommitment {
    AddCommitmentViewController *add = [[AddCommitmentViewController alloc] initWithNibName:@"AddCommitmentViewController" bundle:nil];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:add];
    nv.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nv animated:YES completion:NULL];
}

//Called when the user logs in
- (void)userDidLogin:(NSNotification *)notification {
}

- (void)clearCommitmentId:(NSNotification *)notification {
    selectedCommitmentId = 0;
}

- (void)didLogout:(NSNotification *)notification {
    selectedCommitmentId = 0;
    [theTableView reloadData];
}

- (void)dashboardLoaded:(NSNotification *)notification {
    [theTableView reloadData];
    if (selectedCommitmentId != 0) {
        for (int i = 0; i < _user.commitments.count; i++) {
            Commitment *commitment = [_user.commitments objectAtIndex:i];
            if (commitment.commitmentId == selectedCommitmentId && commitment.status != CommitmentStatusApproved) {
                if ([_delegate respondsToSelector:@selector(tappedCommitment:)])
                    [_delegate tappedCommitment:commitment];
                return;
            }
        }
    }
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSArray *)arrayForSection:(NSInteger)section {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < _user.commitments.count; i++) {
        Commitment *commitment = [_user.commitments objectAtIndex:i];
        if (section == 0) {
            if (commitment.status == CommitmentStatusPending) {
                [array addObject:commitment];
            }
        } else if (section == 1) {
            if (commitment.status == CommitmentStatusOngoing) {
                [array addObject:commitment];
            }
        } else if (section == 2) {
            if (commitment.status == CommitmentStatusSubmitted) {
                [array addObject:commitment];
            }
        }
    }
    if (section == 3) {
        [array addObjectsFromArray:_user.requests];
    }
    return array;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self arrayForSection:section].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Pending Commitments";
    else if (section == 1)
        return @"Accepted Commitments";
    else if (section == 2)
        return @"Commitments requiring approval";
    else
        return @"Requested Commitments";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	const NSInteger COMMIT_CELL_TAG = 1002;
    
    CommitmentCell *cellView;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cellView = [[CommitmentCell alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        cellView.tag = COMMIT_CELL_TAG;
        cellView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview: cellView];
        
    } else {
        cellView = (CommitmentCell *)[cell viewWithTag:COMMIT_CELL_TAG];
    }
    
    NSArray *array = [self arrayForSection:indexPath.section];
    Commitment *commitment = [array objectAtIndex:indexPath.row];
    cellView.commitment = commitment;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [self arrayForSection:indexPath.section];
    Commitment *commitment = [array objectAtIndex:indexPath.row];
    selectedCommitmentId = commitment.commitmentId;
    if ([_delegate respondsToSelector:@selector(tappedCommitment:)])
        [_delegate tappedCommitment:commitment];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
