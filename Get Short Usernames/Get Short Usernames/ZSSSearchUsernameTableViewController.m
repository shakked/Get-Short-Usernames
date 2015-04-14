//
//  ZSSSearchUsernameTableViewController.m
//  Get Short Usernames
//
//  Created by Zachary Shakked on 2/17/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import "ZSSSearchUsernameTableViewController.h"
#import "UIColor+Flat.h"
#import "ZSSSearchTableViewCell.h"
#import "ZSSCloudQuerier.h"
#import "ZSSNetworkSettingsTableViewController.h"
#import "ZSSNetworkQuerier.h"
#import "UIImage+Logos.h"
#import <AFNetworking.h>

static NSString *MESSAGE_CELL_CLASS = @"ZSSSearchTableViewCell";
static NSString *CELL_IDENTIFIER = @"cell";

@interface ZSSSearchUsernameTableViewController () <UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *currentUsername;
@property (nonatomic, strong) NSArray *selectedNetworks;
@property (nonatomic, strong) NSMutableArray *availableNetworks;

@property (nonatomic, strong) NSTimer * debounceTimer;
@property (nonatomic, strong) AFHTTPRequestOperationManager * manager;

@end

@implementation ZSSSearchUsernameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor belizeHoleColor];
    self.selectedNetworks = [[ZSSNetworkQuerier sharedQuerier] selectedNetworks];
    [self.tableView reloadData];
}
- (void)configureViews {
    [self configureNavBar];
    [self configureTableView];
}

- (void)configureNavBar {
    self.navigationController.navigationBar.barTintColor = [UIColor belizeHoleColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor cloudsColor],
                                                                    NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:26.0]};
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.searchBar.placeholder = @"Enter Desired Username";
    self.searchBar.tintColor = [UIColor belizeHoleColor];
    
    self.navigationItem.titleView = self.searchBar;

    [self configureNavBarButtons];
}

- (void)configureNavBarButtons {
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.bounds = CGRectMake(0, 0, 25, 25);
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"SettingsIcon"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(showSettingsView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    self.navigationItem.leftBarButtonItem = settingsBarButton;
    
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarButtonPressed)];
    self.navigationItem.rightBarButtonItem = searchBarButton;
    
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor cloudsColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:MESSAGE_CELL_CLASS bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.selectedNetworks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSSSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    NSString *networkName = self.selectedNetworks[indexPath.row];
    [self configureCell:cell forIndexPath:indexPath andNetworkName:networkName];
    cell.usernameLabel.text = self.currentUsername;
    cell.usernameLabel.font = [UIFont fontWithName:@"Avenir-Black" size:18.0];
    cell.logoButton.imageView.layer.masksToBounds = YES;
    cell.logoButton.imageView.layer.cornerRadius = 25;
    if ([self.availableNetworks containsObject:networkName]) {
        cell.checkImageView.image = [UIImage imageNamed:@"CheckmarkIcon"];
    } else {
        cell.checkImageView.image = [UIImage imageNamed:@"XIcon"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
    
}

- (void)configureCell:(ZSSSearchTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath andNetworkName:(NSString *)networkName {

    [cell.logoButton setImage:[UIImage logoForNetwork:networkName] forState:UIControlStateNormal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self startSearching:searchBar.text];
    
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@" "]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.currentUsername = searchText;
    [self.tableView reloadData];
    [self.searchBar becomeFirstResponder];
    
    [self.debounceTimer invalidate];
    self.debounceTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onDebounceTimerFired:) userInfo:nil repeats:NO];
}

- (void) onDebounceTimerFired: (NSTimer *) timer {
    [self.manager.operationQueue cancelAllOperations];
    self.availableNetworks = [[NSMutableArray alloc] initWithArray:@[]];
    [self.tableView reloadData];
    [self startSearching:self.searchBar.text];
}

- (void)searchBarButtonPressed {
    [self startSearching:self.searchBar.text];
}

- (void)startSearching:(NSString *)searchText {

    if ([self.selectedNetworks containsObject:@"Instagram"]) {
        [[ZSSCloudQuerier sharedQuerier] checkInstagramForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Instagram"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Instagram"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Github"]) {
        [[ZSSCloudQuerier sharedQuerier] checkGithubForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Github"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Github"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Pinterest"]) {
        [[ZSSCloudQuerier sharedQuerier] checkPinterestForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Pinterest"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Pinterest"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Twitter"]) {
        [[ZSSCloudQuerier sharedQuerier] checkTwitterForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Twitter"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Twitter"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Tumblr"]) {
        [[ZSSCloudQuerier sharedQuerier] checkTumblrForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Tumblr"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Tumblr"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Ebay"]) {
        [[ZSSCloudQuerier sharedQuerier] checkEbayForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Ebay"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Ebay"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Dribbble"]) {
        [[ZSSCloudQuerier sharedQuerier] checkDribbbleForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Dribbble"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Dribbble"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Behance"]) {
        [[ZSSCloudQuerier sharedQuerier] checkBehanceForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Behance"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Behance"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Youtube"]) {
        [[ZSSCloudQuerier sharedQuerier] checkYoutubeForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Youtube"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Youtube"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"GooglePlus"]) {
        [[ZSSCloudQuerier sharedQuerier] checkGooglePlusForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"GooglePlus"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"GooglePlus"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Reddit"]) {
        [[ZSSCloudQuerier sharedQuerier] checkRedditForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Reddit"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Reddit"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Imgur"]) {
        [[ZSSCloudQuerier sharedQuerier] checkImgurForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Imgur"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Imgur"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Wordpress"]) {
        [[ZSSCloudQuerier sharedQuerier] checkWordpressForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Wordpress"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Wordpress"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Gravatar"]) {
        [[ZSSCloudQuerier sharedQuerier] checkGravatarForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Gravatar"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Gravatar"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"EtsyShop"]) {
        [[ZSSCloudQuerier sharedQuerier] checkEtsyShopForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"EtsyShop"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"EtsyShop"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"EtsyPeople"]) {
        [[ZSSCloudQuerier sharedQuerier] checkEtsyPeopleForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"EtsyPeople"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"EtsyPeople"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"AboutMe"]) {
        [[ZSSCloudQuerier sharedQuerier] checkAboutMeForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"AboutMe"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"AboutMe"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    if ([self.selectedNetworks containsObject:@"KickAssTo"]) {
        [[ZSSCloudQuerier sharedQuerier] checkKickAssToForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"KickAssTo"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"KickAssTo"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Flickr"]) {
        [[ZSSCloudQuerier sharedQuerier] checkFlickrForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Flickr"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Flickr"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"DeviantArt"]) {
        [[ZSSCloudQuerier sharedQuerier] checkDeviantArtForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"DeviantArt"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"DeviantArt"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Twitch"]) {
        [[ZSSCloudQuerier sharedQuerier] checkTwitchForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Twitch"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Twitch"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Vimeo"]) {
        [[ZSSCloudQuerier sharedQuerier] checkVimeoForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Vimeo"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Vimeo"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"SoundCloud"]) {
        [[ZSSCloudQuerier sharedQuerier] checkSoundCloudForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                NSLog(@"soundlcoud is available");
                [self.availableNetworks addObject:@"SoundCloud"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"SoundCloud"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"OkCupid"]) {
        [[ZSSCloudQuerier sharedQuerier] checkOkCupidForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"OkCupid"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"OkCupid"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"KickStarter"]) {
        [[ZSSCloudQuerier sharedQuerier] checkKickStarterForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"KickStarter"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"KickStarter"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Blogger"]) {
        [[ZSSCloudQuerier sharedQuerier] checkBloggerForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Blogger"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Blogger"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"MySpace"]) {
        [[ZSSCloudQuerier sharedQuerier] checkMySpaceForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"MySpace"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"MySpace"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"LinkedIn"]) {
        [[ZSSCloudQuerier sharedQuerier] checkLinkedInForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"LinkedIn"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"LinkedIn"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"PhotoBucket"]) {
        [[ZSSCloudQuerier sharedQuerier] checkPhotoBucketForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"PhotoBucket"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"PhotoBucket"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Hulu"]) {
        [[ZSSCloudQuerier sharedQuerier] checkHuluForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Hulu"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Hulu"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"HubPages"]) {
        [[ZSSCloudQuerier sharedQuerier] checkHubPagesForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"HubPages"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"HubPages"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"CafeMom"]) {
        [[ZSSCloudQuerier sharedQuerier] checkCafeMomForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"CafeMom"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"CafeMom"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Disqus"]) {
        [[ZSSCloudQuerier sharedQuerier] checkDisqusForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Disqus"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Disqus"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Fanpop"]) {
        [[ZSSCloudQuerier sharedQuerier] checkFanpopForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Fanpop"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Fanpop"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"StumbleUpon"]) {
        [[ZSSCloudQuerier sharedQuerier] checkStumbleUponForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"StumbleUpon"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"StumbleUpon"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"LastFM"]) {
        [[ZSSCloudQuerier sharedQuerier] checkLastFMForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"LastFM"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"LastFM"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Kongregate"]) {
        [[ZSSCloudQuerier sharedQuerier] checkKongregateForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Kongregate"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Kongregate"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"UStream"]) {
        [[ZSSCloudQuerier sharedQuerier] checkUStreamForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"UStream"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"UStream"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Instructables"]) {
        [[ZSSCloudQuerier sharedQuerier] checkInstructablesForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Instructables"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Instructables"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"LiveJournal"]) {
        [[ZSSCloudQuerier sharedQuerier] checkLiveJournalForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"LiveJournal"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"LiveJournal"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Badoo"]) {
        [[ZSSCloudQuerier sharedQuerier] checkBadooForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Badoo"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Badoo"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"BitLy"]) {
        [[ZSSCloudQuerier sharedQuerier] checkBloggerForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Blogger"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Blogger"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"BlipTV"]) {
        [[ZSSCloudQuerier sharedQuerier] checkBlipTVForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"BlipTV"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"BlipTV"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }

    if ([self.selectedNetworks containsObject:@"Steam"]) {
        [[ZSSCloudQuerier sharedQuerier] checkSteamForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Steam"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Steam"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Kaboodle"]) {
        [[ZSSCloudQuerier sharedQuerier] checkKaboodleForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Kaboodle"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Kaboodle"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Delicious"]) {
        [[ZSSCloudQuerier sharedQuerier] checkDeliciousForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Delicious"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Delicious"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"SoupIO"]) {
        [[ZSSCloudQuerier sharedQuerier] checkSoupIOForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"SoupIO"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"SoupIO"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Buzznet"]) {
        [[ZSSCloudQuerier sharedQuerier] checkBuzznetForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Buzznet"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Buzznet"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Tripit"]) {
        [[ZSSCloudQuerier sharedQuerier] checkTripitForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Tripit"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Tripit"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Fotolog"]) {
        [[ZSSCloudQuerier sharedQuerier] checkFotologForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Fotolog"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Fotolog"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"BlinkList"]) {
        [[ZSSCloudQuerier sharedQuerier] checkBlinkListForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"BlinkList"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"BlinkList"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"GogoBot"]) {
        [[ZSSCloudQuerier sharedQuerier] checkGogoBotForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"GogoBot"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"GogoBot"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Aviary"]) {
        [[ZSSCloudQuerier sharedQuerier] checkAviaryForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Aviary"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Aviary"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Flavors"]) {
        [[ZSSCloudQuerier sharedQuerier] checkFlavorsForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Flavors"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Flavors"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Plancast"]) {
        [[ZSSCloudQuerier sharedQuerier] checkPlancastForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Plancast"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Plancast"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"WeFollow"]) {
        [[ZSSCloudQuerier sharedQuerier] checkWeFollowForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"WeFollow"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"WeFollow"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"XboxGamertag"]) {
        [[ZSSCloudQuerier sharedQuerier] checkXboxGamertagForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"XboxGamertag"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"XboxGamertag"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }

    
    if ([self.selectedNetworks containsObject:@"TripAdvisor"]) {
        [[ZSSCloudQuerier sharedQuerier] checkTripAdvisorForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"TripAdvisor"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"TripAdvisor"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"BuzzFeed"]) {
        [[ZSSCloudQuerier sharedQuerier] checkBuzzFeedForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"BuzzFeed"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"BuzzFeed"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"BandCamp"]) {
        [[ZSSCloudQuerier sharedQuerier] checkBandCampForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"BandCamp"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"BandCamp"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Beatport"]) {
        [[ZSSCloudQuerier sharedQuerier] checkBeatportForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Beatport"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Beatport"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"HackerNews"]) {
        [[ZSSCloudQuerier sharedQuerier] checkHackerNewsForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"HackerNews"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"HackerNews"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"LiveLeak"]) {
        [[ZSSCloudQuerier sharedQuerier] checkLiveLeakForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"LiveLeak"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"LiveLeak"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"ImageShack"]) {
        [[ZSSCloudQuerier sharedQuerier] checkImageShackForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"ImageShack"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"ImageShack"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Alibaba"]) {
        [[ZSSCloudQuerier sharedQuerier] checkAlibabaForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Alibaba"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Alibaba"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Scribd"]) {
        [[ZSSCloudQuerier sharedQuerier] checkScribdForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Scribd"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Scribd"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Elance"]) {
        [[ZSSCloudQuerier sharedQuerier] checkElanceForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Elance"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Elance"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"Slack"]) {
        [[ZSSCloudQuerier sharedQuerier] checkSlackForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Slack"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Slack"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (void)showSettingsView {
    ZSSNetworkSettingsTableViewController *nstvc = [[ZSSNetworkSettingsTableViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:nstvc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _availableNetworks = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
