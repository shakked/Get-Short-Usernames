//
//  ZSSCloudQuerier.m
//  Get Short Usernames
//
//  Created by Zachary Shakked on 2/16/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import "ZSSCloudQuerier.h"
#import <AFNetworking/AFNetworking.h>


static NSString * const BaseURLString = @"https://api.parse.com";

@interface ZSSCloudQuerier () {
    NSString *parseApplicationId;
    NSString *parseRestAPIKey;
    UISegmentedControl *hotNewSegControl;
}

@end

@implementation ZSSCloudQuerier

+ (instancetype)sharedQuerier {
    static ZSSCloudQuerier *sharedQuerier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQuerier = [[self alloc] initPrivate];
    });
    return sharedQuerier;
}


- (void)getUsernamesForNetwork:(NSString *)networkName withCompletion:(void (^)(NSArray *, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:parseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:parseRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    NSDictionary *jsonDictionary = @{@"network" : networkName,
                                     @"available" : @YES};
    
    NSString *json = [self getJSONfromDictionary:jsonDictionary];
    NSDictionary *parameters = @{@"where" :json,
                                 @"limit" : @1000};
    
    [manager GET:@"https://api.parse.com/1/classes/ZSSUsername" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject[@"results"], nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
    }];
}

- (void)checkInstagramForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager GET:[NSString stringWithFormat:@"http://instagram.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response:%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger statusCode = operation.response.statusCode;
        
        switch (statusCode) {
            case 201:
                completion(NO, nil);
                break;
            case 404:
                completion(YES, nil);
            default:
                completion(NO, error);
                break;
        }
    }];
}

- (void)checkGithubForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager GET:[NSString stringWithFormat:@"http://github.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response:%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger statusCode = operation.response.statusCode;
        
        switch (statusCode) {
            case 201:
                completion(NO, nil);
                break;
            case 404:
                completion(YES, nil);
            default:
                completion(NO, error);
                break;
        }
    }];
}

- (void)checkPinterestForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager GET:[NSString stringWithFormat:@"https://www.pinterest.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response:%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger statusCode = operation.response.statusCode;
        
        switch (statusCode) {
            case 201:
                completion(NO, nil);
                break;
            case 404:
                completion(YES, nil);
            default:
                completion(NO, error);
                break;
        }
    }];
}

- (void)checkTumblrForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager GET:[NSString stringWithFormat:@"http://%@.tumblr.com", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response:%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSInteger statusCode = operation.response.statusCode;
        
        switch (statusCode) {
            case 201:
                completion(NO, nil);
                break;
            case 404:
                completion(YES, nil);
            default:
                completion(NO, error);
                break;
        }
    }];
}




- (void)checkTwitterForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];

}

- (void)checkEbayForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ebay.com/usr/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
    
}

- (void)checkDribbbleForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://dribbble.com/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkBehanceForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.behance.net/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkYouTubeForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/user/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkGooglePlusForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://plus.google.com/+%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkRedditForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com/user/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkImgurForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://imgur.com/user/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkWordpressForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.wordpress.com", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkGravatarForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://en.gravatar.com/profiles/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkEtsyShopForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.etsy.com/shop/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkEtsyPeopleForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.etsy.com/people/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkAboutMeForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://about.me/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkKickassToForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://kickass.to/user/%@/", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkThePirateBayForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://thepiratebay.se/user/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkFlickrForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.flickr.com/photos/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkDeviantArtForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@.deviantart.com", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkTwitchForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.twitch.tv/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkVimeoForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://vimeo.com/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkLifeHackerForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@.kinja.com", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkWikiAnswersForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://wiki.answers.com/Q/User:%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkSoundCloudForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://soundcloud.com/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkIGNForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://people.ign.com/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkOkCupidForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.okcupid.com/profile/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];}

- (void)checkTheVergeForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.theverge.com/users/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkKickStarterForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.kickstarter.com/profile/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}

- (void)checkSpotifyForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://play.spotify.com/user/%@", username]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
    [op start];
}



- (void)throwInvalidJsonDataException {
    @throw [NSException exceptionWithName:@"jsonDataException"
                                   reason:@"Failed to create NSData with provided json dictionary"
                                 userInfo:nil];
}

- (NSString *)getJSONfromDictionary:(NSDictionary *)jsonDictionary {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:&error];
    if (!jsonData) {
        [self throwInvalidJsonDataException];
    }
    
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        [self setKeys];
    }
    return self;
}


- (void)setKeys {
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
    NSDictionary *keyDict = [NSDictionary dictionaryWithContentsOfFile:keyPath];
    parseApplicationId = keyDict[@"ParseApplicationId"];
    parseRestAPIKey = keyDict[@"ParseRestAPIKey"];
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [ZSSDownloader sharedDownloader]"
                                 userInfo:nil];
    return nil;
}

@end
