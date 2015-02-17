//
//  ZSSNetworkTableViewController.m
//  Get Short Usernames
//
//  Created by Zachary Shakked on 2/16/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//
#import "UIColor+Flat.h"
#import "ZSSNetworkTableViewController.h"
#import "ZSSNetworkTableViewCell.h"
#import "ZSSUsernameTableViewController.h"

static NSString *MESSAGE_CELL_CLASS = @"ZSSNetworkTableViewCell";
static NSString *CELL_IDENTIFIER = @"cell";

@interface ZSSNetworkTableViewController ()

@end

@implementation ZSSNetworkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];

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
    self.navigationItem.title = @"Pick A Network";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZSSUsernameTableViewController *utvc = [[ZSSUsernameTableViewController alloc] init];
    
    switch (indexPath.row) {
        case 0:
            utvc.networkName = @"Instagram";
            break;
        case 1:
            utvc.networkName = @"Github";
            break;
        case 2:
            utvc.networkName = @"Pinterest";
            break;
        case 3:
            utvc.networkName = @"Twitter";
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:utvc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSSNetworkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.networkLogoImageView.layer.masksToBounds = YES;
    cell.networkLogoImageView.layer.cornerRadius = 7.0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    switch (indexPath.row) {
        case 0:
            cell.networkLogoImageView.image = [UIImage imageNamed:@"instagram-logo.png"];
            break;
        case 1:
            cell.networkLogoImageView.image = [UIImage imageNamed:@"github-logo.png"];
            break;
        case 2:
            cell.networkLogoImageView.image = [UIImage imageNamed:@"pinterest-logo.png"];
            break;
        case 3:
            cell.networkLogoImageView.image = [UIImage imageNamed:@"twitter-logo.png"];
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86.0;
}




@end
