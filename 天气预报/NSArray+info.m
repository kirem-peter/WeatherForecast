//
//  NSArray+info.m
//  模仿每日头条
//
//  Created by Mr_Guo on 16/5/31.
//  Copyright © 2016年 Mr_Guo. All rights reserved.
//

#import "NSArray+info.h"

@implementation NSArray (info)

-(NSString *)descriptionWithLocale:(id)locale {

    NSMutableString *str = [NSMutableString stringWithFormat:@"\n\t{"];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [str appendFormat:@"\t%@\n", obj];
        
    }];
    [str appendFormat:@"\t}"];
    return str;

}

@end

@implementation NSDictionary (info)

-(NSString *)descriptionWithLocale:(id)locale {
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"\n\t{"];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    
        [str appendFormat:@"\t%@\n", obj];
        
    }];
    [str appendFormat:@"\t}"];
    return str;
    
}

@end
