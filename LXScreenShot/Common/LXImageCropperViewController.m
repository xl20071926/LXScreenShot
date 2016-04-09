//
//  LXImageCropperViewController.m
//  LXScreenShot
//
//  Created by Leexin on 16/4/8.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import "LXImageCropperViewController.h"
#import "LXImagePickerControllerViewController.h"

static const CGFloat kBottomSpace = 20.f;

@interface LXImageCropperViewController ()

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, assign) CGFloat originalImageScale; // 原图宽高比例
@property (nonatomic, assign) CGFloat originScreenImageScale; // 图片和屏幕的比例
@property (nonatomic, assign) CGFloat screenSpace;

@end

@implementation LXImageCropperViewController

#pragma mark - Life Cycle

- (void)dealloc {

    self.originalImage = nil;
    self.imageView = nil;
}

- (id)initWithOriginalImage:(UIImage *)image {
    
    self = [super init];
    if (self) {
        self.originalImage = image;
        
        float width = self.originalImage.size.width;
        float height = self.originalImage.size.height;
        
        if (IS_IPHONE_4_OR_LESS) { //iphone4 拍出的图片屏幕宽度的俩边各会自动多出10的间隙
            self.screenSpace = 10.f;
        } else {
            self.screenSpace = 0;
        }
        if (width > height) { // 拍出来的是横图
            self.originalImageScale = self.originalImage.size.width / self.originalImage.size.height;
            self.originScreenImageScale = self.originalImage.size.height / (SCREEN_WIDTH + 2 * self.screenSpace);
        } else { // 拍出来的是竖直图,需要手动调整调整
            self.originalImageScale = self.originalImage.size.height / self.originalImage.size.width;
            self.originScreenImageScale = self.originalImage.size.width / (SCREEN_WIDTH + 2 * self.screenSpace);
        }
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self resetImageView];
    [self onRotationButtonClick];
    [self initBarButton];
}

- (void)initBarButton {
    
    UIButton *rotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rotationButton.frame = CGRectMake(0, 0, 100.f, 20.f);
    rotationButton.left = (SCREEN_WIDTH - rotationButton.width) / 2;
    rotationButton.top = SCREEN_HEIGHT - kBottomSpace - 25.f;
    [rotationButton setImage:[UIImage imageNamed:@"rotate_button_icon"] forState:UIControlStateNormal];
    [rotationButton setImage:[UIImage imageNamed:@"rotate_press_button_icon"] forState:UIControlStateHighlighted];
    [rotationButton addTarget:self action:@selector(onRotationButtonClickM_PI) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotationButton];
    
    UIButton *rePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rePhotoButton.frame = CGRectMake(0, 0, 80.f, 30.f);
    rePhotoButton.left = kBottomSpace;
    rePhotoButton.top = SCREEN_HEIGHT - kBottomSpace - rePhotoButton.height;
    [rePhotoButton setTitle:@"重拍" forState:UIControlStateNormal];
    [rePhotoButton addTarget:self action:@selector(onRePhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rePhotoButton];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = rePhotoButton.frame;
    doneButton.left = (SCREEN_WIDTH - kBottomSpace - doneButton.width);
    [doneButton setTitle:@"使用照片" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(onDoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
}

#pragma mark - Private Methods

- (void)resetImageView {
    
    if (nil == self.originalImage) return;
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:self.imageView];
    }
    self.imageView.image = self.originalImage;
}

- (void)cropImage { // 剪切图片
    CGRect rect;
    // iphone 拍出的图片比例是4/3 ，身份证比例是1.585
    // 获取蒙层框的尺寸
    rect = CGRectMake(kOverlayViewTop,
                      kOverlayViewBroadsideWidth + self.screenSpace,
                      (SCREEN_WIDTH - 2 * kOverlayViewBroadsideWidth) * kIdentifyScale,
                      SCREEN_WIDTH - 2 * kOverlayViewBroadsideWidth);
  
    // 根据图/屏宽比例 转换成图片的框内尺寸
    rect.origin.x = rect.origin.x * self.originScreenImageScale;
    rect.origin.y = rect.origin.y * self.originScreenImageScale;
    rect.size.width = rect.size.width * self.originScreenImageScale;
    rect.size.height = rect.size.height * self.originScreenImageScale;
    
    UIImage *sourceImage = [self rotateImage:self.originalImage orientation:self.imageView.image.imageOrientation]; 
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(sourceImage.CGImage, rect);
    UIImage *cropImage = [UIImage imageWithCGImage:imageRef];
    self.originalImage = cropImage;
    self.imageView.image = cropImage;
    CGImageRelease(imageRef);
}

- (UIImage *)rotateImage:(UIImage *)aImage orientation:(UIImageOrientation)orient { // 调整图片的方向
    
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    switch (orient) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI /2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI /2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            
            break;
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

#pragma mark - Event Response

- (void)onRotationButtonClick { // 旋转90度
    
    UIImage *rotationImage = self.originalImage;
    switch (self.imageView.image.imageOrientation) {
        case UIImageOrientationRight:
            rotationImage = [UIImage imageWithCGImage:self.originalImage.CGImage scale:1.0 orientation:UIImageOrientationUp];
            break;
        case UIImageOrientationLeft:
            rotationImage = [UIImage imageWithCGImage:self.originalImage.CGImage scale:1.0 orientation:UIImageOrientationDown];
            break;
        default:
            break;
    }
    self.originalImage = rotationImage;
    [self resetImageView];
    [self cropImage];
}

- (void)onRotationButtonClickM_PI { // 旋转180度
    
    UIImage *rotationImage;
    switch (self.imageView.image.imageOrientation) {
        case UIImageOrientationUp:
            rotationImage = [UIImage imageWithCGImage:self.originalImage.CGImage scale:1.0 orientation:UIImageOrientationDown];
            break;
        case UIImageOrientationRight:
            rotationImage = [UIImage imageWithCGImage:self.originalImage.CGImage scale:1.0 orientation:UIImageOrientationUp];
            break;
        case UIImageOrientationDown:
            rotationImage = [UIImage imageWithCGImage:self.originalImage.CGImage scale:1.0 orientation:UIImageOrientationUp];
            break;
        case UIImageOrientationLeft:
            rotationImage = [UIImage imageWithCGImage:self.originalImage.CGImage scale:1.0 orientation:UIImageOrientationDown];
            break;
        default:
            break;
    }
    self.originalImage = rotationImage;
    self.imageView.image = self.originalImage;
}

- (void)onRePhotoButtonClick { // 重拍
    
    self.completionHandler(nil);
}

- (void)onDoneButtonClick { // 完成
    
    self.completionHandler(self.originalImage);
}

@end
