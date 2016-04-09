//
//  LXImagePickerControllerViewController.m
//  LXScreenShot
//
//  Created by Leexin on 16/4/8.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import "LXImagePickerControllerViewController.h"
#import "LXImageCropperViewController.h"

static const CGFloat kOverlayViewSpace = 10.f;
static const CGFloat kAreaImageViewSize = 35.f;
static const CGFloat kAreaImageViewSpace = 5.f;

@interface LXCameraOverlayView : UIView

@property (nonatomic, weak) UIImagePickerController *imagePickerController;

// 半透明蒙层
@property (nonatomic, strong) UIView *topMaskView;
@property (nonatomic, strong) UIView *bottomMaskView;
@property (nonatomic, strong) UIView *leftMaskView;
@property (nonatomic, strong) UIView *rightMaskView;
// 四角光标icon
@property (nonatomic, strong) UIImageView *areaImageViewTopLeft;
@property (nonatomic, strong) UIImageView *areaImageViewTopRight;
@property (nonatomic, strong) UIImageView *areaImageViewBottomLeft;
@property (nonatomic, strong) UIImageView *areaImageViewBottomRight;

@property (nonatomic, strong) UIButton *flashButton; // 闪光按钮
@property (nonatomic, strong) UIButton *deviceButton; // 切换前置摄像头按钮
@property (nonatomic, strong) UIButton *cancelButton; // 取消按钮
@property (nonatomic, strong) UIButton *takePhotoButton; // 拍照按钮

@end

@implementation LXCameraOverlayView

#pragma mark - Life Cycle

- (instancetype)initWithOverlayViewType:(LXCameraOverlayViewType)type {
    
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initMaskViewWithType:type];
    }
    return self;
}

- (void)initMaskViewWithType:(LXCameraOverlayViewType)type {
    
    if (LXCameraOverlayViewTypeIdentify == type) { // 身份证
        CGFloat frameHeight = (SCREEN_WIDTH - 2 * kOverlayViewBroadsideWidth) * kIdentifyScale; // 框的高度
        CGFloat bottomHeight = SCREEN_HEIGHT - kOverlayViewTop - frameHeight;
        self.topMaskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kOverlayViewTop);
        [self addSubview:self.topMaskView];
        self.bottomMaskView.frame = CGRectMake(0, SCREEN_HEIGHT - bottomHeight, SCREEN_WIDTH, bottomHeight);
        [self addSubview:self.bottomMaskView];
        self.leftMaskView.frame = CGRectMake(0, kOverlayViewTop, kOverlayViewBroadsideWidth, frameHeight);
        [self addSubview:self.leftMaskView];
        self.rightMaskView.frame = CGRectMake(SCREEN_WIDTH - kOverlayViewBroadsideWidth, self.leftMaskView.top, self.leftMaskView.width, self.leftMaskView.height);
        [self addSubview:self.rightMaskView];
        
        self.areaImageViewTopLeft.frame = CGRectMake(self.leftMaskView.right + kAreaImageViewSpace, self.topMaskView.bottom + kAreaImageViewSpace, kAreaImageViewSize, kAreaImageViewSize);
        self.areaImageViewTopLeft.transform = CGAffineTransformMakeRotation(270.0/180.0*M_PI);
        [self addSubview:self.areaImageViewTopLeft];
        self.areaImageViewTopRight.frame = CGRectMake(self.rightMaskView.left - kAreaImageViewSize - kAreaImageViewSpace, self.areaImageViewTopLeft.top, kAreaImageViewSize, kAreaImageViewSize);
        [self addSubview:self.areaImageViewTopRight];
        self.areaImageViewBottomLeft.frame = CGRectMake(self.areaImageViewTopLeft.left, self.bottomMaskView.top - kAreaImageViewSize - kAreaImageViewSpace, kAreaImageViewSize, kAreaImageViewSize);
        self.areaImageViewBottomLeft.transform = CGAffineTransformMakeRotation(180.0/180.0*M_PI);
        [self addSubview:self.areaImageViewBottomLeft];
        self.areaImageViewBottomRight.frame = CGRectMake(self.areaImageViewTopRight.left, self.areaImageViewBottomLeft.top, kAreaImageViewSize, kAreaImageViewSize);
        self.areaImageViewBottomRight.transform = CGAffineTransformMakeRotation(90.0/180.0*M_PI);
        [self addSubview:self.areaImageViewBottomRight];
        
    } else { // 正方形
        self.topMaskView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT - SCREEN_WIDTH) / 2);
        [self addSubview:self.topMaskView];
        self.bottomMaskView.frame = CGRectMake(0, SCREEN_HEIGHT - self.topMaskView.height, SCREEN_WIDTH, self.topMaskView.height);
        [self addSubview:self.bottomMaskView];
    }
    
    self.flashButton.frame = CGRectMake(kOverlayViewSpace, kOverlayViewSpace, 30.f, 30.f);
    [self.topMaskView addSubview:self.flashButton];
    self.deviceButton.frame = CGRectMake(SCREEN_WIDTH - 30.f - kOverlayViewSpace, kOverlayViewSpace, 30.f, 30.f);
    [self.topMaskView addSubview:self.deviceButton];
    
    self.cancelButton.frame = CGRectMake(kOverlayViewSpace, (self.bottomMaskView.height - 30.f) / 2, 60.f, 30.f);
    [self.bottomMaskView addSubview:self.cancelButton];
    self.takePhotoButton.frame = CGRectMake((SCREEN_WIDTH - 60.f) / 2, (self.bottomMaskView.height - 60.f) / 2, 60.f, 60.f);
    [self.bottomMaskView addSubview:self.takePhotoButton];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.flashButton.selected = NO;
    self.deviceButton.selected = NO;
}

#pragma mark - Event Response

- (void)onFlashButtonClick {
    
    self.flashButton.selected = !self.flashButton.selected;
    if (self.flashButton.selected) {
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    } else {
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
}

- (void)onDeviceButtonClick {
    
    self.deviceButton.selected = !self.deviceButton.selected;
    if (self.deviceButton.selected) {
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else {
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

- (void)onCancelButtonClick {

     [self.imagePickerController dismissViewControllerAnimated:YES completion:^{
     }];
}

- (void)onTakePhotoButtonClick {
    [self.imagePickerController takePicture];
}

#pragma mark - Getters

- (UIButton *)flashButton {
    
    if (!_flashButton) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashButton setImage:[UIImage imageNamed:@"Photo_flash_icon"] forState:UIControlStateNormal];
        [_flashButton setImage:[UIImage imageNamed:@"Photo_flash_press_icon"] forState:UIControlStateHighlighted];
        [_flashButton setImage:[UIImage imageNamed:@"Photo_flash_press_icon"] forState:UIControlStateSelected];
        [_flashButton addTarget:self action:@selector(onFlashButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashButton;
}

- (UIButton *)deviceButton {
    
    if (!_deviceButton) {
        _deviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deviceButton setImage:[UIImage imageNamed:@"Reversion_icon"] forState:UIControlStateNormal];
        [_deviceButton setImage:[UIImage imageNamed:@"Reversion_press_icon"] forState:UIControlStateHighlighted];
        [_deviceButton setImage:[UIImage imageNamed:@"Reversion_press_icon"] forState:UIControlStateSelected];
        [_deviceButton addTarget:self action:@selector(onDeviceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deviceButton;
}

- (UIButton *)cancelButton {
    
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTintColor:[UIColor whiteColor]];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_cancelButton addTarget:self action:@selector(onCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)takePhotoButton {
    
    if (!_takePhotoButton) {
        _takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takePhotoButton setImage:[UIImage imageNamed:@"Camera_button_icon"] forState:UIControlStateNormal];
        [_takePhotoButton setImage:[UIImage imageNamed:@"Camera_button_press_icon"] forState:UIControlStateHighlighted];
        [_takePhotoButton addTarget:self action:@selector(onTakePhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhotoButton;
}

- (UIView *)topMaskView {
    
    if (!_topMaskView) {
        _topMaskView = [[UIView alloc] init];
        _topMaskView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    }
    return _topMaskView;
}

- (UIView *)bottomMaskView {
    
    if (!_bottomMaskView) {
        _bottomMaskView = [[UIView alloc] init];
        _bottomMaskView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    }
    return _bottomMaskView;
}

- (UIView *)leftMaskView {
    
    if (!_leftMaskView) {
        _leftMaskView = [[UIView alloc] init];
        _leftMaskView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    }
    return _leftMaskView;
}

- (UIView *)rightMaskView {
    
    if (!_rightMaskView) {
        _rightMaskView = [[UIView alloc] init];
        _rightMaskView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    }
    return _rightMaskView;
}

- (UIImageView *)areaImageViewTopLeft {
    
    if (!_areaImageViewTopLeft) {
        _areaImageViewTopLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Camera_area_icon"]];
    }
    return _areaImageViewTopLeft;
}

- (UIImageView *)areaImageViewTopRight {
    
    if (!_areaImageViewTopRight) {
        _areaImageViewTopRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Camera_area_icon"]];
    }
    return _areaImageViewTopRight;
}

- (UIImageView *)areaImageViewBottomLeft {
    
    if (!_areaImageViewBottomLeft) {
        _areaImageViewBottomLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Camera_area_icon"]];
    }
    return _areaImageViewBottomLeft;
}

- (UIImageView *)areaImageViewBottomRight {
    
    if (!_areaImageViewBottomRight) {
        _areaImageViewBottomRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Camera_area_icon"]];
    }
    return _areaImageViewBottomRight;
}

@end


@interface LXImagePickerControllerViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *pickerController;
@property (nonatomic, weak) UIViewController *presentViewController;

@end

@implementation LXImagePickerControllerViewController

#pragma mark - Life Cycle

- (instancetype)initWithController:(UIViewController *)control sourceType:(UIImagePickerControllerSourceType)sourceType cameraType:(LXCameraOverlayViewType)cameraType {
    
    self = [super init];
    if (self) {
        self.sourceType = sourceType;
        self.cameraType = cameraType;
        self.pickerController = [[UIImagePickerController alloc] init];
        self.pickerController.delegate = self;
        self.pickerController.sourceType = self.sourceType;
        self.presentViewController = control;
    }
    return self;
}

#pragma mark - Public Method

- (void)showCameraController {
    
    if (UIImagePickerControllerSourceTypeCamera == self.pickerController.sourceType) {
        if (self.cameraType) {
            LXCameraOverlayView *overlayView = [[LXCameraOverlayView alloc] initWithOverlayViewType:self.cameraType];
            overlayView.imagePickerController = self.pickerController;
            self.pickerController.cameraOverlayView = overlayView;
            self.pickerController.showsCameraControls = NO;
        }
    }
    [self.presentViewController presentViewController:self.pickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self dismissViewControllerAnimated:NO completion:^{
    }];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    LXImageCropperViewController *imageCropperViewController = [[LXImageCropperViewController alloc] initWithOriginalImage:image];
    [self presentViewController:imageCropperViewController animated:YES completion:nil];
    
    __weak typeof(self)weakSelf = self;
    imageCropperViewController.completionHandler = ^(UIImage *image) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (image) {
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
            if ([strongSelf.delegate respondsToSelector:@selector(imagePickerControllerViewController:didFinishPickingImage:)]) {
                [strongSelf.delegate imagePickerControllerViewController:strongSelf didFinishPickingImage:image];
            }
        } else {
            [strongSelf dismissViewControllerAnimated:NO completion:^{
                [strongSelf presentViewController:strongSelf.pickerController animated:YES completion:nil];
            }];
        }
    };
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    if ([self.delegate respondsToSelector:@selector(imagePickerControllerViewControllerDidCancel:)]) {
        [self.delegate imagePickerControllerViewControllerDidCancel:self];
    }
}

@end
