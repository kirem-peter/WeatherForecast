//
//  Waether.h
//  天气预报
//
//  Created by Mr_Guo on 16/6/15.
//  Copyright © 2016年 Mr_Guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Waether : NSObject

@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *pm25;
@property (nonatomic, strong) NSArray *indexs;
@property (nonatomic, strong) NSArray *weather_datas;

+ (instancetype) weatherWithDict:(NSDictionary *)dict;

+ (void) loadWeatherWithCity:(CLLocation *)loca WithSuccessBlock:(void(^)(Waether *))successBlock andErrorBlock:(void(^)(NSError *))errorBlock ;

@end
