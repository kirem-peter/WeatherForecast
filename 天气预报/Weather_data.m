//
//  Weather_data.m
//  天气预报
//
//  Created by Mr_Guo on 16/6/21.
//  Copyright © 2016年 Mr_Guo. All rights reserved.
//

#import "Weather_data.h"

@implementation Weather_data

+ (instancetype) weather_dataWithDictionary:(NSDictionary *)dict {

    Weather_data *wd = [Weather_data new];
    
    [wd setValuesForKeysWithDictionary:dict];
    
    return wd;

}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end
