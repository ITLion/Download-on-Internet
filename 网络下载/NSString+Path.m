//
//  NSString+Path.m
//  网络下载
//
//  Created by 赵世得 on 16/9/18.
//  Copyright © 2016年 Zh_IOS. All rights reserved.
//

#import "NSString+Path.h"

@implementation NSString (Path)

- (NSString *)appendCache{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *name = [self lastPathComponent];
    NSString *filePath = [path stringByAppendingPathComponent:name];
    return filePath;
}




@end
