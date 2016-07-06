//
//  WCell.m
//  天气预报
//
//  Created by Mr_Guo on 16/6/23.
//  Copyright © 2016年 Mr_Guo. All rights reserved.
//

#import "WCell.h"
#import <UIImageView+AFNetworking.h>

@interface WCell()
//@property (nonatomic, copy) NSString *date;
//@property (nonatomic, copy) NSString *dayPictureUrl;
//@property (nonatomic, copy) NSString *nightPictureUrl;
//@property (nonatomic, copy) NSString *weather;
//@property (nonatomic, copy) NSString *wind;
//@property (nonatomic, copy) NSString *temperature;

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *weather;
@property (weak, nonatomic) IBOutlet UILabel *wind;
@property (weak, nonatomic) IBOutlet UILabel *temp;

@end

@implementation WCell

-(void)setWd:(Weather_data *)wd {

    _wd = wd;
    self.date.text = wd.date;
    [self.img setImageWithURL:[NSURL URLWithString:wd.dayPictureUrl]];
    self.weather.text = wd.weather;
    self.wind.text = wd.wind;
    self.temp.text = wd.temperature;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
