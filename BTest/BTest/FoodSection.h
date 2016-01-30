//
//  FoodSection.h
//  BTest
//
//  Created by lanouhn on 16/1/28.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodSection : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSInteger *id;

- (id)initWithDic:(NSDictionary *)dic;


@end
