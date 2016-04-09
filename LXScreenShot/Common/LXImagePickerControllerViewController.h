//
//  LXImagePickerControllerViewController.h
//  LXScreenShot
//
//  Created by Leexin on 16/4/8.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//  自定义相机-身份证

#import <UIKit/UIKit.h>
#import "LXViewController.h"

static const CGFloat kOverlayViewTop = 60.f; // 蒙层上端高度
static const CGFloat kOverlayViewBroadsideWidth = 50.f; // 蒙层俩侧宽度
static const CGFloat kIdentifyScale = 1.585; // 身份证的比例是1.585

typedef NS_ENUM(NSInteger,LXCameraOverlayViewType) {
    LXCameraOverlayViewTypeDefault, // 系统默认类型
    LXCameraOverlayViewTypeIdentify, // 身份证类型
    LXCameraOverlayViewTypeSquare, // 正方形类型
};

@class LXImagePickerControllerViewController;
@protocol LXImagePickerControllerViewControllerDelegate <NSObject>

- (void)imagePickerControllerViewController:(LXImagePickerControllerViewController *)controller didFinishPickingImage:(UIImage *)image; // 完成
- (void)imagePickerControllerViewControllerDidCancel:(LXImagePickerControllerViewController *)controller; // 取消

@end

@interface LXImagePickerControllerViewController : LXViewController

@property (nonatomic, assign) LXCameraOverlayViewType cameraType; // 相机蒙层类型
@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType; // ImagePickerde 的类型
@property (nonatomic, weak) id<LXImagePickerControllerViewControllerDelegate> delegate;

- (instancetype)initWithController:(UIViewController *)control sourceType:(UIImagePickerControllerSourceType)sourceType cameraType:(LXCameraOverlayViewType)cameraType;
- (void)showCameraController; // 弹出相机

@end
