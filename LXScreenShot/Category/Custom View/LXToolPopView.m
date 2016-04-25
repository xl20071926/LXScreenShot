//
//  LXToolPopView.m
//  LXScreenShot
//
//  Created by Leexin on 16/4/22.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import "LXToolPopView.h"
#import "UIView+Extensions.h"
#import "UIColor+Extensions.h"
#import "UIImage+Category.h"
#import "NSArray+Category.h"

static const CGFloat kColorSelectViewSpace = 2.f;
static const CGFloat kColorSelectContentViewWidth = 40.f;
static const NSInteger kColorButtonTag = 88;

static const CGFloat kArrowSize = 5.f;
static const CGFloat kViewSpace = 5.f;
static const CGFloat kButtonHeight = 18.f;
static const CGFloat kButtonWidth = 30.f;
static const CGFloat kToolPopViewHeight = 20.f;
static const CGFloat kToolPopViewWidth = 150.f;

@interface LXColorSelectView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, retain) NSArray *colorArray;
@property (nonatomic, copy) void (^completeBlock)(UIColor *color);

- (instancetype)initWithColorArray:(NSArray *)colorArray;
- (void)showColorSelectViewWithLocation:(CGPoint)point;

@end

@implementation LXColorSelectView

#pragma mark - Life Cycle

- (instancetype)initWithColorArray:(NSArray *)colorArray {
    
    self = [self initWithFrame:SCREEN_KEY_WINDOW.bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.colorArray = [NSArray arrayWithArray:colorArray];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    [self addSubview:self.contentView];
    for (int i = 0; i < self.colorArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((kColorSelectContentViewWidth - kButtonWidth) / 2,
                                  (i * kButtonHeight) + ((i + 1) * kColorSelectViewSpace),
                                  kButtonWidth,
                                  kButtonHeight);
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1.f;
        button.tag = i + kColorButtonTag;
        [button setImage:[UIImage imageWithColor:self.colorArray[i] size:button.size] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScreenClick)];
    [self addGestureRecognizer:tap];
}

#pragma mark - Custom Methods

- (void)showColorSelectViewWithLocation:(CGPoint)point { // 弹出颜色选择框
    
    self.contentView.left = point.x - (kColorSelectContentViewWidth - kButtonWidth) / 2;
    if (point.y + self.contentView.height > SCREEN_KEY_WINDOW.height) {
        self.contentView.bottom = point.y - kViewSpace;
    } else {
        self.contentView.top = point.y + kViewSpace;
    }
    [SCREEN_KEY_WINDOW addSubview:self];
}

- (void)hideColorSelectView { // 隐藏颜色选择框
    
    [self removeFromSuperview];
}

#pragma mark - Event Response

- (void)onButtonClick:(UIButton *)sender {
    
    NSInteger index = sender.tag - kColorButtonTag;
    UIColor *color = [self.colorArray safeObjectAtIndex:index];
    [self hideColorSelectView];
    self.completeBlock(color);
}

- (void)onScreenClick {
    
    [self hideColorSelectView];
}

#pragma mark - Getter

- (UIView *)contentView {
    
    if (!_contentView) {
        CGFloat contentHeight = self.colorArray.count * kButtonHeight + (self.colorArray.count + 1) * kColorSelectViewSpace;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kColorSelectContentViewWidth, contentHeight)];
        _contentView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
        _contentView.layer.cornerRadius = 4.f;
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        _contentView.layer.borderWidth = 1.f;
    }
    return _contentView;
}

@end



@interface LXToolPopView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIButton *smallSizeButton;
@property (nonatomic, strong) UIButton *midSizeButton;
@property (nonatomic, strong) UIButton *bigSizeButton;
@property (nonatomic, strong) UIButton *colorButton;
@property (nonatomic, strong) LXColorSelectView *colorSelectView; // 颜色选择框

@end

@implementation LXToolPopView

#pragma mark - Life Cycle

- (instancetype)init {
    
    return [self initWithFrame:CGRectMake(0, 0, kToolPopViewWidth, kToolPopViewHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, kToolPopViewWidth, kToolPopViewHeight)];
    if (self) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    
    [self addSubview:self.backgroundView];
    [self sendSubviewToBack:self.backgroundView];
    
    self.smallSizeButton.frame = CGRectMake(0, kArrowSize + (kToolPopViewHeight - kButtonHeight) / 2, kButtonWidth, kButtonHeight);
    [self addSubview:self.smallSizeButton];
    self.midSizeButton.frame = CGRectMake(self.smallSizeButton.right + kViewSpace, self.smallSizeButton.top, kButtonWidth, kButtonHeight);
    [self addSubview:self.midSizeButton];
    self.bigSizeButton.frame = CGRectMake(self.midSizeButton.right + kViewSpace, self.smallSizeButton.top, kButtonWidth, kButtonHeight);
    [self addSubview:self.bigSizeButton];
    self.colorButton.frame = CGRectMake(self.bigSizeButton.right + kViewSpace, self.smallSizeButton.top, kButtonWidth, kButtonHeight);
    [self.colorButton setImage:[UIImage imageWithColor:[UIColor redColor] size:self.colorButton.size] forState:UIControlStateNormal];
    [self addSubview:self.colorButton];
    
    self.colorSelectView = [[LXColorSelectView alloc] initWithColorArray:@[[UIColor colorWithHex:0xFF0000],
                                                                           [UIColor colorWithHex:0xFF82AB],
                                                                           [UIColor colorWithHex:0xA020F0],
                                                                           [UIColor colorWithHex:0x1E90FF],
                                                                           [UIColor colorWithHex:0x54FF9F],
                                                                           [UIColor colorWithHex:0xFFFF00],
                                                                           [UIColor colorWithHex:0xFF8C00],
                                                                           [UIColor colorWithHex:0xCCCCCC],
                                                                           [UIColor colorWithHex:0x080808],
                                                                           [UIColor colorWithHex:0xFFFFFF]]];
    __weak typeof(self)weakSelf = self;
    self.colorSelectView.completeBlock = ^(UIColor *color) {
        
        [weakSelf.colorButton setImage:[UIImage imageWithColor:color size:weakSelf.colorButton.size]
                              forState:UIControlStateNormal];
        if ([weakSelf.delegate respondsToSelector:@selector(toolPopView:clickedColorButtonWithColor:)]) {
            [weakSelf.delegate toolPopView:weakSelf clickedColorButtonWithColor:color];
        }
    };
    self.hidden = YES;
}

#pragma mark - Public Methods

- (void)showPopViewWithArrowPoint:(CGPoint)point {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point];
    [path addLineToPoint:CGPointMake(point.x - kArrowSize, point.y + kArrowSize)];
    [path addLineToPoint:CGPointMake(0, point.y + kArrowSize)];
    [path addLineToPoint:CGPointMake(0, point.y + kArrowSize + kToolPopViewHeight)];
    [path addLineToPoint:CGPointMake(kToolPopViewWidth, point.y + kArrowSize + kToolPopViewHeight)];
    [path addLineToPoint:CGPointMake(kToolPopViewWidth, point.y + kArrowSize)];
    [path addLineToPoint:CGPointMake(point.x + kArrowSize, point.y + kArrowSize)];
    [path closePath];
    
    self.shapeLayer.path = path.CGPath;
    self.shapeLayer.fillColor = [UIColor colorWithHex:0xD1D1D1 alpha:0.8].CGColor;
    self.shapeLayer.strokeColor = [UIColor colorWithHex:0xBCD2EE].CGColor;
    self.shapeLayer.lineWidth = 1.f;
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 1;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.lineCap = kCALineCapRound;
    [self.backgroundView.layer addSublayer:self.shapeLayer];
    
    self.hidden = NO;
}

- (void)hidePopView {
    
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    self.hidden = YES;
}

#pragma mark - Event Response

- (void)onSizeButtonClick:(UIButton *)sender {
    
    sender.selected = YES;
    for (NSInteger i = ToolPopViewLineWidthTypeSmall; i < ToolPopViewLineWidthTypeSmall + 3; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i];
        if (i != sender.tag) {
            button.selected = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(toolPopView:clickedSizeButtonType:)]) {
        [self.delegate toolPopView:self clickedSizeButtonType:sender.tag];
    }
}

- (void)onColorButtonClick:(UIButton *)sender {
    
    CGPoint point = [self convertPoint:self.colorButton.frame.origin toView:SCREEN_KEY_WINDOW];
    [self.colorSelectView showColorSelectViewWithLocation:point];
}

#pragma mark - Getters

- (UIView *)backgroundView {
    
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _backgroundView;
}

- (CAShapeLayer *)shapeLayer {
    
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
    }
    return _shapeLayer;
}

- (UIButton *)smallSizeButton {
    
    if (!_smallSizeButton) {
        _smallSizeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _smallSizeButton.tag = ToolPopViewLineWidthTypeSmall;
        _smallSizeButton.contentMode = UIViewContentModeScaleAspectFit;
        [_smallSizeButton setImage:[UIImage imageNamed:@"black_dot_6"] forState:UIControlStateNormal];
//        [_smallSizeButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_smallSizeButton addTarget:self action:@selector(onSizeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smallSizeButton;
}

- (UIButton *)midSizeButton {
    
    if (!_midSizeButton) {
        _midSizeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _midSizeButton.tag = ToolPopViewLineWidthTypeMid;
        _midSizeButton.contentMode = UIViewContentModeScaleAspectFit;
        [_midSizeButton setImage:[UIImage imageNamed:@"black_dot_8"] forState:UIControlStateNormal];
//        [_midSizeButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_midSizeButton addTarget:self action:@selector(onSizeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _midSizeButton;
}

- (UIButton *)bigSizeButton {
    
    if (!_bigSizeButton) {
        _bigSizeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _bigSizeButton.tag = ToolPopViewLineWidthTypeBig;
        _bigSizeButton.contentMode = UIViewContentModeScaleAspectFit;
        [_bigSizeButton setImage:[UIImage imageNamed:@"black_dot_10"] forState:UIControlStateNormal];
//        [_bigSizeButton setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_bigSizeButton addTarget:self action:@selector(onSizeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bigSizeButton;
}


- (UIButton *)colorButton {
    
    if (!_colorButton) {
        _colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _colorButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _colorButton.layer.borderWidth = 1.f;
        [_colorButton addTarget:self action:@selector(onColorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _colorButton;
}


@end
