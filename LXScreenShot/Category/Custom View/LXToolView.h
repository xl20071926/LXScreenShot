//
//  LXToolView.h
//  LXScreenShot
//
//  Created by Leexin on 16/4/18.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//  

#import <UIKit/UIKit.h>
#import "LXToolPopView.h"

typedef NS_ENUM (NSInteger,LXToolButtonType) {
    LXToolButtonTypeRect = 10, // 矩形
    LXToolButtonTypeCircle, // 圆形
    LXToolButtonTypeArrow, // 箭头
    LXToolButtonTypePen, // 手写
    LXToolButtonTypeText, // 文字
    LXToolButtonTypeShare, // 分享
};

@class LXToolView;
@protocol LXToolViewDelegate <NSObject>

// 选择工具类型
- (void)toolView:(LXToolView *)toolView didClickToolButton:(UIButton *)toolButton;
// 选择线宽
- (void)toolView:(LXToolView *)toolView didSelectLineWith:(ToolPopViewLineWidthType)type;
// 选择颜色
- (void)toolView:(LXToolView *)toolView didSelectColor:(UIColor *)color;

@end

@interface LXToolView : UIView

@property (nonatomic, weak) id<LXToolViewDelegate> delegate;

@end
