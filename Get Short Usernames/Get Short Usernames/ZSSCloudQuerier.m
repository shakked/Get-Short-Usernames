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

- (void)cancelAllOperations {
    [self.manager.operationQueue cancelAllOperations];
}

- (NSString *)urlForNetwork:(NSString *)network forUsername:(NSString *)username{
    NSString *url;
    if ([network isEqualToString:@"Instagram"]) {
        url = [NSString stringWithFormat:@"http://instagram.com/%@", username];
    } else if ([network isEqualToString:@"Github"]) {
        url = [NSString stringWithFormat:@"http://github.com/%@", username];
    } else if ([network isEqualToString:@"Pinterest"]) {
        url = [NSString stringWithFormat:@"https://www.pinterest.com/%@", username];
    } else if ([network isEqualToString:@"Twitter"]) {
        url = [NSString stringWithFormat:@"https://twitter.com/%@", username];
    } else if ([network isEqualToString:@"Tumblr"]) {
        [NSString stringWithFormat:@"http://%@.tumblr.com", username];
    } else if ([network isEqualToString:@"Ebay"]) {
        url = [NSString stringWithFormat:@"http://www.ebay.com/usr/%@", username];
    } else if ([network isEqualToString:@"Dribbble"]) {
        url = [NSString stringWithFormat:@"https://dribbble.com/%@", username];
    } else if ([network isEqualToString:@"Behance"]) {
        url = [NSString stringWithFormat:@"https://www.behance.net/%@", username];
    } else if ([network isEqualToString:@"Youtube"]) {
        url = [NSString stringWithFormat:@"https://www.youtube.com/user/%@", username];
    } else if ([network isEqualToString:@"GooglePlus"]) {
        url = [NSString stringWithFormat:@"https://plus.google.com/+%@", username];
    } else if ([network isEqualToString:@"Reddit"]) {
        url = [NSString stringWithFormat:@"http://www.reddit.com/user/%@", username];
    } else if ([network isEqualToString:@"Imgur"]) {
        url = [NSString stringWithFormat:@"http://imgur.com/user/%@", username];
    } else if ([network isEqualToString:@"Wordpress"]) {
        url = [NSString stringWithFormat:@"https://%@.wordpress.com", username];
    } else if ([network isEqualToString:@"Gravatar"]) {
        url = [NSString stringWithFormat:@"http://en.gravatar.com/profiles/%@", username];
    } else if ([network isEqualToString:@"EtsyShop"]) {
        url = [NSString stringWithFormat:@"https://www.etsy.com/shop/%@", username];
    } else if ([network isEqualToString:@"EtsyPeople"]) {
        url = [NSString stringWithFormat:@"https://www.etsy.com/people/%@", username];
    } else if ([network isEqualToString:@"AboutMe"]) {
        url = [NSString stringWithFormat:@"https://about.me/%@", username];
    } else if ([network isEqualToString:@"KickAssTo"]) {
        url = [NSString stringWithFormat:@"http://kickass.to/user/%@/", username];
    } else if ([network isEqualToString:@"ThePirateBay"]) {
        url = [NSString stringWithFormat:@"https://thepiratebay.se/user/%@", username];
    } else if ([network isEqualToString:@"Flickr"]) {
        url = [NSString stringWithFormat:@"https://www.flickr.com/photos/%@", username];
    } else if ([network isEqualToString:@"DeviantArt"]) {
        url = [NSString stringWithFormat:@"http://%@.deviantart.com", username];
    } else if ([network isEqualToString:@"Twitch"]) {
        url = [NSString stringWithFormat:@"http://www.twitch.tv/%@", username];
    } else if ([network isEqualToString:@"Vimeo"]) {
        url = [NSString stringWithFormat:@"https://vimeo.com/%@", username];
    } else if ([network isEqualToString:@"LifeHacker"]) {
        url = [NSString stringWithFormat:@"http://%@.kinja.com", username];
    } else if ([network isEqualToString:@"WikiAnswers"]) {
        url = [NSString stringWithFormat:@"https://wiki.answers.com/Q/User:%@", username];
    } else if ([network isEqualToString:@"SoundCloud"]) {
        url = [NSString stringWithFormat:@"https://soundcloud.com/%@", username];
    } else if ([network isEqualToString:@"IGN"]) {
        url = [NSString stringWithFormat:@"http://people.ign.com/%@", username];
    } else if ([network isEqualToString:@"OkCupid"]) {
        url = [NSString stringWithFormat:@"http://www.okcupid.com/profile/%@", username];
    } else if ([network isEqualToString:@"TheVerge"]) {
        url = [NSString stringWithFormat:@"http://www.theverge.com/users/%@", username];
    } else if ([network isEqualToString:@"KickStarter"]) {
        url = [NSString stringWithFormat:@"https://www.kickstarter.com/profile/%@", username];
    } else if ([network isEqualToString:@"Spotify"]) {
        url = [NSString stringWithFormat:@"https://play.spotify.com/user/%@", username];
    }
    return url;

}



- (void)getUsernamesForNetwork:(NSString *)networkName withCompletion:(void (^)(NSArray *, NSError *))completion {
     
    [self.manager.requestSerializer setValue:parseApplicationId forHTTPHeaderField:@"X-Parse-Application-Id"];
    [self.manager.requestSerializer setValue:parseRestAPIKey forHTTPHeaderField:@"X-Parse-REST-API-Key"];
      NSDictionary *jsonDictionary = @{@"network" : networkName,
                                     @"available" : @YES};
    
    NSString *json = [self getJSONfromDictionary:jsonDictionary];
    NSDictionary *parameters = @{@"where" :json,
                                 @"limit" : @1000};
    
    [self.manager GET:@"https://api.parse.com/1/classes/ZSSUsername" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject[@"results"], nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
    }];
}

- (void)checkNetworkURL:(NSString *)networkURL forUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
     
     
      
    [self.manager GET:networkURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    }];}

- (void)checkInstagramForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"http://instagram.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [self.manager GET:[NSString stringWithFormat:@"http://github.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [self.manager GET:[NSString stringWithFormat:@"https://www.pinterest.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [self.manager GET:[NSString stringWithFormat:@"http://%@.tumblr.com", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    [self.desktopManager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.104 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    
    [self.desktopManager GET:[NSString stringWithFormat:@"https://twitter.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, error);
    }];
}

- (void)checkEbayForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"http://www.ebay.com/usr/%@",username] parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             if ([html containsString:@"The User ID you entered was not found"]) {
                 completion(YES, nil);
             } else {
                 completion(NO, nil);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(NO, error);
         }
     ];
}

- (void)checkDribbbleForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"https://dribbble.com/%@", username] parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  if ([html containsString:@"the page you were looking"]) {
                      completion(YES, nil);
                  } else {
                      completion(NO, nil);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  completion(YES, error);
              }
     ];
}

- (void)checkBehanceForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"https://www.behance.net/%@", username] parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  if ([html containsString:@"This page cannot be found"]) {
                      completion(YES, nil);
                  } else {
                      completion(NO, nil);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  completion(YES, error);
              }
     ];
}

- (void)checkYoutubeForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.104 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    
    [self.desktopManager GET:[NSString stringWithFormat:@"https://youtube.com/user/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(NO, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, error);
    }];
    
}

- (void)checkGooglePlusForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"https://plus.google.com/+%@", username] parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  if ([html containsString:@"This profile could not be found"]) {
                      completion(YES, nil);
                  } else {
                      completion(NO, nil);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  completion(NO, error);
              }
     ];
}

- (void)checkRedditForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"http://www.reddit.com/user/%@", username] parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  if ([html containsString:@"page not found"]) {
                      completion(YES, nil);
                  } else {
                      completion(NO, nil);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  completion(YES, error);
              }
     ];
}

- (void)checkImgurForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"http://imgur.com/user/%@", username] parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  if ([html containsString:@"Zoinks! You've taken a wrong turn."]) {
                      completion(YES, nil);
                  } else {
                      completion(NO, nil);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  completion(YES, error);
              }
     ];
}

- (void)checkWordpressForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"https://%@.wordpress.com",username] parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             if ([html containsString:@"doesn&#8217;t&nbsp;exist"]) {
                 completion(YES, nil);
             } else {
                 completion(NO, nil);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(NO, error);
         }
     ];
}

- (void)checkGravatarForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"http://en.gravatar.com/profiles/%@",username] parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  if ([html containsString:@"doesn&#8217;t&nbsp;exist"]) {
                      completion(YES, nil);
                  } else {
                      completion(NO, nil);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  completion(YES, error);
              }
     ];
}

- (void)checkEtsyShopForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"https://www.etsy.com/shop/%@",username] parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  if ([html containsString:@"doesn&#8217;t&nbsp;exist"]) {
                      completion(YES, nil);
                  } else {
                      completion(NO, nil);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  completion(YES, error);
              }
     ];
}

- (void)checkEtsyPeopleForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"https://www.etsy.com/people/%@",username] parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  if ([html containsString:@"doesn&#8217;t&nbsp;exist"]) {
                      completion(YES, nil);
                  } else {
                      completion(NO, nil);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  completion(YES, error);
              }
     ];
}

- (void)checkAboutMeForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"https://about.me/%@",username] parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             if ([html containsString:@"could not be found. Try search."]) {
                 
                 completion(YES, nil);
             } else {
                 completion(NO, nil);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(NO, error);
         }
     ];
}

- (void)checkKickAssToForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"http://kickass.to/user/%@/",username] parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  if ([html containsString:@"Page not found"]) {
                      completion(YES, nil);
                  } else {
                      completion(NO, nil);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  completion(YES, error);
              }
     ];
}

- (void)checkFlickrForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"https://www.flickr.com/photos/%@",username] parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  if ([html containsString:@"Page Not Found"]) {
                      completion(YES, nil);
                  } else {
                      completion(NO, nil);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  completion(YES, error);
              }
     ];
}

- (void)checkDeviantArtForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"http://%@.deviantart.com",username] parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  if ([html containsString:@"The page you were looking for doesn't exist."]) {
                      completion(YES, nil);
                  } else {
                      completion(NO, nil);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  completion(YES, error);
              }
     ];
}

- (void)checkTwitchForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
     [self.manager GET:[NSString stringWithFormat:@"http://www.twitch.tv/%@",username] parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             if ([html containsString:@"content='Twitch' property='og:title'"]) {
                 
                 completion(YES, nil);
             } else {
                 
                 completion(NO, nil);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             completion(NO, error);
         }
     ];
}

- (void)checkVimeoForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"https://vimeo.com/%@",username] parameters:nil
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  if ([html containsString:@"Please check to make sure you’ve typed the URL correctly. You may also want to search for what you are looking for."]) {
                      completion(YES, nil);
                  } else {
                      completion(NO, nil);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  completion(YES, error);
              }
     ];
}

- (void)checkSoundCloudForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"https://soundcloud.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Sorry"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkOkCupidForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"http://www.okcupid.com/profile/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Join the best free dating site on Earth."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkKickStarterForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.manager GET:[NSString stringWithFormat:@"https://www.kickstarter.com/profile/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Oh my goodness"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
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
        self.manager = [AFHTTPRequestOperationManager manager];
        
        NSArray *responseSerializers = @[[AFJSONResponseSerializer serializer], [AFHTTPResponseSerializer serializer]];
        AFCompoundResponseSerializer * compoundResponseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:responseSerializers];
        self.manager.responseSerializer = compoundResponseSerializer;
        self.manager.operationQueue.maxConcurrentOperationCount = 5;
        self.manager.securityPolicy.allowInvalidCertificates = YES;
        
        self.desktopManager = [AFHTTPRequestOperationManager manager];
        self.desktopManager.responseSerializer = compoundResponseSerializer;
        self.desktopManager.operationQueue.maxConcurrentOperationCount = 5;
        self.desktopManager.securityPolicy.allowInvalidCertificates = YES;
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
