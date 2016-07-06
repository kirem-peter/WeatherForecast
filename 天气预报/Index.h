//
//  Index.h
//  天气预报
//
//  Created by Mr_Guo on 16/6/21.
//  Copyright © 2016年 Mr_Guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Index : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *zs;
@property (nonatomic, copy) NSString *tipt;
@property (nonatomic, copy) NSString *des;

+ (instancetype) indexWithDictionary:(NSDictionary *)dict;

@end
