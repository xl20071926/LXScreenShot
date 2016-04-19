//
//  LXDrawImageView.m
//  LXScreenShot
//
//  Created by Leexin on 16/4/19.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import "LXDrawImageView.h"

@interface LXDrawImageView ()

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint movePoint;

@end

@implementation LXDrawImageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.zoomScale = 1.f;
        self.lineWidth = 2.f;
        self.color = [UIColor redColor];
    }
    return self;
}

- (void)drawImageAtImageContextWithPonit:(CGPoint)point {
    
    switch (self.type) {
        case LXToolButtonTypeRect: {
            self.image = self.originImage;
            [self drawRectWithPoint:point];
        }
            break;
        case LXToolButtonTypeCircle: {
            self.image = self.originImage;
            [self drawCircleWithPoint:point];
        }
            break;
        case LXToolButtonTypeArrow: {
            self.image = self.originImage;
            [self drawArrowWithPoint:point];
        }
            break;
        case LXToolButtonTypePen: {
            [self drawLineWithPoint:point];
        }
            break;
        default:
            break;
    }
}

- (void)drawRectWithPoint:(CGPoint)point { // 画矩形
    
    UIGraphicsBeginImageContext(self.frame.size);
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, CGRectMake(self.startPoint.x * self.zoomScale,
                                         self.startPoint.y * self.zoomScale,
                                         (point.x - self.startPoint.x) * self.zoomScale,
                                         (point.y - self.startPoint.y) * self.zoomScale));
    [self.color setStroke];
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)drawCircleWithPoint:(CGPoint)point { // 画圆形
    
    UIGraphicsBeginImageContext(self.frame.size);
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(self.startPoint.x * self.zoomScale,
                                                  self.startPoint.y * self.zoomScale,
                                                  (point.x - self.startPoint.x) * self.zoomScale,
                                                  (point.y - self.startPoint.y) * self.zoomScale));
    [self.color setStroke];
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)drawArrowWithPoint:(CGPoint)point { // 画箭头
    
}

- (void)drawLineWithPoint:(CGPoint)point { // 画线
    
    UIGraphicsBeginImageContext(self.frame.size);
    [self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, self.movePoint.x * self.zoomScale, self.movePoint.y * self.zoomScale);
    CGContextAddLineToPoint(context, point.x * self.zoomScale, point.y * self.zoomScale);
    [self.color setStroke];
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.movePoint = point;
}

#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[touches allObjects] firstObject];
    self.startPoint = [touch locationInView:self];
    self.movePoint = self.startPoint;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[touches allObjects] firstObject];
    CGPoint point = [touch locationInView:self];
    [self drawImageAtImageContextWithPonit:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    UITouch *touch = [[touches allObjects] firstObject];
    self.startPoint = CGPointZero;
    self.originImage = self.image;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    UITouch *touch = [[touches allObjects] firstObject];
    self.startPoint = CGPointZero;
    self.originImage = self.image;
}

@end
