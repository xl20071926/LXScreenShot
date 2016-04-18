//
//  LXToolView.h
//  LXScreenShot
//
//  Created by Leexin on 16/4/18.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger,LXToolButtonType) {
    LXToolButtonTypeRect = 10,
    LXToolButtonTypeCircle,
    LXToolButtonTypeArrow,
    LXToolButtonTypePen,
    LXToolButtonTypeText,
    LXToolButtonTypeShare,
};

@class LXToolView;
@protocol LXToolViewDelegate <NSObject>

- (void)toolView:(LXToolView *)toolView didClickToolButton:(UIButton *)toolButton;

@end

@interface LXToolView : UIView

@property (nonatomic, weak) id<LXToolViewDelegate> delegate;

@end
