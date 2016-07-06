//
//  Index.m
//  天气预报
//
//  Created by Mr_Guo on 16/6/21.
//  Copyright © 2016年 Mr_Guo. All rights reserved.
//

#import "Index.h"

@implementation Index

+ (instancetype) indexWithDictionary:(NSDictionary *)dict {

    Index *ind = [Index new];
    
    [ind setValuesForKeysWithDictionary:dict];
    
    return ind;

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end
