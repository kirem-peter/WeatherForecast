//
//  ZCell.m
//  天气预报
//
//  Created by Mr_Guo on 16/6/23.
//  Copyright © 2016年 Mr_Guo. All rights reserved.
//

#import "ZCell.h"

@interface ZCell ()

@property (weak, nonatomic) IBOutlet UILabel *tipt;
@property (weak, nonatomic) IBOutlet UILabel *zs;
@property (weak, nonatomic) IBOutlet UILabel *des;

@end

@implementation ZCell

-(void)setIdx:(Index *)idx {

    _idx = idx;
    self.tipt.text = idx.tipt;
    self.zs.text = idx.zs;
    self.des.text = idx.des;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
