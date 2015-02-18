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
    NSDictionary *jsonDictionary = @{@"network" : networkName};
    

    NSDictionary *parameters = @{@"where" : @{@"network" : networkName},
                                 @"limit" : @100};
    
    [manager GET:@"https://api.parse.com/1/classes/ZSSUsername" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject[@"results"], nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
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
