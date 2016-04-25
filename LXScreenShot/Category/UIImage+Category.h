//
//  UIImage+Category.h
//  LXScreenShot
//
//  Created by Leexin on 16/4/8.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

//根据颜色生成指定大小的图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
