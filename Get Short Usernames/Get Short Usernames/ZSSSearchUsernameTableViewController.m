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
        
    }
    
    if ([self.selectedNetworks containsObject:@"MySpace"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"LinkedIn"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"PhotoBucket"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Hulu"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"HubPages"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"CafeMom"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Disqus"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Fanpop"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"StumbleUpon"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"LastFM"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Kongregate"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"UStream"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Instructables"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"FourSquare"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"LiveJournal"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Badoo"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"BitLy"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"BlipTV"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Steam"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Kaboodle"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Viddler"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Delicious"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Xanga"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"SoupIO"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Digg"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Buzznet"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Technorati"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Tripit"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Fotolog"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Faves"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Netvibes"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"BlinkList"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"GogoBot"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Aviary"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"FoodSpotting"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Flavors"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Plancast"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"BlipFm"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"WeFollow"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Wishlistr"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"XboxGamertag"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"PlayStationNetwork"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"TripAdvisor"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"BuzzFeed"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"BandCamp"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Beatport"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"HackerNews"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"LiveLeak"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"ImageShack"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Alibaba"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Scribd"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Elance"]) {
        
    }
    
    if ([self.selectedNetworks containsObject:@"Slack"]) {
        
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
