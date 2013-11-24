//
//  AddCommitmentViewController.m
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "AddCommitmentViewController.h"

@interface AddCommitmentViewController ()

@end

@implementation AddCommitmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    //Title
    self.title = @"Create a Commitment";
    
    //Setup description text view
    descriptionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    descriptionTextView.layer.borderWidth = 1.0;
    descriptionTextView.layer.cornerRadius = 5.0;
    descriptionTextView.layer.masksToBounds = YES;
    
    //Make title field keyboard up
    [titleField becomeFirstResponder];
    
    //Add plus button
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addAction)];
    self.navigationItem.rightBarButtonItem = add;
    
    //Add Cancel button
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    //Create slider on bottom
    slider = [[STTimeSlider alloc] initWithFrame:CGRectMake(((self.view.frame.size.width - 200)/2.0) + 15, (descriptionTextView.frame.size.height + descriptionTextView.frame.origin.y + 20), 200, 40.0)];
    slider.strokeColor = [UIColor blueColor];
    slider.numberOfPoints = 3;
    [slider setDelegate:self];
    slider.startIndex = 0;
    slider.mode = STTimeSliderModeMulti;
    [self.view addSubview:slider];

    [super viewDidLoad];
}

- (void)addAction {
    if (titleField.text.length == 0) return [SVProgressHUD showErrorWithStatus:@"Please add a title for your commitment"];
    if (descriptionTextView.text.length == 0) return [SVProgressHUD showErrorWithStatus:@"Please add a description for your commitment"];
    if (!_selectedUser) return [SVProgressHUD showErrorWithStatus:@"Please select a recipient for the commitment"];
    int diff = 1;
    if (slider.currentIndex == 1) {
        diff = 3;
    } else if (slider.currentIndex == 2) {
        diff = 5;
    }
    NSDictionary *dict = @{
                           @"commitment[authentication_token]": [User currentUser].authToken,
                           @"commitment[name]" : titleField.text, 
                           @"commitment[description]" : descriptionTextView.text,
                           @"commitment[issuer_id]" : @([User currentUser].userId),
                           @"commitment[reciever_id]" : @(_selectedUser.userId),
                           @"commitment[difficulty_score]" : @(diff)
                           };
    
    [[CapitalEngine sharedEngine] addCommitment:dict completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kShouldLoadDashboard" object:nil];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }];
}

- (void)cancelAction {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)loadUsers {
    [titleField resignFirstResponder];
    [SVProgressHUD show];
    [[CapitalEngine sharedEngine] loadUsersWithCompletion:^(id result, NSError *error) {
        [SVProgressHUD dismiss];
        UserPickerViewController *picker = [[UserPickerViewController alloc] initWithNibName:@"UserPickerViewController" bundle:nil];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:picker];
        picker.usersArray = result;
        picker.delegate = self;
        popOver = [[UIPopoverController alloc] initWithContentViewController:nv];
        [popOver presentPopoverFromRect:recipientButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        NSLog(@"%@", result);
    }];
}

- (void)didSelectUser:(User *)user {
    _selectedUser = user;
    recipientField.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    [popOver dismissPopoverAnimated:YES];
    [descriptionTextView becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (titleField == textField) {
        [self loadUsers];
    }
    return YES;
}

#pragma mark STTSliderDelegate

- (void)timeSlider:(STTimeSlider *)timeSlider didSelectPointAtIndex:(int)index {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat gradientLocations[] = {0, 1};
    if (index == 0) {
        NSArray *gradientColors = [NSArray arrayWithObjects:
                          (id)[UIColor nephritisColor].CGColor, nil];
        slider.gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    } else if (index == 1) {
        NSArray *gradientColors = [NSArray arrayWithObjects:
                                   (id)[UIColor sunflowerColor].CGColor, nil];
        slider.gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    } else {
        NSArray *gradientColors = [NSArray arrayWithObjects:
                                   (id)[UIColor alizarinColor].CGColor, nil];
        slider.gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
