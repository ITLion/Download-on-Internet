//
//  APPCell.h
//  网络下载
//
//  Created by 赵世得 on 16/9/18.
//  Copyright © 2016年 Zh_IOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadLable;

@end
