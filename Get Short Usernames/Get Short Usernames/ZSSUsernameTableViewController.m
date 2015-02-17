//
//  ZSSUsernameTableViewController.m
//  Get Short Usernames
//
//  Created by Zachary Shakked on 2/16/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import "UIColor+Flat.h"
#import "ZSSUsernameTableViewController.h"

static NSString *MESSAGE_CELL_CLASS = @"ZSSUsernameTableViewCell";
static NSString *CELL_IDENTIFIER = @"cell";

@interface ZSSUsernameTableViewController ()

@end

@implementation ZSSUsernameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
    
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
    self.navigationItem.title = self.networkName;
    
    if ([self.networkName isEqual:@"Instagram"]) {
        self.navigationController.navigationBar.barTintColor = [UIColor instagramColor];
    } else if ([self.networkName isEqual:@"Github"]) {
        self.navigationController.navigationBar.barTintColor = [UIColor githubColor];
    } else if ([self.networkName isEqual:@"Pinterest"]) {
        self.navigationController.navigationBar.barTintColor = [UIColor pinterestColor];
    } else if ([self.networkName isEqual:@"Twitter"]) {
        self.navigationController.navigationBar.barTintColor = [UIColor twitterColor];
    } else if ([self.networkName isEqual:@"Tumblr"]) {
        self.navigationController.navigationBar.barTintColor = [UIColor tumblrColor];
    }
}

- (void)configureNavBarButtons {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

- (void)showPreviousView {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
