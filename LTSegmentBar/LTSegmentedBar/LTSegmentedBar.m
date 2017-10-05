//
//  LTSegmentedBar.m
//  LTSegmentBar
//
//  Created by 零號叔叔 on 2017/10/3.
//  Copyright © 2017年 零號叔叔. All rights reserved.
//

#import "LTSegmentedBar.h"
#import "UIView+LTSegmentedBar.h"

#pragma mark - LTSegmentedBarConfig

@implementation LTSegmentedBarConfig

+ (instancetype)defaultConfig
{
    LTSegmentedBarConfig *config = [[LTSegmentedBarConfig alloc] init];
    
    config.segmentedBarBackgroundColor = [UIColor clearColor];
    config.itemFont = [UIFont fontWithName:@"Lato-Regular" size:14];
    config.itemNormalColor = [UIColor lightGrayColor];
    config.itemSelectColor = [UIColor redColor];
    
    config.indicatorColor = [UIColor redColor];
    config.indicatorHeight = 1;
    config.indicatorExtraW = 10;
    
    return config;
}

- (LTSegmentedBarConfig *(^)(UIColor *))lBackColor{
    return ^(UIColor *color){
        self.segmentedBarBackgroundColor = color;
        return self;
    };
}
- (LTSegmentedBarConfig *(^)(UIColor *))lNormalColor{
    return ^(UIColor *color){
        self.itemNormalColor = color;
        return self;
    };
}
- (LTSegmentedBarConfig *(^)(UIColor *))lSelectColor{
    return ^(UIColor *color){
        self.itemSelectColor = color;
        return self;
    };
}
- (LTSegmentedBarConfig *(^)(UIFont *))lTitleFont{
    return ^(UIFont *font){
        self.itemFont = font;
        return self;
    };
}
- (LTSegmentedBarConfig *(^)(UIColor *))lIndicatorColor{
    return ^(UIColor *color){
        self.indicatorColor = color;
        return self;
    };
}
- (LTSegmentedBarConfig *(^)(CGFloat))lIndicatorH{
    return ^(CGFloat height){
        self.indicatorHeight = height;
        return self;
    };
}
- (LTSegmentedBarConfig *(^)(CGFloat))lIndicatorExtraW{
    return ^(CGFloat extraWidth){
        self.indicatorExtraW = extraWidth;
        return self;
    };
}

@end


#pragma mark - LTSegmentedBar

#define kMinMargin 20

@interface LTSegmentedBar ()
{
    UIButton *_lastSelBtn;  // 上一次点击的按钮
}
/** SegmentedBar配置 */
@property (nonatomic, strong) LTSegmentedBarConfig *config;
/** 内容承载视图 */
@property (nonatomic, weak) UIScrollView *contentView;
/** 添加的按钮数据 */
@property (nonatomic, strong) NSMutableArray <UIButton *>*itemBtns;
/** 指示器 */
@property (nonatomic, weak) UIView *indicatorView;
@end

#pragma mark SET UP

@implementation LTSegmentedBar

+ (LTSegmentedBar *)segmentedBarWithFrame:(CGRect)frame
{
    LTSegmentedBar *segBar = [[LTSegmentedBar alloc] initWithFrame:frame];
    return segBar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = self.config.segmentedBarBackgroundColor;
    }
    return self;
}

- (void)updateWithConfig:(void (^)(LTSegmentedBarConfig *))configBlock
{
    if (configBlock) {
        configBlock(self.config);
    }
    for (UIButton *btn in self.itemBtns) {
        [btn setTitleColor:self.config.itemNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.config.itemFont;
    }
    [self setBackgroundColor:self.config.segmentedBarBackgroundColor];
    [self.indicatorView setBackgroundColor:self.config.indicatorColor];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setItems:(NSArray<NSString *> *)items
{
    _items = items;
    
    [self.itemBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemBtns = nil;
    
    for (NSString *item in items) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = self.itemBtns.count;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [btn setTitleColor:self.config.itemNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.config.itemFont;
        [btn setTitle:item forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [self.itemBtns addObject:btn];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (self.itemBtns.count == 0 || selectedIndex < 0 || selectedIndex > self.itemBtns.count - 1) {
        return;
    }
    _selectedIndex = selectedIndex;
    UIButton *btn = self.itemBtns[selectedIndex];
    [self btnClick:btn];
}


#pragma mark ACTION & LAYOUT

- (void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(segmentBar:didSelectIndex:fromIndex:)]) {
        [self.delegate segmentBar:self didSelectIndex:btn.tag fromIndex:_lastSelBtn.tag];
    }

    _selectedIndex = btn.tag;
    _lastSelBtn.selected = NO;
    btn.selected = YES;
    _lastSelBtn = btn;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.indicatorView.width = btn.width + self.config.indicatorExtraW * 2;
        self.indicatorView.centerX = btn.centerX;
    }];
    
    CGFloat scrollX = btn.centerX - self.contentView.width * 0.5;
    if (scrollX < 0) {
        scrollX = 0;
    }
    if (scrollX > self.contentView.contentSize.width - self.contentView.width) {
        scrollX = self.contentView.contentSize.width - self.contentView.width;
    }
    
    [self.contentView setContentOffset:CGPointMake(scrollX, 0) animated:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    
    // 计算margin
    CGFloat totalBtnWidth = 0;
    for (UIButton *btn in self.itemBtns) {
        [btn sizeToFit];
        totalBtnWidth += btn.width;
    }
    
    CGFloat caculateMargin = (self.width - totalBtnWidth) / (self.items.count + 1);
    if (caculateMargin < kMinMargin) {
        caculateMargin = kMinMargin;
    }
    
    
    CGFloat lastX = caculateMargin;
    for (UIButton *btn in self.itemBtns) {
        // w, h
        [btn sizeToFit];
        // y 0
        // x, y,
        btn.y = 0;
        btn.x = lastX;
        lastX += btn.width + caculateMargin;
    }
    
    self.contentView.contentSize = CGSizeMake(lastX, 0);
    
    if (self.itemBtns.count == 0) {
        return;
    }
    UIButton *btn = self.itemBtns[self.selectedIndex];
    self.indicatorView.width = btn.width + self.config.indicatorExtraW * 2;
    self.indicatorView.centerX = btn.centerX;
    self.indicatorView.height = self.config.indicatorHeight;
    self.indicatorView.y = self.height - self.indicatorView.height;
}


#pragma mark LAZY LOAD

- (NSMutableArray<UIButton *> *)itemBtns {
    if (!_itemBtns) {
        _itemBtns = [NSMutableArray array];
    }
    return _itemBtns;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        CGFloat indicatorH = self.config.indicatorHeight;
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - indicatorH, 0, indicatorH)];
        indicatorView.backgroundColor = self.config.indicatorColor;
        [self.contentView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        _contentView = scrollView;
    }
    return _contentView;
}

- (LTSegmentedBarConfig *)config {
    if (!_config) {
        _config = [LTSegmentedBarConfig defaultConfig];
    }
    return _config;
}



@end
