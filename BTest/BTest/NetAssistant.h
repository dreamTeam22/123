//
//  NetAssistant.h
//  BTest
//
//  Created by lanouhn on 16/1/28.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^Success) (NSURLResponse *response , id responseObject,NSError *error);
@interface NetAssistant : NSObject

- (void)getWithRrquest:(NSURLRequest *)request Success:(Success)success;


@end
