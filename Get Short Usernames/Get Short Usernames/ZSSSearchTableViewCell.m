//
//  ZSSSearchTableViewCell.m
//  Get Short Usernames
//
//  Created by Zachary Shakked on 2/17/15.
//  Copyright (c) 2015 Shkeek Inc. All rights reserved.
//

#import "ZSSSearchTableViewCell.h"

@implementation ZSSSearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)networkIconButtonPressed:(id)sender {
    self.infoButtonPressedBlock();
}
@end
