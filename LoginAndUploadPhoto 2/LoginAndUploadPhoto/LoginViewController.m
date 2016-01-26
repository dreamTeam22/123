//
//  LoginViewController.m
//  LoginAndRegisterDemo
//
//  Created by 张永治 on 15/11/4.
//  Copyright (c) 2015年 张永治. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPSessionManager.h"
#define  PERDATEURL             @"http://www.perdate.com"
#define  LoginPath              @"/client/open/login"
@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *userNameTF;

@property (strong, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)LoginAction:(id)sender
{
    //提醒用户输入用户名
    if (self.userNameTF.text.length == 0) {
        
        [self alertWithMessage:@"请输入用户名"];
    }
    //提醒用户输入密码
    else if (self.passwordTF.text.length == 0)
    {
        [self alertWithMessage:@"请输入密码"];
    }
    //用户名和密码都已输入
    else
    {
        //获取当前版本号
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        float appVersion = [[infoDic objectForKey:@"CFBundleVersion"] floatValue];
        //封装参数
        NSDictionary *dicPara = [NSDictionary dictionaryWithObjectsAndKeys:self.userNameTF.text,@"name",self.passwordTF.text,@"password",[NSNumber numberWithInt:2],@"category",[NSNumber numberWithFloat:appVersion],@"version", nil];
        //创建任务管理
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:PERDATEURL]];
        //发起post请求
        [manager POST:LoginPath parameters:dicPara success:^(NSURLSessionDataTask *task, id responseObject) {
            
            //请求成功处理
            [self handelSuccess:responseObject];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSLog(@"login error:%@",error);
            [self alertWithMessage:@"网络错误"];
        }];
    
    }

}

-(void)alertWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    [alertView show];
}

-(void)handelSuccess:(id)responseObject
{
    NSDictionary *dic = responseObject;
    NSLog(@"dic:%@",dic);
    //强制更新
//    if ([[dic objectForKey:@"upgrade"] intValue]==1) {
//
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"New version, Download now!", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
//        alert.tag = 300;
//        [alert show];
//    }
//    else
    if ([[dic objectForKey:@"upgrade"] intValue]== 1)//最新版本方可登录
    {
        //判断是否登录成功
        if ([[dic objectForKey:@"status"] intValue]==1) {
            
            //保存用户登录成功的相关信息
            [self saveUserInfo:dic];
            
            //登录成功，切换界面
            //[self performSelector:@selector(RegisterAction)];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        else
        {
            [self alertWithMessage:@"登录失败,用户名或密码错误"];
        }
    }
    
}


-(void)saveUserInfo:(NSDictionary *)dic
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[dic objectForKey:@"token"] forKey:@"Token"];
    [defaults setObject:self.userNameTF.text forKey:@"name"];
    [defaults setObject:self.passwordTF.text forKey:@"password"];
    [defaults setObject:[dic objectForKey:@"id"] forKey:@"userID"];
    [defaults setObject:[dic objectForKey:@"icon"] forKey:@"iconURL"];
    [defaults setObject:[NSNumber numberWithInt:[[dic objectForKey:@"gender"] intValue]] forKey:@"gender"];
    [defaults setObject:[NSNumber numberWithInt:[[dic objectForKey:@"membership"] intValue]] forKey:@"level"];
    [defaults setObject:[NSNumber numberWithFloat:[[dic objectForKey:@"gold"] intValue]] forKey:@"money"];
    [defaults setBool:YES forKey:@"isLogin"];
    
    [defaults synchronize];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
