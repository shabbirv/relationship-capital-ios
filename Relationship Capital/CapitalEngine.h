//
//  CapitalEngine.h
//  Relationship Capital
//
//  Created by Shabbir Vijapura on 11/3/13.
//  Copyright (c) 2013 Shabbir Vijapura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "User.h"
#import "Friend.h"
#import "Commitment.h"
#import "Request.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Comment.h"

typedef void(^ConditionalBlock)(BOOL);
typedef void(^ResultBlock)(id result, NSError*error);
typedef void(^Completion)();

@interface CapitalEngine : NSObject

+ (CapitalEngine *)sharedEngine;

- (void)signupWithDict:(NSDictionary *)dict completion:(void (^)(NSDictionary *dict, NSError *error))completionBlock;
- (void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(ConditionalBlock)block;
- (void)getDashboardForUser:(User *)user completion:(ResultBlock)block;
- (void)respondToFriendRequestWithId:(int)friendshipId shouldAccept:(BOOL)accept completion:(Completion)block;
- (void)respondToCommitment:(Commitment *)commitment shouldAccept:(BOOL)accept completion:(Completion)block;
- (void)loadUsersWithCompletion:(ResultBlock)block;
- (void)addCommitment:(NSDictionary *)commitmentDict completion:(Completion)block;
- (void)addComment:(NSString *)comment forCommitment:(Commitment *)commitment completion:(Completion)completion;
- (void)getCommentsForCommitment:(Commitment *)commitment completion:(ResultBlock)block;
@end
