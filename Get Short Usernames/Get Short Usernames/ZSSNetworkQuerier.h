//
//  ZSSNetworkQuerier.h
//  Usernames
//
//  Created by Zachary Shakked on 3/23/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSSNetworkQuerier : NSObject

+ (instancetype)sharedQuerier;
- (BOOL)didUnlockAllNetworks;
- (BOOL)addNetwork:(NSString *)networkName;
- (BOOL)removeNetwork:(NSString *)networkName;

@property (nonatomic, strong) NSArray *allNetworkNames;
- (NSMutableArray *)selectedNetworks;
- (void)saveNetworks:(NSArray *)networks;

@end
