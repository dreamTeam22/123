//
//  FoodSection.m
//  BTest
//
//  Created by lanouhn on 16/1/28.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import "FoodSection.h"

@implementation FoodSection

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;


}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {


}





@end
