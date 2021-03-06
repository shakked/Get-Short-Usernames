//
//  ZSSSearchTableViewCell.h
//  Get Short Usernames
//
//  Created by Zachary Shakked on 2/17/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSSSearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (nonatomic, strong) void (^infoButtonPressedBlock)(void);
@property (weak, nonatomic) IBOutlet UIButton *logoButton;


@end
