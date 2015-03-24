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
#import "UIImage+Logos.h"

static NSString *MESSAGE_CELL_CLASS = @"ZSSNetworkSelectCell";
static NSString *CELL_IDENTIFIER = @"cell";

@interface ZSSNetworkSettingsTableViewController ()

@property (nonatomic, strong) NSArray *allNetworkNames;
@property (nonatomic, strong) NSMutableArray *selectedNetworks;

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
    self.navigationController.navigationBar.barTintColor = [UIColor belizeHoleColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor cloudsColor],
                                                                    NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:22.0]};
    [self configureNavBarTitle];
    [self configureNavBarButtons];
}

- (void)configureNavBarTitle {
    self.navigationItem.title = @"Select";
}

- (void)configureNavBarButtons {
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                     target:self
                                                                                     action:@selector(cancel)];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                  target:self
                                                                                  action:@selector(done)];
    self.navigationItem.leftBarButtonItem = cancelBarButton;
    self.navigationItem.rightBarButtonItem = doneBarButton;
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSSNetworkSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    NSString *networkName = self.allNetworkNames[indexPath.row];
    cell.nameLabel.text = networkName;
    [cell.logoButton setImage:[UIImage logoForNetwork:networkName] forState:UIControlStateNormal];
    cell.logoButton.imageView.layer.masksToBounds = YES;
    cell.logoButton.imageView.layer.cornerRadius = 25.0;
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    if ([self.selectedNetworks containsObject:networkName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [self setBlocksForCell:cell forNetwork:networkName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSSNetworkSelectCell *cell = (ZSSNetworkSelectCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *selectedNetwork = self.allNetworkNames[indexPath.row];
    if ([self.selectedNetworks containsObject:selectedNetwork]) {
        [self.selectedNetworks removeObject:selectedNetwork];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [self.selectedNetworks addObject:selectedNetwork];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)showPreviousView {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setBlocksForCell:(ZSSNetworkSelectCell *)cell forNetwork:(NSString *)networkName {
    
}

- (void)done {
    for (NSString *networkName in self.selectedNetworks) {
        [[ZSSNetworkQuerier sharedQuerier] addNetwork:networkName];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _allNetworkNames = [[ZSSNetworkQuerier sharedQuerier] allNetworkNames];
        _selectedNetworks = [[ZSSNetworkQuerier sharedQuerier] selectedNetworks];
    }
    return self;
}

@end
