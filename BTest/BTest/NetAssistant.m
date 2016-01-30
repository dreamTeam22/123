//
//  NetAssistant.m
//  BTest
//
//  Created by lanouhn on 16/1/28.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import "NetAssistant.h"

@implementation NetAssistant

- (void)getWithRrquest:(NSURLRequest *)request Success:(Success)success {
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configure];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        success(response,responseObject,error);
        
    }];
    [task resume];

}


@end
