//
//  LXToolView.m
//  LXScreenShot
//
//  Created by Leexin on 16/4/18.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import "LXToolView.h"
#import "UIView+Extensions.h"
#import "LXToolPopView.h"

static const CGFloat kToolButtonSpace = 5.f;
static const CGFloat kToolButtonWidth = 25.f;
static const CGFloat kToolButtonHeight = 20.f;

@interface LXToolView ()

@property (nonatomic, strong) UIButton *rectButton;
@property (nonatomic, strong) UIButton *circleButton;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UIButton *penButton;
@property (nonatomic, strong) UIButton *textButton;
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation LXToolView

#pragma mark - Life Cycle

- (instancetype)init {
    
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 200.f, kToolButtonHeight)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.cornerRadius = 2.f;
        self.layer.masksToBounds = YES;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    self.rectButton.frame = CGRectMake(kToolButtonSpace, 0, kToolButtonWidth, kToolButtonHeight);
    [self addSubview:self.rectButton];
    
    self.circleButton.frame = self.rectButton.frame;
    self.circleButton.left = self.rectButton.right + kToolButtonSpace;
    [self addSubview:self.circleButton];
    
    self.arrowButton.frame = self.rectButton.frame;
    self.arrowButton.left = self.circleButton.right + kToolButtonSpace;
    [self addSubview:self.arrowButton];
    
    self.penButton.frame = self.rectButton.frame;
    self.penButton.left = self.arrowButton.right + kToolButtonSpace;
    [self addSubview:self.penButton];
    
    self.textButton.frame = self.rectButton.frame;
    self.textButton.left = self.penButton.right + kToolButtonSpace;
    [self addSubview:self.textButton];
    
    self.shareButton.frame = self.rectButton.frame;
    self.shareButton.left = self.textButton.right + kToolButtonSpace;
    [self addSubview:self.shareButton];
}

#pragma mark - Event Response

- (void)onToolButtonClick:(UIButton *)sender {
    
    LXToolButtonType type = sender.tag;
    if (!sender.selected) {
        for (NSInteger i = LXToolButtonTypeRect; i < LXToolButtonTypeRect + 6; i++) {
            UIButton *button = (UIButton *)[self viewWithTag:i];
            if (i != type) {
                button.selected = NO;
            }
        }
    }
    sender.selected = !sender.selected;

    if ([self.delegate respondsToSelector:@selector(toolView:didClickToolButton:)]) {
        [self.delegate toolView:self didClickToolButton:sender];
    }
    
    switch (type) {
        case LXToolButtonTypeRect: {
            NSLog(@"点击矩形");
            LXToolPopView *popView = [[LXToolPopView alloc] initWithFrame:CGRectMake(0,kToolButtonHeight + 5.f, 150, 23)];
            [self addSubview:popView];
        }
            break;
        case LXToolButtonTypeCircle: {
            NSLog(@"点击圆形");
        }
            break;
        case LXToolButtonTypeArrow: {
            NSLog(@"点击箭头");
        }
            break;
        case LXToolButtonTypePen: {
            NSLog(@"点击笔");
        }
            break;
        case LXToolButtonTypeText: {
            NSLog(@"点击文字");
        }
            break;
        case LXToolButtonTypeShare: {
            NSLog(@"点击分享");
        }
            break;
        default:
            break;
    }
}

#pragma mark - Getters

- (UIButton *)rectButton {
    
    if (!_rectButton) {
        _rectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rectButton.tag = LXToolButtonTypeRect;
        _rectButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_rectButton setTitle:@"矩形" forState:UIControlStateNormal];
        [_rectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rectButton setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [_rectButton addTarget:self action:@selector(onToolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rectButton;
}

- (UIButton *)circleButton {
    
    if (!_circleButton) {
        _circleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _circleButton.tag = LXToolButtonTypeCircle;
        _circleButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_circleButton setTitle:@"圆形" forState:UIControlStateNormal];
        [_circleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_circleButton setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [_circleButton addTarget:self action:@selector(onToolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _circleButton;
}

- (UIButton *)arrowButton {
    
    if (!_arrowButton) {
        _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _arrowButton.tag = LXToolButtonTypeArrow;
        _arrowButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_arrowButton setTitle:@"箭头" forState:UIControlStateNormal];
        [_arrowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_arrowButton setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [_arrowButton addTarget:self action:@selector(onToolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowButton;
}

- (UIButton *)penButton {
    
    if (!_penButton) {
        _penButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _penButton.tag = LXToolButtonTypePen;
        _penButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_penButton setTitle:@"笔" forState:UIControlStateNormal];
        [_penButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_penButton setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [_penButton addTarget:self action:@selector(onToolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _penButton;
}

- (UIButton *)textButton {
    
    if (!_textButton) {
        _textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _textButton.tag = LXToolButtonTypeText;
        _textButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_textButton setTitle:@"文字" forState:UIControlStateNormal];
        [_textButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_textButton setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [_textButton addTarget:self action:@selector(onToolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textButton;
}

- (UIButton *)shareButton {
    
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.tag = LXToolButtonTypeShare;
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [_shareButton addTarget:self action:@selector(onToolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

@end
