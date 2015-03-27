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

static NSString *MESSAGE_CELL_CLASS = @"ZSSSearchTableViewCell";
static NSString *CELL_IDENTIFIER = @"cell";

@interface ZSSSearchUsernameTableViewController () <UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *currentUsername;
@property (nonatomic, strong) NSArray *selectedNetworks;
@property (nonatomic, strong) NSMutableArray *availableNetworks;
@property (nonatomic, strong) NSDate *timeOfLastRequest;

@property (nonatomic) BOOL isInstagramAvailable;
@property (nonatomic) BOOL isGithubAvailable;
@property (nonatomic) BOOL isPinterestAvailable;
@property (nonatomic) BOOL isTwitterAvailable;
@property (nonatomic) BOOL isTumblrAvailable;
@property (nonatomic) BOOL isEbayAvailable;
@property (nonatomic) BOOL isDribbbleAvailable;
@property (nonatomic) BOOL isBehanceAvailable;
@property (nonatomic) BOOL isYoutubeAvailable;
@property (nonatomic) BOOL isGooglePlusAvailable;
@property (nonatomic) BOOL isRedditAvailable;
@property (nonatomic) BOOL isImgurAvailable;
@property (nonatomic) BOOL isWordpressAvailable;
@property (nonatomic) BOOL isGravatarAvailable;
@property (nonatomic) BOOL isEtsyShopAvailable;
@property (nonatomic) BOOL isEtsyPeopleAvailable;
@property (nonatomic) BOOL isAboutMeAvailable;
@property (nonatomic) BOOL isKickAssToAvailable;
@property (nonatomic) BOOL isThePirateBayAvailable;
@property (nonatomic) BOOL isFlickrAvailable;
@property (nonatomic) BOOL isDeviantArtAvailable;
@property (nonatomic) BOOL isTwitchAvailable;
@property (nonatomic) BOOL isVimeoAvailable;
@property (nonatomic) BOOL isLifeHackerAvailable;
@property (nonatomic) BOOL isWikiAnswersAvailable;
@property (nonatomic) BOOL isSoundCloudAvailable;
@property (nonatomic) BOOL isIGNAvailable;
@property (nonatomic) BOOL isOkCupidAvailable;
@property (nonatomic) BOOL isTheVergeAvailable;
@property (nonatomic) BOOL isKickStarterAvailable;
@property (nonatomic) BOOL isSpotifyAvailable;


@end

@implementation ZSSSearchUsernameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
}

- (void)viewWillAppear:(BOOL)animated {
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
    self.navigationItem.titleView = self.searchBar;
    
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
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.selectedNetworks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSSSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    NSString *networkName = self.selectedNetworks[indexPath.row];
    [self configureCell:cell forIndexPath:indexPath andNetworkName:networkName];
    cell.usernameLabel.text = self.currentUsername;
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
    [self resetNetworkBools];
    self.currentUsername = searchText;
    [self.tableView reloadData];
    [self.searchBar becomeFirstResponder];
    
    if ([self.timeOfLastRequest timeIntervalSinceDate:[NSDate date]] >= 2) {
        [self startSearching:searchText];
        self.timeOfLastRequest = [NSDate date];
    }
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
    
    if ([self.selectedNetworks containsObject:@"ThePirateBay"]) {
        [[ZSSCloudQuerier sharedQuerier] checkThePirateBayForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"ThePirateBay"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"ThePirateBay"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
    
    if ([self.selectedNetworks containsObject:@"LifeHacker"]) {
        [[ZSSCloudQuerier sharedQuerier] checkLifeHackerForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"LifeHacker"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"LifeHacker"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"WikiAnswers"]) {
        [[ZSSCloudQuerier sharedQuerier] checkWikiAnswersForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"WikiAnswers"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"WikiAnswers"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"SoundCloud"]) {
        [[ZSSCloudQuerier sharedQuerier] checkSoundCloudForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"SoundCloud"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"SoundCloud"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
    
    if ([self.selectedNetworks containsObject:@"IGN"]) {
        [[ZSSCloudQuerier sharedQuerier] checkIGNForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"IGN"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"IGN"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
    
    if ([self.selectedNetworks containsObject:@"TheVerge"]) {
        [[ZSSCloudQuerier sharedQuerier] checkTheVergeForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"TheVerge"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"TheVerge"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
    
    if ([self.selectedNetworks containsObject:@"Spotify"]) {
        [[ZSSCloudQuerier sharedQuerier] checkSpotifyForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
            if (available) {
                [self.availableNetworks addObject:@"Spotify"];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedNetworks indexOfObject:@"Spotify"] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        }];
    }
}

- (void)resetNetworkBools {
    [self.availableNetworks removeAllObjects];
//    self.isInstagramAvailable = NO;
//    self.isGithubAvailable = NO;
//    self.isPinterestAvailable = NO;
//    self.isTwitterAvailable = NO;
//    self.isTumblrAvailable = NO;
//    self.isEbayAvailable = NO;
//    self.isDribbbleAvailable = NO;
//    self.isBehanceAvailable = NO;
//    self.isYoutubeAvailable = NO;
//    self.isGooglePlusAvailable = NO;
//    self.isRedditAvailable = NO;
//    self.isImgurAvailable = NO;
//    self.isWordpressAvailable = NO;
//    self.isGravatarAvailable = NO;
//    self.isEtsyShopAvailable = NO;
//    self.isEtsyPeopleAvailable = NO;
//    self.isAboutMeAvailable = NO;
//    self.isKickAssToAvailable = NO;
//    self.isThePirateBayAvailable = NO;
//    self.isFlickrAvailable = NO;
//    self.isDeviantArtAvailable = NO;
//    self.isTwitchAvailable = NO;
//    self.isVimeoAvailable = NO;
//    self.isLifeHackerAvailable = NO;
//    self.isWikiAnswersAvailable = NO;
//    self.isSoundCloudAvailable = NO;
//    self.isIGNAvailable = NO;
//    self.isOkCupidAvailable = NO;
//    self.isTheVergeAvailable = NO;
//    self.isKickStarterAvailable = NO;
//    self.isSpotifyAvailable = NO;
//    self.isTumblrAvailable = NO;
//    self.isTumblrAvailable = NO;
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
        _timeOfLastRequest = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return self;
}

@end
