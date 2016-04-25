//
//  LXDrawImageView.h
//  LXScreenShot
//
//  Created by Leexin on 16/4/19.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//  可绘图的UIImage

#import <UIKit/UIKit.h>
#import "LXToolView.h"

@interface LXDrawImageView : UIImageView

@property (nonatomic, retain) UIImage *originImage;
@property (nonatomic, assign) CGFloat zoomScale;
@property (nonatomic, assign) LXToolButtonType type;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) CGRect canDrawRect; // 可绘图区域(相对于Window的Rect)

@end
