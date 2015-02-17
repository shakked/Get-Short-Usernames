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
    }
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
