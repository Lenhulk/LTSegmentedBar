//
//  LTSegmentedBar.h
//  LTSegmentBar
//
//  Created by 零號叔叔 on 2017/10/3.
//  Copyright © 2017年 零號叔叔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTSegmentedBarConfig : NSObject

@property (nonatomic, strong) UIColor *segmentedBarBackgroundColor;

@property (nonatomic, strong) UIColor *itemNormalColor;
@property (nonatomic, strong) UIColor *itemSelectColor;
@property (nonatomic, strong) UIFont  *itemFont;

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, assign) CGFloat indicatorHeight;
@property (nonatomic, assign) CGFloat indicatorExtraW;

+ (instancetype)defaultConfig;
// 链式编程赋值
- (LTSegmentedBarConfig *(^)(UIColor *color))       lBackColor;
- (LTSegmentedBarConfig *(^)(UIColor *color))       lNormalColor;
- (LTSegmentedBarConfig *(^)(UIColor *color))       lSelectColor;
- (LTSegmentedBarConfig *(^)(UIFont *font))         lTitleFont;
- (LTSegmentedBarConfig *(^)(UIColor *color))       lIndicatorColor;
- (LTSegmentedBarConfig *(^)(CGFloat height))       lIndicatorH;
- (LTSegmentedBarConfig *(^)(CGFloat extraWidth))   lIndicatorExtraW;

@end


@class LTSegmentedBar;
@protocol LTSegmentedBarDelegate <NSObject>

/**
 代理方法, 将内部的点击数据传递给外部
 
 @param segmentedBar    segmentedBar
 @param toIndex         选中的索引(从0开始)
 @param fromIndex       上一个索引
 */
- (void)segmentBar: (LTSegmentedBar *)segmentedBar didSelectIndex: (NSInteger)toIndex fromIndex: (NSInteger)fromIndex;

@end


@interface LTSegmentedBar : UIView

@property (nonatomic, weak) id<LTSegmentedBarDelegate> delegate;
/** 数据源 */
@property (nonatomic, strong) NSArray <NSString *>*items;
/** 当前选中的索引, 双向设置 */
@property (nonatomic, assign) NSInteger selectedIndex;

+ (LTSegmentedBar *)segmentedBarWithFrame:(CGRect)frame;
- (void)updateWithConfig: (void(^)(LTSegmentedBarConfig *config))configBlock;

@end



