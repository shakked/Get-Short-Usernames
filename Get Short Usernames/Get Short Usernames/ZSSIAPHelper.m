//
//  ZSSIAPHelper.m
//  Usernames
//
//  Created by Zachary Shakked on 3/26/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import "ZSSIAPHelper.h"

@implementation ZSSIAPHelper


+ (ZSSIAPHelper *)sharedHelper {
    static dispatch_once_t once;
    static ZSSIAPHelper *sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.zacharyshakked.iap.UnlockAllNetworks",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}


@end
