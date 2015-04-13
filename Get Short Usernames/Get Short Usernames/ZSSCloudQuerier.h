//
//  ZSSCloudQuerier.h
//  Get Short Usernames
//
//  Created by Zachary Shakked on 2/16/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface ZSSCloudQuerier : NSObject

+ (instancetype)sharedQuerier;
- (void)cancelAllOperations;

- (void)checkFacebookForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkInstagramForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkGithubForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkPinterestForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkTwitterForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkTumblrForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkEbayForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkDribbbleForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkBehanceForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkYoutubeForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkGooglePlusForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkRedditForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkImgurForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkWordpressForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkGravatarForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkEtsyShopForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkEtsyPeopleForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkAboutMeForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkKickAssToForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkFlickrForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkDeviantArtForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkTwitchForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkVimeoForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkSoundCloudForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkOkCupidForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkKickStarterForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;

- (void)checkBloggerForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkMySpaceForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkLinkedInForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkPhotoBucketForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkHuluForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;

- (void)checkHubPagesForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkCafeMomForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkDisqusForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkFanpopForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkStumbleUponForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkLastFMForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkKongregateForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkUStreamForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkInstructablesForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkFourSquareForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkLiveJournalForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkBadooForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkBitLyForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkBlipTVForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkSteamForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkKaboodleForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkDailyBoothForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkViddlerForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkDeliciousForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkXangaForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkSoupIOForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkDiggForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkBuzznetForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkTechnoratiForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkTripitForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkFotologForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkFavesForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkNetvibesForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkBlinkListForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkGogoBotForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkAviaryForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkFoodSpottingForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkFlavorsForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkPlancastForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkBlipFmForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkWeFollowForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkWishlistrForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkXboxGamertagForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkPlayStationNetworkForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkTripAdvisorForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkBuzzFeedForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkBandCampForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkBeatportForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkHackerNewsForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkLiveLeakForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkImageShackForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkAlibabaForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkScribdForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkElanceForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;
- (void)checkSlackForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion;

@end
