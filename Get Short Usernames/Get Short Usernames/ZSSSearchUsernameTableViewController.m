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


static NSString *MESSAGE_CELL_CLASS = @"ZSSSearchTableViewCell";
static NSString *CELL_IDENTIFIER = @"cell";

@interface ZSSSearchUsernameTableViewController () <UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *currentUsername;

@property (nonatomic) BOOL isInstagramAvailable;
@property (nonatomic) BOOL isGithubAvailable;
@property (nonatomic) BOOL isPinterestAvailable;
@property (nonatomic) BOOL isTwitterAvailable;
@property (nonatomic) BOOL isTumblrAvailable;

@end

@implementation ZSSSearchUsernameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor belizeHoleColor];
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
    self.navigationItem.title = @"Search a Username";
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.bounds = CGRectMake(0, 0, 33, 33);
    [backButton setBackgroundImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(showPreviousView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.searchBar;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44; // The height of the search bar
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSSSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    [self configureNetworksOfCell:cell forIndexPath:indexPath];
    cell.usernameLabel.text = self.currentUsername;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
    
}

- (void)configureNetworksOfCell:(ZSSSearchTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            cell.networkIconImageView.image = [UIImage imageNamed:@"instagram-icon.png"];
            if (self.isInstagramAvailable) {
                cell.checkImageView.image = [UIImage imageNamed:@"CheckmarkIcon"];
            } else {
                cell.checkImageView.image = [UIImage imageNamed:@"XIcon"];
            }
            break;
            
        case 1:
            cell.networkIconImageView.image = [UIImage imageNamed:@"github-icon.png"];
            if (self.isGithubAvailable) {
                cell.checkImageView.image = [UIImage imageNamed:@"CheckmarkIcon"];
            } else {
                cell.checkImageView.image = [UIImage imageNamed:@"XIcon"];
            }
            break;
            
        case 2:
            cell.networkIconImageView.image = [UIImage imageNamed:@"pinterest-icon.png"];
            if (self.isPinterestAvailable) {
                cell.checkImageView.image = [UIImage imageNamed:@"CheckmarkIcon"];
            } else {
                cell.checkImageView.image = [UIImage imageNamed:@"XIcon"];
            }
            break;
        
        case 3:
            cell.networkIconImageView.image = [UIImage imageNamed:@"twitter-icon.png"];
            if (self.isTwitterAvailable) {
                cell.checkImageView.image = [UIImage imageNamed:@"CheckmarkIcon"];
            } else {
                cell.checkImageView.image = [UIImage imageNamed:@"XIcon"];
            }
            break;
            
        case 4:
            cell.networkIconImageView.image = [UIImage imageNamed:@"tumblr-icon.png"];
            if (self.isTumblrAvailable) {
                cell.checkImageView.image = [UIImage imageNamed:@"CheckmarkIcon"];
            } else {
                cell.checkImageView.image = [UIImage imageNamed:@"XIcon"];
            }
            break;
            
        default:
            break;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self resetNetworkBools];
    
    self.currentUsername = searchText;
    [self.tableView reloadData];
    [self.searchBar becomeFirstResponder];
    
    [self startSearching:searchText];
}

- (void)startSearching:(NSString *)searchText {
    [[ZSSCloudQuerier sharedQuerier] checkInstagramForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
        if (available) {
            self.isInstagramAvailable = YES;
        }
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }];
    
    [[ZSSCloudQuerier sharedQuerier] checkGithubForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
        if (available) {
            self.isGithubAvailable = YES;
        }
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }];
    
    [[ZSSCloudQuerier sharedQuerier] checkPinterestForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
        if (available) {
            self.isPinterestAvailable = YES;
        }
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }];
    
    [[ZSSCloudQuerier sharedQuerier] checkTwitterForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
        if (available) {
            self.isTwitterAvailable = YES;
        }
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }];
    
    [[ZSSCloudQuerier sharedQuerier] checkTumblrForUsername:searchText withCompletion:^(BOOL available, NSError *error) {
        if (available) {
            self.isTumblrAvailable = YES;
        }
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }];
}

- (void)resetNetworkBools {
    self.isInstagramAvailable = NO;
    self.isGithubAvailable = NO;
    self.isPinterestAvailable = NO;
    self.isTwitterAvailable = NO;
    self.isTumblrAvailable = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (void)showPreviousView {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
