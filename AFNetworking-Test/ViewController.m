//
//  ViewController.m
//  AFNetworking-Test
//
//  Created by WangQiao on 16/8/14.
//  Copyright © 2016年 WangQiao. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

/*
 // 1.....GET..... @"http://api.chuandazhiapp.com/v2/channels/5/items?limit=20&offset=0&gender=2&generation=1"; (这个是一个GET请求,只支持GET请求,不支持POST请求)
 
        NSString *url  =  @"http://api.chuandazhiapp.com/v2/channels/5/items?limit=20&offset=0&gender=2&generation=1"
         
或者: 可以上诉的网址拆分这样的额写法
         
         NSString *url  =  @"http://api.chuandazhiapp.com/v2/channels/5/items";
         NSDictionary *dic  = @{@"limit":@"20",@"offset":@"0",@"generation":@"1"};
 
 
 // 2.....POST.....  @"http://act.techcode.com/api/company/view" 参数列表:{id = 33340;} (这是一个POST请求的网址)也可以用GET请求

         NSString *url  =  @"http://act.techcode.com/api/company/view";
         NSDictionary *dic  = @{@"id" : @"33340"};
         
或者 :直接拼接
         NSString *url = @"http://act.techcode.com/api/company/view?id=33340";
 
 // 3..........
        NSString *url = @"http://apis.baidu.com/showapi_open_bus/showapi_joke/joke_text?page=1";
        这个网址只会请求超时(GET与POST都一样会请求超时)
 
 // 4.......... http://api.chunbo.com//CookbookHome/getTopicList  // json 数据  (参数)?page=1&pagesize=10
 
         NSString *url = @"http://api.chunbo.com//CookbookHome/getTopicList";
         NSDictionary *dic  = @{@"page" : @"1",@"pagesize":@"10"};
 
 或者 :
      NSString *url = @"http://api.chunbo.com//CookbookHome/getTopicList?page=1&pagesize=10"
 
 // 5......上传数据
  NSString *url = @"http://101.201.78.24/api/user/update"
  NSDictionary *dic = @{
                         @"auth_token":@"MTksNjA1MjQ=",
                         @"birthday":@"1991-02-21",
                         @"city":@"",
                         @"email":@"",
                         @"followActivityTypes":@"",
                         @"followScopes":@"18,14,10,6",
                         @"nickname":@"Lady-Wang",
                         @"realname":@"王同学"}

 
 */



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self GETRequest];
    
//    [self POSTRequest];
    
//    [self UploadRequest];
    

}

- (void)UploadRequest {
    
    NSLog(@"这是上传图片的请求");

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSString *url = @"http://101.201.78.24/api/user/update";
    NSDictionary *dic = @{
                          @"auth_token":@"MTksNjA1MjQ=",
                          @"birthday":@"1991-02-21",
                          @"city":@"",
                          @"email":@"",
                          @"followActivityTypes":@"",
                          @"followScopes":@"18,14,10,6",
                          @"nickname":@"Lady-Wang",
                          @"realname":@"王同学"};
    
    //2. 利用时间戳当做图片名字
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *imageName = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",imageName];
    
    //3. 图片二进制文件
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"17700521"], 1);
    NSLog(@"upload image size: %ld k", (long)(imageData.length / 1024));
    
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
         [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
    }progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    NSLog(@"%@", manager.requestSerializer.HTTPRequestHeaders);
}

- (void)POSTRequest {

    NSLog(@"这是POST请求");
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"application/json",@"text/plain" ]];

    NSString *url = @"http://api.chunbo.com//CookbookHome/getTopicList";
    NSDictionary *dic  = @{@"page" : @"1",@"pagesize":@"10"};
    /**
     *  网络请求的第二种方式:POST请求
     *
     *  @param task           任务类型
     *  @param responseObject responseObject
     *
     *  @return 返回请求的数据
     */
    
        [manager POST:url
           parameters:dic
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
                  NSLog(@"responseObject = %@",responseObject);
    
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
                  NSLog(@"error = %@",error);
       
              }];
    NSLog(@"%@", manager.requestSerializer.HTTPRequestHeaders);

}


- (void)GETRequest {
    
    NSLog(@"这是GET请求");

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"application/json",@"text/plain" ]];
    
    NSLog(@"默认的responseSerializer type  = %@",[manager.responseSerializer class]);
    NSLog(@"默认的requestSerializer type   = %@",[manager.requestSerializer  class]);
    
    // 数据返回序列化的HTTP类型 , 默认类型是JSON类型  所以有时不需要设置 (这么设置后就变成二进制数据流了)
    AFHTTPResponseSerializer *responseSerializer  = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer                    = responseSerializer;
    NSLog(@"更改后的responseSerializer type = %@",[responseSerializer class]);
    
    // 数据请求序列化的JSON类型 ,默认类型是HTTP类型 ,有时不需要设置
    AFJSONRequestSerializer *requestSerializer    = [AFJSONRequestSerializer serializer];
    manager.requestSerializer                     = requestSerializer;
    NSLog(@"更改后的requestSerializer type  = %@",[requestSerializer class]);
    NSLog(@"请求序列化===>%@",requestSerializer);
    
    /**
     *  数据请求的第一种方式:GET请求
     *
     *  @param task           任务类型 NSURLSessionDataTask
     *  @param responseObject responseObject
     *
     *  @return 返回请求的数据
     */
    
    NSString *url      = @"http://api.chunbo.com//CookbookHome/getTopicList";
    NSDictionary *dic  = @{@"page" : @"1",@"pagesize":@"10"};
    
    [manager GET:url
      parameters:dic
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"responseObject = %@  responseObject的type = %@",responseObject , [responseObject class]);
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             NSLog(@"error = %@",error);
         }];
    
    NSLog(@"%@", manager.requestSerializer.HTTPRequestHeaders);
}
@end
