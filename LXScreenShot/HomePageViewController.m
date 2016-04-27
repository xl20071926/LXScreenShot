//
//  HomePageViewController.m
//  LXScreenShot
//
//  Created by Leexin on 16/4/8.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import "HomePageViewController.h"
#import "LXImagePickerViewController.h"
#import "LXAnimationLabel.h"

static const CGFloat kViewSpace = 20.f;

@interface HomePageViewController () <LXImagePickerControllerViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) LXAnimationLabel *selectPictureButton;
@property (nonatomic, strong) LXAnimationLabel *takePhotoButton;
@property (nonatomic, strong) LXAnimationLabel *identifyTypeButton;

@property (nonatomic, strong) LXAnimationLabel *animationLabel;

@end

@implementation HomePageViewController

#pragma mark - Life Cycle

- (void)dealloc {
    
    NSLog(@"dealloc HomePageViewController");
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self addSubViews];
}

#pragma mark - Custome Method

- (void)addSubViews {
    
    self.backgroundImageView.frame = self.view.bounds;
    [self.view addSubview:self.backgroundImageView];
    
    self.selectPictureButton = [[LXAnimationLabel alloc] initWithFrame:CGRectMake((self.backgroundImageView.width - 300.f) / 2,
                                                                                  (self.backgroundImageView.height - 150.f - 2 * kViewSpace) / 2,
                                                                                  300.f,
                                                                                  50.f)];
    self.selectPictureButton.textAlignment = NSTextAlignmentCenter;
    self.selectPictureButton.font = [UIFont systemFontOfSize:24.f];
    self.selectPictureButton.textColor = [UIColor whiteColor];
    self.selectPictureButton.text = @"Choose Photo";
    [self.backgroundImageView addSubview:self.selectPictureButton];
    
    
    self.takePhotoButton = [[LXAnimationLabel alloc] initWithFrame:CGRectMake(self.selectPictureButton.left,
                                                                              self.selectPictureButton.bottom + kViewSpace,
                                                                              self.selectPictureButton.width,
                                                                              self.selectPictureButton.height)];
    self.takePhotoButton.textAlignment = NSTextAlignmentCenter;
    self.takePhotoButton.font = [UIFont systemFontOfSize:24.f];
    self.takePhotoButton.textColor = [UIColor whiteColor];
    self.takePhotoButton.text = @"Take Photo";
    [self.backgroundImageView addSubview:self.takePhotoButton];
    
    self.identifyTypeButton = [[LXAnimationLabel alloc] initWithFrame:CGRectMake(self.selectPictureButton.left,
                                                                                 self.takePhotoButton.bottom + kViewSpace,
                                                                                 self.selectPictureButton.width,
                                                                                 self.selectPictureButton.height)];
    self.identifyTypeButton.textAlignment = NSTextAlignmentCenter;
    self.identifyTypeButton.font = [UIFont systemFontOfSize:24.f];
    self.identifyTypeButton.textColor = [UIColor whiteColor];
    self.identifyTypeButton.text = @"Take Identify Photo";
    [self.backgroundImageView addSubview:self.identifyTypeButton];
    
    
    UITapGestureRecognizer *selectPictureGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectPictureButtonClick:)];
    self.selectPictureButton.userInteractionEnabled = YES;
    [self.selectPictureButton addGestureRecognizer:selectPictureGesture];
    
    UITapGestureRecognizer *takePhotoGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTakePhotoButtonClick:)];
    self.takePhotoButton.userInteractionEnabled = YES;
    [self.takePhotoButton addGestureRecognizer:takePhotoGesture];
    
    UITapGestureRecognizer *identifyGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onIdentifyTypeButtonClick:)];
    self.identifyTypeButton.userInteractionEnabled = YES;
    [self.identifyTypeButton addGestureRecognizer:identifyGesture];
}

- (void)showImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType cameraType:(LXCameraOverlayViewType)cameraType {

    LXImagePickerViewController *imagePickerController = [[LXImagePickerViewController alloc] initWithController:self
                                                                                                      sourceType:sourceType
                                                                                                      cameraType:cameraType];
    imagePickerController.delegate = self;
    [imagePickerController showCameraController];
}

#pragma mark - LXImagePickerControllerViewControllerDelegate

- (void)imagePickerControllerViewController:(LXImagePickerViewController *)controller didFinishPickingImage:(UIImage *)image {
    
    [self.navigationController popViewControllerAnimated:NO];
    NSLog(@"didFinishPickingImage");
}

- (void)imagePickerControllerViewControllerDidCancel:(LXImagePickerViewController *)controller {
    
    [self.navigationController popViewControllerAnimated:NO];
    NSLog(@"imagePickerControllerViewControllerDidCancel");
}

#pragma mark - Event Response

- (void)onSelectPictureButtonClick:(UIButton *)sender {
    
    [self showImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary cameraType:LXCameraOverlayViewTypeDefault];
}

- (void)onTakePhotoButtonClick:(UIButton *)sender {
    
    [self showImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera cameraType:LXCameraOverlayViewTypeDefault];
}

- (void)onIdentifyTypeButtonClick:(UIButton *)sender {
    
    [self showImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera cameraType:LXCameraOverlayViewTypeIdentify];
}

#pragma mark - Getters

- (UIImageView *)backgroundImageView {
    
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:@"HomePage_backgroud.jpg"];
        _backgroundImageView.userInteractionEnabled = YES;
        [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _backgroundImageView;
}

//- (UIButton *)selectPictureButton {
//    
//    if (!_selectPictureButton) {
//        _selectPictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_selectPictureButton setTitle:@"选取照片" forState:UIControlStateNormal];
//        [_selectPictureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_selectPictureButton addTarget:self action:@selector(onSelectPictureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _selectPictureButton;
//}
//
//- (UIButton *)takePhotoButton {
//    
//    if (!_takePhotoButton) {
//        _takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_takePhotoButton setTitle:@"拍照" forState:UIControlStateNormal];
//        [_takePhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_takePhotoButton addTarget:self action:@selector(onTakePhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _takePhotoButton;
//}
//
//- (UIButton *)identifyTypeButton {
//    
//    if (!_identifyTypeButton) {
//        _identifyTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_identifyTypeButton setTitle:@"身份证拍照" forState:UIControlStateNormal];
//        [_identifyTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_identifyTypeButton addTarget:self action:@selector(onIdentifyTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _identifyTypeButton;
//}

@end
