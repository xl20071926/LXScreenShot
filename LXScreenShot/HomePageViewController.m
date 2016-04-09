//
//  HomePageViewController.m
//  LXScreenShot
//
//  Created by Leexin on 16/4/8.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import "HomePageViewController.h"
#import "LXImagePickerControllerViewController.h"

static const CGFloat kViewSpace = 20.f;

@interface HomePageViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *selectPictureButton;
@property (nonatomic, strong) UIButton *takePhotoButton;
@property (nonatomic, strong) UIButton *identifyTypeButton;

@end

@implementation HomePageViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custome Method

- (void)addSubViews {
    
    self.backgroundImageView.frame = self.view.bounds;
    [self.view addSubview:self.backgroundImageView];
    
    self.selectPictureButton.frame = CGRectMake(0, 0, 100.f, 30.f);
    self.selectPictureButton.center = CGPointMake(self.backgroundImageView.center.x, self.backgroundImageView.center.y - self.selectPictureButton.height - kViewSpace);
    [self.backgroundImageView addSubview:self.selectPictureButton];
    
    self.takePhotoButton.frame = CGRectMake(self.selectPictureButton.left, self.selectPictureButton.bottom + kViewSpace, self.selectPictureButton.width, self.selectPictureButton.height);
    [self.backgroundImageView addSubview:self.takePhotoButton];
    
    self.identifyTypeButton.frame = CGRectMake(self.selectPictureButton.left, self.takePhotoButton.bottom + kViewSpace, self.selectPictureButton.width, self.selectPictureButton.height);
    [self.backgroundImageView addSubview:self.identifyTypeButton];
}

- (void)showImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType cameraType:(LXCameraOverlayViewType)cameraType {
    
    LXImagePickerControllerViewController *imagePickerController = [[LXImagePickerControllerViewController alloc] initWithController:self sourceType:sourceType cameraType:cameraType];
    [imagePickerController showCameraController];
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

#pragma mark - Getter

- (UIImageView *)backgroundImageView {
    
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:@"HomePage_backgroud.jpeg"];
        _backgroundImageView.userInteractionEnabled = YES;
        [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _backgroundImageView;
}

- (UIButton *)selectPictureButton {
    
    if (!_selectPictureButton) {
        _selectPictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectPictureButton setTitle:@"选取照片" forState:UIControlStateNormal];
        [_selectPictureButton setTitleColor:[UIColor colorWithHex:0x212121] forState:UIControlStateNormal];
        [_selectPictureButton addTarget:self action:@selector(onSelectPictureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectPictureButton;
}

- (UIButton *)takePhotoButton {
    
    if (!_takePhotoButton) {
        _takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takePhotoButton setTitle:@"拍照" forState:UIControlStateNormal];
        [_takePhotoButton setTitleColor:[UIColor colorWithHex:0x212121] forState:UIControlStateNormal];
        [_takePhotoButton addTarget:self action:@selector(onTakePhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhotoButton;
}

- (UIButton *)identifyTypeButton {
    
    if (!_identifyTypeButton) {
        _identifyTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_identifyTypeButton setTitle:@"身份证拍照" forState:UIControlStateNormal];
        [_identifyTypeButton setTitleColor:[UIColor colorWithHex:0x212121] forState:UIControlStateNormal];
        [_identifyTypeButton addTarget:self action:@selector(onIdentifyTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _identifyTypeButton;
}

@end
