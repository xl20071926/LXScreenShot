//
//  LXImageCropperViewController.m
//  LXScreenShot
//
//  Created by Leexin on 16/4/8.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import "LXImageCropperViewController.h"
#import "LXImagePickerControllerViewController.h"
#import "LXToolView.h"

static const CGFloat kBottomSpace = 20.f;
static const CGFloat kCommonViewSpace = 10.f;

@interface LXImageCropperViewController () <UIScrollViewDelegate,LXToolViewDelegate>
{
    float cropWidth, cropHeight;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, strong) UIButton *rotationButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) LXToolView *toolView;
// 蒙层
@property (nonatomic, strong) UIView *topMaskView;
@property (nonatomic, strong) UIView *leftMaskView;
@property (nonatomic, strong) UIView *centerMaskView;
@property (nonatomic, strong) UIView *rightMaskView;
@property (nonatomic, strong) UIView *bottomMaskView;

@end


@implementation LXImageCropperViewController

- (void)dealloc {
    
    self.scrollView = nil;
    self.originalImage = nil;
    self.imageView = nil;
    self.completionHandler = nil;
}

- (id)initWithOriginalImage:(UIImage *)image cropWidth:(float)width cropHeight:(float)height {
    
    self = [super init];
    if (self) {
        self.originalImage = image;
        cropWidth = width;
        cropHeight = height;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self initSubViews];
    [self resetImageView];
}

- (void)initSubViews {
    
    [self initScrollView];
    [self initMaskView];
    
    self.rotationButton.frame = CGRectMake(0, 0, 80, 50);
    self.rotationButton.left = (self.view.width - self.rotationButton.width) / 2;
    self.rotationButton.top = SCREEN_HEIGHT - self.rotationButton.height;
    [self.view addSubview:self.rotationButton];
    
    self.cancelButton.frame = CGRectMake(0, 20, 80.f, 30.f);
    self.cancelButton.left = kBottomSpace;
    [self.view addSubview:self.cancelButton];
    
    self.doneButton.frame = self.cancelButton.frame;
    self.doneButton.left = (SCREEN_WIDTH - kBottomSpace - self.doneButton.width);
    [self.view addSubview:self.doneButton];
    
    self.toolView.left = 0;
    self.toolView.top = self.bottomMaskView.top + kCommonViewSpace;
    [self.view addSubview:self.toolView];
}

- (void)initMaskView {
    
    self.topMaskView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, (self.scrollView.frame.size.height - cropHeight) / 2);
    [self.view addSubview:self.topMaskView];
    
    self.leftMaskView.frame = CGRectMake(0, self.topMaskView.origin.y + self.topMaskView.size.height, (self.scrollView.frame.size.width - cropWidth) / 2, cropHeight);
    [self.view addSubview:self.leftMaskView];
    
    self.centerMaskView.frame = CGRectMake(self.leftMaskView.origin.x + self.leftMaskView.size.width, self.leftMaskView.origin.y, cropWidth, cropHeight);;
    [self.view addSubview:self.centerMaskView];
    
    self.rightMaskView.frame = CGRectMake(self.centerMaskView.origin.x + self.centerMaskView.size.width, self.centerMaskView.origin.y, (self.scrollView.frame.size.width - cropWidth) / 2, cropHeight);
    [self.view addSubview:self.rightMaskView];
    
    self.bottomMaskView.frame = CGRectMake(0, self.rightMaskView.origin.y + self.rightMaskView.size.height, self.scrollView.frame.size.width, (self.scrollView.frame.size.height - cropHeight) / 2);
    [self.view addSubview:self.bottomMaskView];
}

- (void)initScrollView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor blackColor];
    
    UIEdgeInsets edgeInsets;
    edgeInsets.top = (self.scrollView.frame.size.height - cropHeight) / 2;
    edgeInsets.left = (self.scrollView.frame.size.width - cropWidth) / 2;
    edgeInsets.right = edgeInsets.left;
    edgeInsets.bottom = edgeInsets.top;
    self.scrollView.contentInset = edgeInsets;
    self.scrollView.scrollIndicatorInsets = edgeInsets;
    
    float maxZoomScale = self.originalImage.size.width / cropWidth;
    if (maxZoomScale < 3) {
        maxZoomScale = 3;
    }
    [self.scrollView setMaximumZoomScale:maxZoomScale];
    [self.scrollView setMinimumZoomScale:1];
    [self.scrollView setZoomScale:maxZoomScale];
    [self.scrollView setZoomScale:1];
    
    [self.view addSubview:self.scrollView];
}

#pragma mark - Custom Methods

- (void)resetImageView {
    
    self.scrollView.zoomScale = 1;
    
    if (nil == self.originalImage) return;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    float width = self.originalImage.size.width;
    float height = self.originalImage.size.height;
    CGSize size;
    if (width / height > cropWidth / cropHeight) {
        size.height = cropHeight;
        size.width = width / height * size.height;
    } else {
        size.width = cropWidth;
        size.height = height / width * size.width;
    }
    
    self.scrollView.contentSize = size;
    
    [self.imageView removeFromSuperview];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    self.imageView.image = self.originalImage;
    [self.scrollView addSubview:self.imageView];
    
    [self.scrollView scrollRectToVisible:CGRectMake((self.imageView.frame.size.width - cropWidth) / 2, (self.imageView.frame.size.height - cropHeight) / 2, cropWidth, cropHeight) animated:NO];
}

- (void)cropImage {
    
    CGRect rect;
    rect.origin.x = self.scrollView.contentInset.left + self.scrollView.contentOffset.x;
    rect.origin.y = self.scrollView.contentInset.top + self.scrollView.contentOffset.y;
    rect.size = CGSizeMake(cropWidth, cropHeight);
    
    float scale = self.originalImage.size.width / self.scrollView.contentSize.width;
    
    rect.origin.x = rect.origin.x * scale;
    rect.origin.y = rect.origin.y * scale;
    rect.size.width = rect.size.width * scale;
    rect.size.height = rect.size.height * scale;
    
    UIImage *sourceImage = [self rotateImage:self.originalImage orientation:self.imageView.image.imageOrientation];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(sourceImage.CGImage, rect);
    UIImage *cropImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    UIImageWriteToSavedPhotosAlbum(cropImage, nil, nil, nil);
    
    self.completionHandler(cropImage);
}

- (UIImage *)rotateImage:(UIImage *)aImage orientation:(UIImageOrientation)orient {
    
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

- (void)onRotationButtonClick {
    
    UIImage *rotationImage;
    switch (self.imageView.image.imageOrientation) {
        case UIImageOrientationUp:
            rotationImage = [UIImage imageWithCGImage:self.originalImage.CGImage scale:1.0 orientation:UIImageOrientationRight];
            
            break;
        case UIImageOrientationRight:
            rotationImage = [UIImage imageWithCGImage:self.originalImage.CGImage scale:1.0 orientation:UIImageOrientationDown];
            break;
        case UIImageOrientationDown:
            rotationImage = [UIImage imageWithCGImage:self.originalImage.CGImage scale:1.0 orientation:UIImageOrientationLeft];
            break;
        case UIImageOrientationLeft:
            rotationImage = [UIImage imageWithCGImage:self.originalImage.CGImage scale:1.0 orientation:UIImageOrientationUp];
            break;
        default:
            break;
    }
    
    self.originalImage = rotationImage;
    [self resetImageView];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.imageView;
}

#pragma mark - LXToolViewDelegate

- (void)toolView:(LXToolView *)toolView didClickToolButton:(UIButton *)toolButton {
    
    self.scrollView.userInteractionEnabled = !toolButton.selected;

    if (toolButton.selected) {
        
        
    }
}

#pragma mark - Event Response

- (void)onCancelButtonClick {
    
    self.completionHandler(nil);
}

- (void)onDoneButtonClick {
    
    [self cropImage];
}

#pragma mark - Getters

- (UIButton *)rotationButton {
    
    if (!_rotationButton) {
        _rotationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rotationButton setTitle:@"旋转" forState:UIControlStateNormal];
        [_rotationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rotationButton addTarget:self action:@selector(onRotationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rotationButton;
}

- (UIButton *)cancelButton {
    
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)doneButton {
    
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitle:@"使用照片" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(onDoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (LXToolView *)toolView {
    
    if (!_toolView) {
        _toolView = [[LXToolView alloc] init];
        _toolView.delegate = self;
    }
    return _toolView;
}

- (UIView *)topMaskView {
    
    if (!_topMaskView) {
        _topMaskView = [[UIView alloc] init];
        _topMaskView.backgroundColor = [UIColor blackColor];
        _topMaskView.alpha = 0.5;
        _topMaskView.userInteractionEnabled = NO;
    }
    return _topMaskView;
}

- (UIView *)leftMaskView {
    
    if (!_leftMaskView) {
        _leftMaskView = [[UIView alloc] init];
        _leftMaskView.backgroundColor = [UIColor blackColor];
        _leftMaskView.alpha = 0.5;
        _leftMaskView.userInteractionEnabled = NO;
    }
    return _leftMaskView;
}

- (UIView *)centerMaskView {
    
    if (!_centerMaskView) {
        _centerMaskView = [[UIView alloc] init];
        _centerMaskView.backgroundColor = [UIColor clearColor];
        _centerMaskView.layer.borderColor = [UIColor grayColor].CGColor;
        _centerMaskView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        _centerMaskView.userInteractionEnabled = NO;
    }
    return _centerMaskView;
}

- (UIView *)rightMaskView {
    
    if (!_rightMaskView) {
        _rightMaskView = [[UIView alloc] init];
        _rightMaskView.backgroundColor = [UIColor blackColor];
        _rightMaskView.alpha = 0.5;
        _rightMaskView.userInteractionEnabled = NO;
    }
    return _rightMaskView;
}

- (UIView *)bottomMaskView {
    
    if (!_bottomMaskView) {
        _bottomMaskView = [[UIView alloc] init];
        _bottomMaskView.backgroundColor = [UIColor blackColor];
        _bottomMaskView.alpha = 0.5;
        _bottomMaskView.userInteractionEnabled = NO;
    }
    return _bottomMaskView;
}

@end
