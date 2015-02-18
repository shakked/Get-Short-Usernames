//
//  ZSSCloudQuerier.h
//  Get Short Usernames
//
//  Created by Zachary Shakked on 2/16/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSSCloudQuerier : NSObject

+ (instancetype)sharedQuerier;
- (void)getUsernamesForNetwork:(NSString *)networkName withCompletion:(void (^)(NSArray *, NSError *))completion;

- (void)checkInstagramForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkGithubForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkPinterestForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkTwitterForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkTumblrForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;

@end
