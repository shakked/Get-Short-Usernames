//
//  ZSSPurchaseViewController.m
//  Usernames
//
//  Created by Zachary Shakked on 3/25/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import "ZSSPurchaseViewController.h"
#import <StoreKit/StoreKit.h>
#import "ZSSIAPHelper.h"

@interface ZSSPurchaseViewController ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, strong) NSArray *products;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UIButton *restoreButton;
@property (weak, nonatomic) IBOutlet UIButton *showAllNetworksButton;

@end

@implementation ZSSPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[ZSSIAPHelper sharedHelper] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            self.purchaseButton.enabled = YES;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            NSLog(@"product was purchases");
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)purchaseButtonPressed:(id)sender {

    SKProduct *product = self.products[0];
    NSLog(@"Buying %@", product.productIdentifier);
    [[ZSSIAPHelper sharedHelper] buyProduct:product];
    
}

- (IBAction)restoreButtonPressed:(id)sender {


}

- (IBAction)showAllNetworksButtonPressed:(id)sender {


}

@end
