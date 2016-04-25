//
//  LXDrawImageView.m
//  LXScreenShot
//
//  Created by Leexin on 16/4/19.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import "LXDrawImageView.h"
#import "UIView+Extensions.h"
#import "NSObject+Category.h"

static const CGFloat kArrowSize = 10.f; // 箭头的大小

@interface LXDrawImageView () <UITextViewDelegate>

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint movePoint;
@property (nonatomic, assign) CGFloat imageScale; // 图片与ImageView的比例
@property (nonatomic, strong) UITextView *currentTextView; // 当前文字输入框

@end

@implementation LXDrawImageView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.zoomScale = 1.f;
        self.lineWidth = 2.f;
        self.color = [UIColor redColor];
        self.textFont = [UIFont systemFontOfSize:14.f];
    }
    return self;
}

#pragma mark - Custom Methods

- (void)drawImageContextWithPonit:(CGPoint)point {
    
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

- (NSArray *)getArrowPointsWithFinishPoint:(CGPoint)point { // 获取箭头俩个点的坐标
    
    NSMutableArray *arrowPonit = [NSMutableArray array];
    CGFloat distanceX = self.startPoint.x - point.x; // 起始点到结束点的X轴距离
    if (distanceX < 0) {
        distanceX = 0 - distanceX;
    }
    CGFloat distanceY = self.startPoint.y - point.y; // 起始点到结束点的Y轴距离
    if (distanceY < 0) {
        distanceY = 0 - distanceY;
    }
    CGFloat distanceLine = sqrt((distanceX * distanceX) + (distanceY * distanceY)); // 起始点到结束点的线长
    CGFloat distanceNodeToStartX = distanceX * (1 - kArrowSize / distanceLine); // 垂直节点到起始点的X轴距离
    CGFloat distanceNodeToStartY = distanceY * (1 - kArrowSize / distanceLine); // 垂直节点到起始点的Y轴距离
    
    CGFloat angleSin = distanceX / distanceLine; // 起始点到结束点连线与垂直线角度的sin值
    CGFloat angleCos = distanceY / distanceLine; // 起始点到结束点连线与垂直线角度的cos值
    
    CGFloat nodePonitX = 0; // 节点X坐标
    CGFloat nodePonitY = 0; // 节点Y坐标
    CGFloat firstPointX = 0;
    CGFloat firstPonitY = 0;
    CGFloat secondPointX = 0;
    CGFloat secondPointY = 0;
    
    if (self.startPoint.y > point.y) { // 区间1,2
        nodePonitY = self.startPoint.y - distanceNodeToStartY;
    } else { // 区间3,4
        nodePonitY = self.startPoint.y + distanceNodeToStartY;
    }
    if (self.startPoint.x > point.x) { // 区间1,3
        nodePonitX = self.startPoint.x - distanceNodeToStartX;
    } else { // 区间2,4
        nodePonitX = self.startPoint.x + distanceNodeToStartX;
    }
    
    if ((self.startPoint.x - point.x) * (self.startPoint.y - point.y) > 0) { // 区间1,4
        firstPointX = nodePonitX - angleCos * kArrowSize / 2;
        firstPonitY = nodePonitY + angleSin * kArrowSize / 2;
        secondPointX = nodePonitX + angleCos * kArrowSize / 2;
        secondPointY = nodePonitY - angleSin * kArrowSize / 2;
    } else {
        firstPointX = nodePonitX - angleCos * kArrowSize / 2;
        firstPonitY = nodePonitY - angleSin * kArrowSize / 2;
        secondPointX = nodePonitX + angleCos * kArrowSize / 2;
        secondPointY = nodePonitY + angleSin * kArrowSize / 2;
    }
    CGPoint firstPonit = CGPointMake(firstPointX, firstPonitY);
    CGPoint secondPoint = CGPointMake(secondPointX, secondPointY);
    [arrowPonit addObjectsFromArray:@[[NSValue valueWithCGPoint:firstPonit], [NSValue valueWithCGPoint:secondPoint]]];
    return arrowPonit;
}

- (void)addTextViewWithPoint:(CGPoint)point { // 添加textView
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.startPoint.x, self.startPoint.y, self.textFont.pointSize * 2, self.textFont.lineHeight)];
    textView.backgroundColor = [UIColor clearColor];
    textView.layer.borderColor = self.color.CGColor;
    textView.layer.borderWidth = 1;
    textView.font = self.textFont;
    textView.textColor = self.color;
    textView.textAlignment = NSTextAlignmentLeft;
    textView.delegate = self;
    [textView becomeFirstResponder];
    [self addSubview:textView];
    self.currentTextView = textView;
    [self scrollWindowWithTouchPoint:point];
}

- (void)scrollWindowWithTouchPoint:(CGPoint)ponit { // 根据点击屏幕的位置滚动window
    
    // 点击点到屏幕底部的高度
    CGFloat distancePointToBottom = SCREEN_KEY_WINDOW.height - ponit.y;
    if (distancePointToBottom < 270.f) {
        [UIView animateWithDuration:0.3 animations:^{
            SCREEN_KEY_WINDOW.top = - 200.f;
        }];
    }
}

- (BOOL)judgeTouchPonitCanDraw:(CGPoint)point {
    
    BOOL canDraw = CGRectContainsPoint(self.canDrawRect, point);

    return canDraw;
}

#pragma mark - Draw Image Methods

- (void)drawRectWithPoint:(CGPoint)point { // 画矩形
    
    UIGraphicsBeginImageContext(self.image.size);
    [self.image drawInRect:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, CGRectMake(self.startPoint.x * self.imageScale,
                                         self.startPoint.y * self.imageScale,
                                         (point.x - self.startPoint.x) * self.imageScale,
                                         (point.y - self.startPoint.y) * self.imageScale));
    [self.color setStroke];
    CGContextSetLineWidth(context, self.lineWidth * (self.image.size.width / self.width));
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)drawCircleWithPoint:(CGPoint)point { // 画圆形
    
    UIGraphicsBeginImageContext(self.image.size);
    [self.image drawInRect:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(self.startPoint.x * self.imageScale,
                                                  self.startPoint.y * self.imageScale,
                                                  (point.x - self.startPoint.x) * self.imageScale,
                                                  (point.y - self.startPoint.y) * self.imageScale));
    [self.color setStroke];
    CGContextSetLineWidth(context, self.lineWidth * (self.image.size.width / self.width));
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)drawArrowWithPoint:(CGPoint)point { // 画箭头
    
    UIGraphicsBeginImageContext(self.image.size);
    [self.image drawInRect:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, self.startPoint.x * self.imageScale, self.startPoint.y * self.imageScale);
    CGContextAddLineToPoint(context, point.x * self.imageScale, point.y * self.imageScale);
    NSArray *pointArray = [self getArrowPointsWithFinishPoint:point];
    CGPoint onePonit = [[pointArray objectAtIndex:0] CGPointValue];
    CGPoint twoPonit = [[pointArray objectAtIndex:1] CGPointValue];
    CGContextAddLineToPoint(context, onePonit.x * self.imageScale, onePonit.y * self.imageScale);
    CGContextMoveToPoint(context, point.x * self.imageScale, point.y * self.imageScale);
    CGContextAddLineToPoint(context, twoPonit.x * self.imageScale, twoPonit.y * self.imageScale);
    [self.color setStroke];
    CGContextSetLineWidth(context, self.lineWidth * (self.image.size.width / self.width));
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
- (void)drawLineWithPoint:(CGPoint)point { // 画线
    
    UIGraphicsBeginImageContext(self.image.size);
    [self.image drawInRect:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, self.movePoint.x * self.imageScale, self.movePoint.y * self.imageScale);
    CGContextAddLineToPoint(context, point.x * self.imageScale, point.y * self.imageScale);
    [self.color setStroke];
    CGContextSetLineWidth(context, self.lineWidth * (self.image.size.width / self.width));
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextDrawPath(context, kCGPathStroke);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.movePoint = point;
}

- (void)drawTextOnImageContext { // 画文字
    
    UIGraphicsBeginImageContext(self.image.size);
    [self.image drawInRect:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
    [self.currentTextView.text drawInRect:CGRectMake(self.currentTextView.left * self.imageScale,
                                              self.currentTextView.top * self.imageScale,
                                              self.currentTextView.width * self.imageScale,
                                              self.currentTextView.height * self.imageScale)
                    withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.currentTextView.font.pointSize * self.imageScale],
                                     NSForegroundColorAttributeName:self.color}];
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    self.originImage = self.image;
    [self.currentTextView removeFromSuperview];
    self.currentTextView = nil;
}

#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[touches allObjects] firstObject];
    CGPoint windowPoint = [touch locationInView:SCREEN_KEY_WINDOW];
    if (![self judgeTouchPonitCanDraw:windowPoint]) {
        return;
    }
    self.startPoint = [touch locationInView:self];
    self.movePoint = self.startPoint;
    
    if (LXToolButtonTypeText == self.type) {
        if (self.currentTextView.isFirstResponder) {
            [self.currentTextView resignFirstResponder];
        } else {
            [self addTextViewWithPoint:windowPoint];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[touches allObjects] firstObject];
    CGPoint point = [touch locationInView:self];
    CGPoint windowPoint = [touch locationInView:SCREEN_KEY_WINDOW];
    if (![self judgeTouchPonitCanDraw:windowPoint] || CGPointEqualToPoint(self.startPoint, CGPointZero)) {
        return;
    }
    [self drawImageContextWithPonit:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.startPoint = CGPointZero;
    self.originImage = self.image;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.startPoint = CGPointZero;
    self.originImage = self.image;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    NSLog(@"textViewDidBeginEditing");
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    NSLog(@"textViewDidEndEditing");
    if ([self.currentTextView.text isNotEmptyNSString]) {
        [self drawTextOnImageContext];
    } else {
        [self.currentTextView removeFromSuperview];
        self.currentTextView = nil;
    }
    SCREEN_KEY_WINDOW.top = 0;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    NSLog(@"textViewDidChange");
    CGSize textSize = [textView.text sizeWithAttributes:@{NSFontAttributeName:textView.font}];
    textView.width = textSize.width + textView.font.pointSize;
    textView.height = textSize.height;
}

#pragma mark - Setters

- (void)setZoomScale:(CGFloat)zoomScale {
    
    _zoomScale = zoomScale;
    if (self.image && self) {
        self.imageScale = zoomScale * (self.image.size.width / self.width);
    }
}

- (void)setType:(LXToolButtonType)type {
    
    _type = type;
    if (self.currentTextView.isFirstResponder) {
        [self.currentTextView resignFirstResponder];
    }
}

@end
