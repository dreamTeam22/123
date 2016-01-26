//
//  ViewController.m
//  LoginAndUploadPhoto
//
//  Created by 张永治 on 16/1/25.
//  Copyright © 2016年 张永治. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPSessionManager.h"
#define  UserToken    [[NSUserDefaults standardUserDefaults] objectForKey:@"Token"]
#define  UserID       [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]
#define  UserIcon     [[NSUserDefaults standardUserDefaults] objectForKey:@"iconURL"]

#define  PICUPLOADURL           @"http://www.perdate.com:8002"
#define  UploadIconPath         @"/server/icon/upload2"
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//  加载图片
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:UserIcon]];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    加载图片
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:UserID]];
    
    
    self.view.backgroundColor = [UIColor greenColor];
    self.photoImageView.userInteractionEnabled = YES;
//    tap点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectMenu)];
    [self.photoImageView addGestureRecognizer:tap];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

//上拉菜单，选择相册和相机
- (void)selectMenu {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//            创建图片选择控制器
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
//            允许对选择的图片缩放剪切
            picker.allowsEditing = YES;
//            模态动画类型
            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//            设置代理
            picker.delegate = self;
            
            [self presentViewController:picker animated:YES completion:nil];
            
            
        }
        
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            
            picker.allowsEditing = YES;
            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
            
            
        }
        
        
        
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
    
    

}

#pragma mark 图片选择器的代理

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"***************info:%@",info);
//    获取剪切后的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//    self.photoImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    把图片转换成NSData
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
//    给图片命名
    NSString *imageName = @"201601261031.jpg";
    
//    图片上传服务器
//    创建会话管理对象
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:PICUPLOADURL]];
//    类型不匹配时做的处理
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    
//   设置 上传的参数
    NSDictionary *dicPara = [NSDictionary dictionaryWithObjectsAndKeys:UserID,@"userId",UserToken,@"token",[NSNumber numberWithInt:2],@"category", nil];
//    发起post/请求
   [manager POST:UploadIconPath parameters:dicPara constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//       AFMultipartFormData 文件上传协议，基于post方法，把文件封装在body中，但它不同于普通的post的key - value 数据格式，因为key = value 不能代表实体文件，它是分片的，边上传边拼接
//       参数：指定图片流，服务器端给的字段，文件名，文件类型
       [formData appendPartWithFileData:data name:@"icon" fileName:imageName mimeType:@"image/jpeg"];
       
   } success:^(NSURLSessionDataTask *task, id responseObject) {
       NSLog(@"response:%@",responseObject);
       BOOL status = [responseObject objectForKey:@"status"];
       if (status == 1) {
//           上传成功
//           获取从服务器端返回的头像地址，更新本地数据保存
           NSString *iconUrl = [responseObject objectForKey:@"data"];
           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
           [defaults setValue:iconUrl forKey:@"iconURL"];
//           同步更新
           [defaults synchronize];
           
//           加载网络图片
           [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl]];
           
       }
       else {
       
           NSLog(@"上传失败");
       
       }
       
       
   } failure:^(NSURLSessionDataTask *task, NSError *error) {
       NSLog(@"error:%@",error);
       
   }];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
