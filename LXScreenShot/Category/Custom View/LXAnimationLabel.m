//
//  LXAnimationLabel.m
//  LXScreenShot
//
//  Created by Leexin on 16/4/26.
//  Copyright © 2016年 Garden.Lee. All rights reserved.
//

#import "LXAnimationLabel.h"

static const CGFloat kLayerDorpHeight = 100.f;

/*
 大概思路:使用TextKit进行文字布局排版,一个文字就是一个CATextLayer,然后将TextKit的文字排版设置给每个CATextLayer,最好对每个CATextLayer进行动画处理.
 TextKit主要类：
 NSTextStorage : 文字内容信息类
 NSLayoutManager : 控制类
 NSTextContainer : 布局类
*/

@interface LXAnimationLabel () <NSLayoutManagerDelegate>

@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;

@property (nonatomic, strong) NSMutableArray *oldTextLayerArray;
@property (nonatomic, strong) NSMutableArray *currentTextLayerArray;

@end

@implementation LXAnimationLabel

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    [self.textStorage addLayoutManager:self.layoutManager];
    [self.layoutManager addTextContainer:self.textContainer];
    self.oldTextLayerArray = [NSMutableArray array];
    self.currentTextLayerArray = [NSMutableArray array];
}

#pragma mark - Custom Methods

- (void)resetTextLayerIntoArray { // 重置TextLayer
    
    [self.currentTextLayerArray removeAllObjects];
    
    CGRect layoutRect = [self.layoutManager usedRectForTextContainer:self.textContainer];
    for (int i = 0; i < self.textStorage.string.length; i++) {
        
        NSRange range = NSMakeRange(i, 1);
        NSRange characterRange = [self.layoutManager characterRangeForGlyphRange:range actualGlyphRange:nil];
        NSTextContainer *aTextContainer = [self.layoutManager textContainerForGlyphAtIndex:i effectiveRange:nil];
        CGRect rect = [self.layoutManager boundingRectForGlyphRange:range inTextContainer:aTextContainer];
        rect.origin.y += ((self.bounds.size.height / 2) - (layoutRect.size.height / 2));
        
        rect.origin.y -= kLayerDorpHeight;
        
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.frame = rect;
        textLayer.string = [[self getAttributedString] attributedSubstringFromRange:characterRange];
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.opacity = 0;
        
        [self.layer addSublayer:textLayer];
        [self.currentTextLayerArray addObject:textLayer];
    }
}

- (void)removeOldTextLayer { // 移除旧的TextLayer
    
    for (CATextLayer *textLayer in self.oldTextLayerArray) {
        [textLayer removeFromSuperlayer];
    }
    [self.oldTextLayerArray removeAllObjects];
}

- (NSMutableAttributedString *)getAttributedString {
    
    NSRange range = NSMakeRange(0, self.textStorage.string.length);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.textStorage.string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignment;
    [attributedString addAttributes:@{NSFontAttributeName: self.font,
                                      NSForegroundColorAttributeName: self.textColor,
                                      NSParagraphStyleAttributeName: paragraphStyle}
                              range:range];
    return attributedString;
}

#pragma mark - Animation Methods

- (void)textLayerAnimation {
    
    for (CALayer *aLayer in self.currentTextLayerArray) {
    
        NSInteger delay = arc4random()%300 + 100;
        dispatch_time_t when = dispatch_time (DISPATCH_TIME_NOW, (int64_t)delay * NSEC_PER_MSEC);
        
        dispatch_after(when, dispatch_get_main_queue(), ^{
            CABasicAnimation *opacityAnimation = [CABasicAnimation animation];
            opacityAnimation.keyPath = @"opacity";
            opacityAnimation.toValue = [NSNumber numberWithFloat:1.0];
            
            CABasicAnimation *positionAnimation = [CABasicAnimation animation];
            positionAnimation.keyPath = @"position.y";
            positionAnimation.toValue = [NSNumber numberWithFloat:aLayer.position.y + kLayerDorpHeight];
            
            CGFloat angle = (arc4random() % 200) * M_PI / 180.f;
            CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, 1);
            CABasicAnimation *transformAnimation = [CABasicAnimation animation];
            transformAnimation.keyPath = @"transform";
            transformAnimation.fromValue = [NSValue valueWithCATransform3D:transform];
            transformAnimation.toValue = [NSValue valueWithCATransform3D:aLayer.transform];
            
            CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
            animationGroup.animations = @[opacityAnimation, positionAnimation, transformAnimation];
            animationGroup.duration = 1.2 - delay / 1000;
            animationGroup.removedOnCompletion = NO;
            animationGroup.fillMode = kCAFillModeForwards;
            
            [aLayer addAnimation:animationGroup forKey:nil];
        });
    }
}

#pragma mark - NSLayoutManagerDelegate

/* 当 TextStorage 的文本内容改变时，会触发一个通知 send textLayoutManager 以便重新布局排版。
   此代理方法为布局结束调用的方法
 */
- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag {
    
    [self resetTextLayerIntoArray];
    NSLog(@"%@",self.textStorage.string);
}

#pragma mark - Setters

- (void)setText:(NSString *)text {
    
    if (!text) {
        text = @"";
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = NSMakeRange(0, text.length);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignment;
    [attributedString addAttributes:@{NSFontAttributeName: self.font,
                                      NSForegroundColorAttributeName: self.textColor,
                                      NSParagraphStyleAttributeName: paragraphStyle}
                              range:range];
    self.attributedText = attributedString;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    
    // 替换数组中的CATextLayer
    [self removeOldTextLayer];
    [self.oldTextLayerArray addObjectsFromArray:self.currentTextLayerArray];

    [self.textStorage setAttributedString:attributedText];
    
    [self textLayerAnimation];
}

- (void)setTextColor:(UIColor *)textColor {
    
    [super setTextColor:textColor];
    // 为了调用setText 重新设置下颜色
    self.text = self.textStorage.string;
}

- (void)setBounds:(CGRect)bounds {
    
    [super setBounds:bounds];
    self.textContainer.size = bounds.size;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    [super setLineBreakMode:lineBreakMode];
    self.textContainer.lineBreakMode = lineBreakMode;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    
    [super setNumberOfLines:numberOfLines];
    self.textContainer.maximumNumberOfLines = numberOfLines;
}

#pragma mark - Getters

- (NSString *)text {
    
    return self.textStorage.string;
}

- (NSAttributedString *)attributedText {
    
    return (NSAttributedString *)self.textStorage;
}

- (NSTextStorage *)textStorage {
    
    if (!_textStorage) {
        _textStorage = [[NSTextStorage alloc] initWithString:@""];
    }
    return _textStorage;
}

- (NSLayoutManager *)layoutManager {
    
    if (!_layoutManager) {
        _layoutManager = [[NSLayoutManager alloc] init];
        _layoutManager.delegate = self;
    }
    return _layoutManager;
}

- (NSTextContainer *)textContainer {
    
    if (!_textContainer) {
        _textContainer = [[NSTextContainer alloc] init];
        _textContainer.size = self.bounds.size;
        _textContainer.maximumNumberOfLines = self.numberOfLines;
        _textContainer.lineBreakMode = self.lineBreakMode;
    }
    return _textContainer;
}


@end
