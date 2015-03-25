//
//  ZSSPurchaseQuerier.m
//  Usernames
//
//  Created by Zachary Shakked on 3/25/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import "ZSSPurchaseQuerier.h"

@implementation ZSSPurchaseQuerier

+ (instancetype)sharedQuerier {
    static ZSSPurchaseQuerier *sharedQuerier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQuerier = [[self alloc] initPrivate];
    });
    return sharedQuerier;
}



- (instancetype)initPrivate {
    self = [super init];
    if (self) {

    }
    return self;
}

@end
