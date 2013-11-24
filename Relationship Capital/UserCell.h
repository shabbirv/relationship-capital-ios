//
//  BusCell.h
//  CTA
//
//  Created by Shabbir Vijapura on 10/6/12.
//
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "NSString+Extensions.h"
#import <AFNetworking/AFNetworking.h>

@interface UserCell : UIView {
    IBOutlet UILabel *textLabel;
    IBOutlet UILabel *detailTextLabel;
    IBOutlet UIImageView *avatarImageView;
}

@property (nonatomic, weak) User *user;

@end
