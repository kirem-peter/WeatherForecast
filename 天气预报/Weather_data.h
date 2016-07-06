//
//  Weather_data.h
//  天气预报
//
//  Created by Mr_Guo on 16/6/21.
//  Copyright © 2016年 Mr_Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather_data : NSObject

//"date":"周二 06月21日 (实时：34℃)",
//"dayPictureUrl":"http://api.map.baidu.com/images/weather/day/leizhenyu.png",
//"nightPictureUrl":"http://api.map.baidu.com/images/weather/night/leizhenyu.png",
//"weather":"雷阵雨",
//"wind":"微风",
//"temperature":"34 ~ 23℃"
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *dayPictureUrl;
@property (nonatomic, copy) NSString *nightPictureUrl;
@property (nonatomic, copy) NSString *weather;
@property (nonatomic, copy) NSString *wind;
@property (nonatomic, copy) NSString *temperature;

+ (instancetype) weather_dataWithDictionary:(NSDictionary *)dict;

@end
