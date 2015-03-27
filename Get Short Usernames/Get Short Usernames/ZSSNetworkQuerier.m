//
//  ZSSNetworkQuerier.m
//  Usernames
//
//  Created by Zachary Shakked on 3/23/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import "ZSSNetworkQuerier.h"

@interface ZSSNetworkQuerier ()


@end

@implementation ZSSNetworkQuerier
+ (instancetype)sharedQuerier {
    static ZSSNetworkQuerier *sharedQuerier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQuerier = [[self alloc] initPrivate];
    });
    return sharedQuerier;
}

- (BOOL)didUnlockAllNetworks {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL didUnlockAllNetworks = [defaults boolForKey:@"com.zacharyshakked.ia2p.UnlockAllNetworks"];
    if (didUnlockAllNetworks) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)addNetwork:(NSString *)networkName {
    BOOL isValidNetworkAddition = [self isValidNetworkAddition:networkName];
    if (isValidNetworkAddition) {
        NSMutableArray *savedNetworks = [self selectedNetworks];
        [savedNetworks addObject:networkName];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:savedNetworks forKey:@"savedNetworks"];
        [defaults synchronize];
        return YES;
    }
    return NO;
}

- (BOOL)removeNetwork:(NSString *)networkName {
    BOOL isValidNetworkRemoval = [self.allNetworkNames containsObject:networkName];
    if (isValidNetworkRemoval) {
        NSMutableArray *savedNetworks = [self selectedNetworks];
        [savedNetworks removeObject:networkName];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:savedNetworks forKey:@"savedNetworks"];
        [defaults synchronize];
        return YES;
    } else {
        return NO;
    }
}

- (void)saveNetworks:(NSArray *)networks {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:networks forKey:@"savedNetworks"];
    [defaults synchronize];
}

- (NSMutableArray *)selectedNetworks {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *savedNetworks = [defaults arrayForKey:@"savedNetworks"];
    if (!savedNetworks || savedNetworks.count == 0) {
        savedNetworks = @[@"Instagram", @"Github", @"Pinterest", @"Twitter", @"Tumblr"];
        [defaults setValue:savedNetworks forKey:@"savedNetworks"];
        [defaults synchronize];
    }
    return [NSMutableArray arrayWithArray:savedNetworks];
}

- (BOOL)isValidNetworkName:(NSString *)networkName {
    if ([self.allNetworkNames containsObject:networkName]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isValidNetworkAddition:(NSString *)networkName {
    NSArray *currentSavedNetworks = [self selectedNetworks];
    if ([currentSavedNetworks containsObject:networkName] || ![self isValidNetworkName:networkName]) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)isValidNetworkRemoval:(NSString *)networkName {
    NSArray *currentSavedNetworks = [self selectedNetworks];
    if(![currentSavedNetworks containsObject:networkName] || ![self isValidNetworkName:networkName]) {
        return NO;
    } else {
        return YES;
    }
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        [self configureAllNetworkNames];
    }
    return self;
}

- (void)configureAllNetworkNames {
    _allNetworkNames = @[@"Instagram", @"Github", @"Pinterest", @"Twitter", @"Tumblr", @"Ebay", @"Dribbble", @"Behance", @"Youtube", @"GooglePlus", @"Reddit", @"Imgur", @"Wordpress", @"Gravatar", @"EtsyShop", @"EtsyPeople", @"AboutMe", @"KickAssTo", @"Flickr", @"DeviantArt", @"Twitch", @"Vimeo", @"SoundCloud", @"OkCupid", @"KickStarter"];
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [ZSSDownloader sharedDownloader]"
                                 userInfo:nil];
    return nil;
}






@end
