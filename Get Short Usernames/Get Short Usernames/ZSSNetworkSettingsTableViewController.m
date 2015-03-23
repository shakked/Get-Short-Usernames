//
//  ZSSNetworkSettingsTableViewController.m
//  Usernames
//
//  Created by Zachary Shakked on 3/23/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import "ZSSNetworkSettingsTableViewController.h"
#import "UIColor+Flat.h"
#import "ZSSUsernameTableViewCell.h"
#import "ZSSNetworkQuerier.h"
#import "ZSSNetworkSelectCell.h"

static NSString *MESSAGE_CELL_CLASS = @"ZSSNetworkSelectCell";
static NSString *CELL_IDENTIFIER = @"cell";

@interface ZSSNetworkSettingsTableViewController ()

@property (nonatomic, strong) NSArray *allNetworkNames;

@end

@implementation ZSSNetworkSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)configureViews {
    [self configureNavBar];
    [self configureTableView];
}

- (void)configureNavBar {
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor cloudsColor],
                                                                    NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:26.0]};
    [self configureNavBarTitle];
    [self configureNavBarButtons];
}

- (void)configureNavBarTitle {
    self.navigationItem.title = @"Pick Your Networks";
}

- (void)configureNavBarButtons {
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                     target:self
                                                                                     action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelBarButton;
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor cloudsColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:MESSAGE_CELL_CLASS bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allNetworkNames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSSNetworkSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    NSString *networkName = self.allNetworkNames[indexPath.row];
    cell.nameLabel.text = networkName;
    [cell.logoButton setBackgroundImage:[self getLogoForNetwork:networkName] forState:UIControlStateNormal];
    [self setBlocksForCell:cell forNetwork:networkName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)showPreviousView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage *)getLogoForNetwork:(NSString *)network {
    UIImage *logo;
    if ([network isEqualToString:@"Instagram"]) {
        logo = [UIImage imageNamed:@"instagram.png"];
    } else if ([network isEqualToString:@"Github"]) {
        logo = [UIImage imageNamed:@"github.png"];
    } else if ([network isEqualToString:@"Pinterest"]) {
        logo = [UIImage imageNamed:@"pinterest.png"];
    } else if ([network isEqualToString:@"Twitter"]) {
        logo = [UIImage imageNamed:@"twitter.png"];
    } else if ([network isEqualToString:@"Tumblr"]) {
        logo = [UIImage imageNamed:@"tumblr.png"];
    } else if ([network isEqualToString:@"Ebay"]) {
        logo = [UIImage imageNamed:@"ebay.png"];
    } else if ([network isEqualToString:@"Dribbble"]) {
        logo = [UIImage imageNamed:@"dribbble.png"];
    } else if ([network isEqualToString:@"Behance"]) {
        logo = [UIImage imageNamed:@"behance.png"];
    } else if ([network isEqualToString:@"Youtube"]) {
        logo = [UIImage imageNamed:@"youtube.png"];
    } else if ([network isEqualToString:@"GooglePlus"]) {
        logo = [UIImage imageNamed:@"googleplus.png"];
    } else if ([network isEqualToString:@"Reddit"]) {
        logo = [UIImage imageNamed:@"reddit.png"];
    } else if ([network isEqualToString:@"Imgur"]) {
        logo = [UIImage imageNamed:@"imgur.png"];
    } else if ([network isEqualToString:@"Wordpress"]) {
        logo = [UIImage imageNamed:@"wordpress.png"];
    } else if ([network isEqualToString:@"Gravatar"]) {
        logo = [UIImage imageNamed:@"gravatar.jpg"];
    } else if ([network isEqualToString:@"EtsyShop"]) {
        logo = [UIImage imageNamed:@"etsy.png"];
    } else if ([network isEqualToString:@"EtsyPeople"]) {
        logo = [UIImage imageNamed:@"etsy,png"];
    } else if ([network isEqualToString:@"AboutMe"]) {
        logo = [UIImage imageNamed:@"aboutme.png"];
    } else if ([network isEqualToString:@"KickAssTo"]) {
        logo = [UIImage imageNamed:@"kickasstorrents.png"];
    } else if ([network isEqualToString:@"ThePirateBay"]) {
        logo = [UIImage imageNamed:@"piratebay.png"];
    } else if ([network isEqualToString:@"Flickr"]) {
        logo = [UIImage imageNamed:@"flickr.png"];
    } else if ([network isEqualToString:@"DeviantArt"]) {
        logo = [UIImage imageNamed:@"deviantart.png"];
    } else if ([network isEqualToString:@"Twitch"]) {
        logo = [UIImage imageNamed:@"Twitch.png"];
    } else if ([network isEqualToString:@"Vimeo"]) {
        logo = [UIImage imageNamed:@"vimeo.png"];
    } else if ([network isEqualToString:@"LifeHacker"]) {
        logo = [UIImage imageNamed:@"lifehacker.png"];
    } else if ([network isEqualToString:@"WikiAnswer"]) {
        logo = [UIImage imageNamed:@"WikipediaW.png"];
    } else if ([network isEqualToString:@"SoundCloud"]) {
        logo = [UIImage imageNamed:@"soundcloud.png"];
    } else if ([network isEqualToString:@"IGN"]) {
        logo = [UIImage imageNamed:@"ign.jpg"];
    } else if ([network isEqualToString:@"OkCupid"]) {
        logo = [UIImage imageNamed:@"okcupid.png"];
    } else if ([network isEqualToString:@"TheVerge"]) {
        logo = [UIImage imageNamed:@"verge.png"];
    } else if ([network isEqualToString:@"KickStarter"]) {
        logo = [UIImage imageNamed:@"kickstarter.png"];
    } else if ([network isEqualToString:@"Spotify"]) {
        logo = [UIImage imageNamed:@"spotify.png"];
    }
    return logo;
}

- (void)setBlocksForCell:(ZSSNetworkSelectCell *)cell forNetwork:(NSString *)networkName {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _allNetworkNames = [[ZSSNetworkQuerier sharedQuerier] allNetworkNames];
    }
    return self;
}

@end
