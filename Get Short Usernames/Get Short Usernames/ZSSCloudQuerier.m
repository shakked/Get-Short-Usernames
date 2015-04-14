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

- (void)checkBloggerForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://%@.blogspot.com/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Blog not found"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkMySpaceForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"https://myspace.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Page Not Found"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkLinkedInForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"https://www.linkedin.com/in/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Profile Not Found"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkPhotoBucketForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://photobucket.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Sorry, the requested page does not exist."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkHuluForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.hulu.com/profiles/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"The page you were looking for doesn't exist (404 error)"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkHubPagesForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://%@.hubpages.com/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Sorry, that user does not exist."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkCafeMomForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.cafemom.com/home/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"is not a CafeMom member."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkDisqusForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"https://disqus.com/by/%@/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Uh oh... Something didn't work."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkFanpopForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.fanpop.com/fans/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![html containsString:@"My Clubs"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkStumbleUponForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.stumbleupon.com/stumbler/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"My Clubs"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkLastFMForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.last.fm/user/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"User not found"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkKongregateForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.kongregate.com/accounts/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Sorry, no account with that name was found."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkUStreamForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.ustream.tv/channel/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Sorry, the page you requested cannot be found."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkInstructablesForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.instructables.com/member/%@/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"ERROR 400: no member"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkFourSquareForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.instructables.com/member/%@/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"ERROR 400: no member"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkLiveJournalForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://%@.livejournal.com/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Unknown Journal"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkBadooForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://badoo.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"We can't seem to find this page"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkBitLyForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"https://bitly.com/u/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Something's wrong here..."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkBlipTVForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://blip.tv/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"404 - That Blip has sailed."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkSteamForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://steamcommunity.com/id/%@/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"The specified profile could not be found."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}


- (void)checkKaboodleForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.kaboodle.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Sorry, the user does not exist."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkDeliciousForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"https://delicious.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"404 Not Found"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkSoupIOForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://%@.soup.io/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![html containsString:@"Already on Facebook?"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkBuzznetForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://%@.buzznet.com/user/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Sorry, the page you requested was not found."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkTripitForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"https://www.tripit.com/people/%@#/profile/basic-info", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Page Not Found"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkFotologForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.fotolog.com/%@/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Error 404 : The requested page could not be found"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkBlinkListForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"https://disqus.com/by/%@/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Uh oh... Something didn't work."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkGogoBotForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.gogobot.com/user/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Page not found"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkAviaryForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.gogobot.com/user/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Page not found"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkFlavorsForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://%@.flavors.me/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Oh dear, this page isn't here!"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkPlancastForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://plancast.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"There's no Plancast user with the username"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkBlipFmForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://blip.fm/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Page Not Found"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkWeFollowForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://wefollow.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"They found me, I don't know how, but they found me. Run for it Marty!”"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkXboxGamertagForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.xboxgamertag.com/search/%@/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"An error occured...”"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkTripAdvisorForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.tripadvisor.com/members/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"We couldn't find that page."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkBuzzFeedForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://buzzfeed.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Page Not Found"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkBandCampForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://bandcamp.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Sorry, that something isn't here."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkBeatportForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"https://www.beatport.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Error loading page. We've been notified."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkHackerNewsForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"https://news.ycombinator.com/user?id=%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"No such user."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkLiveLeakForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://www.liveleak.com/c/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Channel cannot be found!"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkImageShackForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://imageshack.com/user/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Your images have never looked better."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkAlibabaForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"http://%@.en.alibaba.com/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Sorry, the page you're looking for cannot be found"]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkScribdForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"https://www.scribd.com/%@", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Oops, page not found."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkElanceForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"https://www.elance.com/s/%@/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"The page you have requested does not exist or is on an extended coffee break."]) {
            completion(YES, nil);
        } else {
            completion(NO, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(YES, nil);
    }];
}

- (void)checkSlackForUsername:(NSString *)username withCompletion:(void (^)(BOOL, NSError *))completion {
    [self.desktopManager GET:[NSString stringWithFormat:@"https://%@.slack.com/", username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html containsString:@"Page not found"]) {
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
