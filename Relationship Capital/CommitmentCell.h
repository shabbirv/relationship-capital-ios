//
//  CommitmentCell.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/23/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commitment.h"
#import <FlatUIKit/FlatUIKit.h>
#import "Request.h"

@interface CommitmentCell : UIView {
    IBOutlet UIView *colorView;
    IBOutlet UILabel *textLabel;
}

@property (nonatomic, weak) Commitment *commitment;

@end
