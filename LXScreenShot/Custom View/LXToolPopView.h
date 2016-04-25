//
//  LXToolPopView.h
//  LXScreenShot
//
//  Created by Leexin on 16/4/22.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//  弹出的选择类

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PopViewSizeButtonTag) {
    PopViewSizeButtonTagSmall = 666,
    PopViewSizeButtonTagMid,
    PopViewSizeButtonTagBig,
};

@class LXToolPopView;
@protocol LXToolPopViewDelegate <NSObject>

- (void)toolPopView:(LXToolPopView *)popView clickedSizeButtonType:(PopViewSizeButtonTag)type;
- (void)toolPopView:(LXToolPopView *)popView clickedColorButtonWithColor:(UIColor *)color;

@end

@interface LXToolPopView : UIView

@property (nonatomic, weak) id<LXToolPopViewDelegate> delegate;

- (void)showPopViewWithArrowPoint:(CGPoint)point; // 弹出 point:箭头所在的位置
- (void)hidePopView; // 隐藏

@end
