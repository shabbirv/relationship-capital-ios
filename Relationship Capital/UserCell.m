//
//  BusCell.m
//  CTA
//
//  Created by Shabbir Vijapura on 10/6/12.
//
//

#import "UserCell.h"

@implementation UserCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *screens = [[NSBundle mainBundle] loadNibNamed: @"UserCell" owner: self options: nil];
        if (![[screens objectAtIndex:0] isDescendantOfView:self])
            [self addSubview: [screens objectAtIndex: 0]];
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

- (void)setUser:(User *)user {
    _user = user;
    textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    detailTextLabel.text = [NSString stringWithFormat:@"%d", user.rcScore];
    [avatarImageView setImageWithURL:[_user.email emailToGravatarUrl] placeholderImage:[UIImage imageNamed:@"fb.jpg"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
