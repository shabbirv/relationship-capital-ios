//
//  Commitment.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/21/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CommitmentStatusPending,
    CommitmentStatusSent,
    CommitmentStatusOngoing,
    CommitmentStatusSubmitted,
    CommitmentStatusFulfilled,
    CommitmentStatusApproved,
    CommitmentStatusDeclined
} CommitmentStatus;

typedef enum {
    DifficultyLevelEasy = 1,
    DifficultyLevelMedium = 3,
    DifficultyLevelHard = 5
} DifficultyLevel;

@interface Commitment : NSObject

@property (nonatomic, strong) NSDate *deadline;
@property (nonatomic, strong) NSString *commitmentDescription;
@property (nonatomic, assign) int commitmentId;
@property (nonatomic, assign) int issuerId;
@property (nonatomic, assign) int receiverId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) CommitmentStatus status;
@property (nonatomic, assign) DifficultyLevel difficulty;

@end
