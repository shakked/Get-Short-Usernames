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
#import "UIColor+Flat.h"
#import "ZSSNetworkQuerier.h"
#import "UIImage+Logos.h"
#import <CoreMotion/CoreMotion.h>

#define kUpdateInterval (1.0f / 60.0f)

@interface ZSSPurchaseViewController ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, strong) NSArray *products;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UIButton *restoreButton;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavaior;


@end

@implementation ZSSPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];

    [[ZSSIAPHelper sharedHelper] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            self.purchaseButton.enabled = YES;
        }
    }];
}

- (void)configureViews {
    [self configureNavBar];
    [self configureNetworkIcons];
}

- (void)configureNetworkIcons {
    UIImageView *dribbbleLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dribbble.png"]];
    dribbbleLogo.frame = CGRectMake(10, 80, 40, 40);
    dribbbleLogo.layer.cornerRadius = 20;
    dribbbleLogo.layer.masksToBounds = YES;
    [self.view addSubview:dribbbleLogo];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.gravity = [[UIGravityBehavior alloc] initWithItems:@[dribbbleLogo]];
    self.gravity.magnitude = 0.5;

    self.collision = [[UICollisionBehavior alloc] initWithItems:@[dribbbleLogo]];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    
    self.itemBehavaior = [[UIDynamicItemBehavior alloc] init];
    self.itemBehavaior.elasticity = 1.1;
    [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.itemBehavaior];
    [self.animator addBehavior:self.collision];
    
    NSArray *networks = [[ZSSNetworkQuerier sharedQuerier] allNetworkNames];
    CGSize size = self.view.frame.size;
    for (NSString *network in networks) {
        UIImageView *networkLogo = [[UIImageView alloc] initWithImage:[UIImage logoForNetwork:network]];
        int randomContainedX = arc4random() % (int)(size.width - 60) + 20;
        int randomContainedY = arc4random() % 30 + 50;
        networkLogo.frame = CGRectMake(randomContainedX, randomContainedY, 40, 40);
        networkLogo.layer.cornerRadius = 20;
        networkLogo.layer.masksToBounds = YES;
        [self.view addSubview:networkLogo];
        
        [self.gravity addItem:networkLogo];
        [self.collision addItem:networkLogo];
        [self.itemBehavaior addItem:networkLogo];
        
    }
    
}


- (void)configureNavBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self configureNavBarButtons];
}

- (void)configureNavBarButtons {
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                     target:self
                                                                                     action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelBarButton;
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

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)configureMotionManager {

}



@end
