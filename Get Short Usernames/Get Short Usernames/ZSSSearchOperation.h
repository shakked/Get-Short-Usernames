//
//  ZSSSearchOperation.h
//  Usernames
//
//  Created by Zachary Shakked on 3/28/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSSSearchOperationDelegate.h"

@interface ZSSSearchOperation : NSOperation

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, weak) id<ZSSSearchOperationDelegate> delegate;

@end
