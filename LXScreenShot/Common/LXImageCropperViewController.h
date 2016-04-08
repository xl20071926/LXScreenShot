//
//  NWFImageCropperViewController.h
//  LXScreenShot
//
//  Created by Leexin on 16/4/8.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//  图片剪切-身份证

#import "LXViewController.h"

@interface LXImageCropperViewController : LXViewController

@property (nonatomic, copy) void (^completionHandler)(UIImage *image); // 完成/取消block,取消传nil

- (id)initWithOriginalImage:(UIImage *)image;

@end
