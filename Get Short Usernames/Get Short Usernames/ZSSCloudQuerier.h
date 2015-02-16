//
//  ZSSCloudQuerier.h
//  Get Short Usernames
//
//  Created by Zachary Shakked on 2/16/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSSCloudQuerier : NSObject

- (void)getUsernamesForNetwork:(NSString *)networkName withCompletion:(void (^)(NSArray *, NSError *))completionBlock;

@end
