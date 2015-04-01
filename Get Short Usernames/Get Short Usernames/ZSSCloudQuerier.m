//
//  ZSSCloudQuerier.m
//  Get Short Usernames
//
//  Created by Zachary Shakked on 2/16/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import "ZSSCloudQuerier.h"
#import <AFNetworking/AFNetworking.h>

@interface ZSSCloudQuerier ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) AFHTTPRequestOperationManager *desktopManager;

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
    [self.desktopManager.operationQueue cancelAllOperations];
}

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

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        NSArray *responseSerializers = @[[AFJSONResponseSerializer serializer], [AFHTTPResponseSerializer serializer]];
        AFCompoundResponseSerializer * compoundResponseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:responseSerializers];

        self.manager = [AFHTTPRequestOperationManager manager];
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

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [ZSSDownloader sharedDownloader]"
                                 userInfo:nil];
    return nil;
}

@end
