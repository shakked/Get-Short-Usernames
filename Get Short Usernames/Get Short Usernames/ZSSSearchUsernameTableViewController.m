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


static NSString *MESSAGE_CELL_CLASS = @"ZSSSearchTableViewCell";
static NSString *CELL_IDENTIFIER = @"cell";

@interface ZSSSearchUsernameTableViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *currentUsername;

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
    self.navigationItem.title = @"Search a Username";
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
            break;
            
        case 1:
            cell.networkIconImageView.image = [UIImage imageNamed:@"github-icon.png"];
            break;
            
        case 2:
            cell.networkIconImageView.image = [UIImage imageNamed:@"pinterest-icon.png"];
            break;
        
        case 3:
            cell.networkIconImageView.image = [UIImage imageNamed:@"twitter-icon.png"];
            break;
            
        case 4:
            cell.networkIconImageView.image = [UIImage imageNamed:@"tumblr-icon.png"];
            break;
            
        default:
            break;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.currentUsername = searchText;
    [self.tableView reloadData];
    [self.searchBar becomeFirstResponder];
}


@end
