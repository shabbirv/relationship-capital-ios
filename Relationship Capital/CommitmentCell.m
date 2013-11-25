//
//  CommitmentCell.m
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/23/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import "CommitmentCell.h"

@implementation CommitmentCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *screens = [[NSBundle mainBundle] loadNibNamed:@"CommitmentCell" owner:self options:nil];
        [self addSubview:[screens firstObject]];
    }
    return self;
}

- (void)setCommitment:(Commitment *)commitment {
    _commitment = commitment;
    textLabel.text = commitment.name;
//    if ((commitment.status == CommitmentStatusPending || commitment.status == CommitmentStatusOngoing) && ![commitment isKindOfClass:[Request class]]) {
//        colorView.backgroundColor = [self colorForDifficulty:_commitment.difficulty];
//    } else {
//        colorView.backgroundColor = [UIColor whiteColor];
//    }
    colorView.backgroundColor = [self colorForDifficulty:_commitment.difficulty];

}

- (UIColor *)colorForDifficulty:(DifficultyLevel)diff {
    if (diff == DifficultyLevelEasy) {
        return [UIColor nephritisColor];
    } else if (diff == DifficultyLevelMedium) {
        return [UIColor sunflowerColor];
    } else {
        return [UIColor alizarinColor];
    }
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
