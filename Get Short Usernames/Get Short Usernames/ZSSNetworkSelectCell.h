//
//  ZSSNetworkSelectCell.h
//  Usernames
//
//  Created by Zachary Shakked on 3/23/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSSNetworkSelectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoButton;
@property (nonatomic, strong) void (^logoButtonPressedBlock)(void);

@end
