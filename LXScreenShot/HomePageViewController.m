//
//  HomePageViewController.m
//  LXScreenShot
//
//  Created by Leexin on 16/4/8.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *selectPictureButton;

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
    self.selectPictureButton.center = self.backgroundImageView.center;
    [self.backgroundImageView addSubview:self.selectPictureButton];
}

- (void)showPhotoLibrary {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
}

#pragma mark - Event Response

- (void)onSelectPictureButtonClick:(UIButton *)sender {
    
    [self showPhotoLibrary];
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
        [_selectPictureButton setTitle:@"请选取照片" forState:UIControlStateNormal];
        [_selectPictureButton setTitleColor:[UIColor colorWithHex:0x212121] forState:UIControlStateNormal];
        [_selectPictureButton addTarget:self action:@selector(onSelectPictureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectPictureButton;
}

@end
