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

static const CGFloat kArrowSize = 5.f;
static const CGFloat kFrameHeight = 20.f;
static const CGFloat kFrameWidth = 150.f;

@interface LXToolPopView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation LXToolPopView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}


- (void)initSubViews {
    
    [self drawFrameWithArrowPoint:CGPointMake(self.width / 2, 0)];
}

- (void)drawFrameWithArrowPoint:(CGPoint)point {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point];
    [path addLineToPoint:CGPointMake(point.x - kArrowSize, point.y + kArrowSize)];
    [path addLineToPoint:CGPointMake(0, point.y + kArrowSize)];
    [path addLineToPoint:CGPointMake(0, point.y + kArrowSize + kFrameHeight)];
    [path addLineToPoint:CGPointMake(kFrameWidth, point.y + kArrowSize + kFrameHeight)];
    [path addLineToPoint:CGPointMake(kFrameWidth, point.y + kArrowSize)];
    [path addLineToPoint:CGPointMake(point.x + kArrowSize, point.y + kArrowSize)];
    [path closePath];
    
    self.shapeLayer.path = path.CGPath;
    self.shapeLayer.fillColor = [UIColor colorWithHex:0xD1D1D1 alpha:0.8].CGColor;
    self.shapeLayer.strokeColor = [UIColor purpleColor].CGColor;
    self.shapeLayer.lineWidth = 1.f;
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 1;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:self.shapeLayer];
}


#pragma mark - Getter

- (CAShapeLayer *)shapeLayer {
    
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
    }
    return _shapeLayer;
}



@end
