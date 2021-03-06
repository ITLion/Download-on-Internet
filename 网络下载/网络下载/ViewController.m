//
//  ViewController.m
//  网络下载
//
//  Created by 赵世得 on 16/9/18.
//  Copyright © 2016年 Zh_IOS. All rights reserved.
//

//https://raw.githubusercontent.com/ITLion/Download-on-Internet/c99272bf178bb386e84310636e92c13010dfbfc0/apps.json




#import "ViewController.h"
#import "AFNetworking.h"
#import "AppDataModel.h"
#import "YYModel.h"
#import "APPCell.h"
#import "NSString+Path.h"

@interface ViewController ()<UITableViewDataSource>

@property (nonatomic, strong) NSArray *array;

//队列
@property (nonatomic, strong) NSOperationQueue *queue;

//图片缓存池
@property (nonatomic, strong) NSMutableDictionary *pictureCache;

//操作缓存池
@property (nonatomic, strong) NSMutableDictionary *opCache;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.array = [NSArray array];
    self.queue = [[NSOperationQueue alloc] init];
    self.pictureCache = [[NSMutableDictionary alloc] init];
    self.opCache = [[NSMutableDictionary alloc] init];
    [self loadJsonData];
}


- (void)loadJsonData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://raw.githubusercontent.com/ITLion/Download-on-Internet/c99272bf178bb386e84310636e92c13010dfbfc0/apps.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.array = [NSArray yy_modelArrayWithClass:[AppDataModel class] json:responseObject];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    APPCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    AppDataModel *model = self.array[indexPath.row];
    cell.nameLabel.text = model.name;
    cell.downloadLable.text = model.download;
//    cell.iconImageView.image = [UIImage imageNamed:model.icon];
    cell.iconImageView.image = [UIImage imageNamed:@"user_default"];
    
    if ([self.pictureCache objectForKey:model.icon]) {
        cell.iconImageView.image = [self.pictureCache objectForKey:model.icon];
        return cell;
    }
    
    UIImage *cacheImage = [UIImage imageWithContentsOfFile:[model.icon appendCache]];
    if (cacheImage) {
        [self.pictureCache setObject:cacheImage forKey:model.icon];
        cell.iconImageView.image = cacheImage;
        return cell;
    }
    
    if ([self.opCache objectForKey:model.icon]) {
        return cell;
    }
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        
        NSURL *url = [NSURL URLWithString:model.icon];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        if (image) {
            [data writeToFile:[model.icon appendCache] atomically:YES];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (image != nil) {
                [self.pictureCache setObject:image forKey:model.icon];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            [self.opCache removeObjectForKey:model.icon];
        }];
    }];
    [self.opCache setObject:op forKey:model.icon];
    [self.queue addOperation:op];
    
    
    // 获取
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.pictureCache removeAllObjects];
    [self.opCache removeAllObjects];
    [self.queue cancelAllOperations];
}

@end
