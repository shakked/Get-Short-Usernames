//
//  ZSSSearchOperation.m
//  Usernames
//
//  Created by Zachary Shakked on 3/28/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import "ZSSSearchOperation.h"
#import "ZSSNetworkQuerier.h"
#import "ZSSCloudQuerier.h"

@interface ZSSSearchOperation ()

@property (nonatomic, strong) NSArray *selectedNetworks;

@end

@implementation ZSSSearchOperation

- (instancetype)init {
    self = [super init];
    if (self) {
        _selectedNetworks = [[ZSSNetworkQuerier sharedQuerier] selectedNetworks];
    }
    return self;
}

- (void)main {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.isCancelled) {
                return;
            } else {
                [self.delegate searchOperationDidFinish];
            }
        });
    });

    
    
    if ([self.selectedNetworks containsObject:@"Instagram"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkInstagramForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Github"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkGithubForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Pinterest"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkPinterestForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                
            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Twitter"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkTwitterForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Tumblr"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkTumblrForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Ebay"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkEbayForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Dribbble"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkDribbbleForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Behance"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkBehanceForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
             
            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Youtube"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkYoutubeForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
             
            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"GooglePlus"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkGooglePlusForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
             
            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Reddit"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkRedditForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Imgur"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkImgurForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Wordpress"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkWordpressForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
             
            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Gravatar"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkGravatarForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
             
            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"EtsyShop"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkEtsyShopForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
             
            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"EtsyPeople"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkEtsyPeopleForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
             
            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"AboutMe"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkAboutMeForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    if ([self.selectedNetworks containsObject:@"KickAssTo"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkKickAssToForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"ThePirateBay"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkThePirateBayForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Flickr"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkFlickrForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"DeviantArt"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkDeviantArtForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Twitch"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkTwitchForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Vimeo"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkVimeoForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"LifeHacker"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkLifeHackerForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"WikiAnswers"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkWikiAnswersForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"SoundCloud"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkSoundCloudForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"IGN"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkIGNForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"OkCupid"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkOkCupidForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"TheVerge"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkTheVergeForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"KickStarter"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkKickStarterForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Spotify"]) {
        dispatch_group_enter(group);
        [[ZSSCloudQuerier sharedQuerier] checkSpotifyForUsername:self.searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {

            }
            dispatch_group_leave(group);
        }];
    }

}

@end
