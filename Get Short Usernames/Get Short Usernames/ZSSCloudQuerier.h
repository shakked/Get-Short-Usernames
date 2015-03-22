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
- (void)checkEbayForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkDribbbleForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkBehanceForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkYouTubeForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkGooglePlusForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkRedditForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkImgurForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkWordpressForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkGravatarForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkEtsyShopForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkEtsyPeopleForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkAboutMeForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkKickassToForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkThePirateBayForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkFlickrForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkDeviantArtForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkTwitchForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkVimeoForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkLifeHackerForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkWikiAnswersForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkSoundCloudForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkIGNForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkOkCupidForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkTheVergeForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkKickStarterForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkSpotifyForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;

@end
