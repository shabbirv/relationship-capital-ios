//
//  AddCommitmentViewController.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapitalEngine.h"
#import "UserPickerViewController.h"
#import "STTimeSlider.h"

@interface AddCommitmentViewController : UIViewController <UIPopoverControllerDelegate, UserPickerDelegate, UITextFieldDelegate, STTimeSliderDelegate> {
    IBOutlet UITextView *descriptionTextView;
    IBOutlet UITextField *titleField;
    IBOutlet UITextField *recipientField;
    IBOutlet UIButton *recipientButton;
    UIPopoverController *popOver;
    STTimeSlider *slider;
}

@property (nonatomic, strong) User *selectedUser;

- (IBAction)loadUsers;

@end
