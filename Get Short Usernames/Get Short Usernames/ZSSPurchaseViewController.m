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

#define kUpdateInterval (1.0f / 120.0f)

@interface ZSSPurchaseViewController ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, strong) NSArray *products;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UIButton *restoreButton;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavaior;

@property (assign, nonatomic) CGPoint currentPoint;
@property (assign, nonatomic) CGPoint previousPoint;
@property (assign, nonatomic) CGFloat pacmanXVelocity;
@property (assign, nonatomic) CGFloat pacmanYVelocity;
@property (assign, nonatomic) CGFloat angle;
@property (assign, nonatomic) CMAcceleration acceleration;
@property (strong, nonatomic) CMMotionManager  *motionManager;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSDate *lastUpdateTime;

@property (nonatomic, strong) NSMutableArray *randomNetworks;

@end

@implementation ZSSPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureRandomNetworks];
    [self configureViews];
    [self configureMotionManager];
    
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
    
    
    for (NSString *network in self.randomNetworks) {
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

- (void)configureRandomNetworks {
    NSUInteger networksCount = [[[ZSSNetworkQuerier sharedQuerier] allNetworkNames] count];
    NSNumber *randomInt;
    NSMutableArray *randomInts = [[NSMutableArray alloc] init];
    while (randomInts.count < 35) {
        
        randomInt = @(arc4random() % networksCount);
            
        while([randomInts containsObject:randomInt]) {
            randomInt = @(arc4random() % networksCount);
        }
        [randomInts addObject:randomInt];
    }
    
    NSMutableArray *randomNetworks = [[NSMutableArray alloc] init];
    NSArray *allNetworks = [[ZSSNetworkQuerier sharedQuerier] allNetworkNames];
    
    for (NSNumber *number in randomInts) {
        NSString *network = allNetworks[number.intValue];
        [randomNetworks addObject:network];
    }
    self.randomNetworks = [[NSMutableArray alloc] initWithArray:randomNetworks];
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
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [self configureMotionManager];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.motionManager stopDeviceMotionUpdates];
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
    
    self.motionManager = [[CMMotionManager alloc]  init];
    self.queue         = [[NSOperationQueue alloc] init];
    
    self.motionManager.accelerometerUpdateInterval = kUpdateInterval;
    
    [self.motionManager startDeviceMotionUpdatesToQueue:self.queue withHandler:^(CMDeviceMotion *motion, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
        
        CGFloat x = motion.gravity.x;
        CGFloat y = motion.gravity.y;
        CGPoint p = CGPointMake(x,y);
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            float t = p.x;
            p.x = 0 - p.y;
            p.y = t;
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            float t = p.x;
            p.x = p.y;
            p.y = 0 - t;
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            p.x *= -1;
            p.y *= -1;
        }
        
        CGVector v = CGVectorMake(p.x, 0 - p.y);
        self.gravity.gravityDirection = v;
    }];
}

- (void)movePacman {
    CGFloat newAngle = (self.pacmanXVelocity + self.pacmanYVelocity) * M_PI * 4;
    self.angle += newAngle * kUpdateInterval;
    self.gravity.angle = self.angle;
    
}
@end
