//
//  LXImageCropperViewController.h
//  LXScreenShot
//
//  Created by Leexin on 16/4/8.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//  图片剪切-身份证

#import "LXViewController.h"

@interface LXImageCropperViewController : LXViewController

@property (nonatomic, copy) void (^completionHandler)(UIImage *image);
@property (nonatomic, retain) UIImageView *imageView;

- (id)initWithOriginalImage:(UIImage *)image cropWidth:(float)width cropHeight:(float)vheight;

@end
