//
//  LTSegmentedBarViewController.m
//  LTSegmentBar
//
//  Created by 零號叔叔 on 2017/10/3.
//  Copyright © 2017年 零號叔叔. All rights reserved.
//

#import "LTSegmentedBarViewController.h"
#import "UIView+LTSegmentedBar.h"

@interface LTSegmentedBarViewController () <LTSegmentedBarDelegate, UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *contentView;
@end

@implementation LTSegmentedBarViewController

- (LTSegmentedBar *)segmentedBar {
    if (!_segmentedBar) {
        LTSegmentedBar *segmentBar = [LTSegmentedBar segmentedBarWithFrame:CGRectZero];
        segmentBar.delegate = self;
        segmentBar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:segmentBar];
        _segmentedBar = segmentBar;
        
    }
    return _segmentedBar;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        UIScrollView *contentView = [[UIScrollView alloc] init];
        contentView.delegate = self;
        contentView.pagingEnabled = YES;
        [self.view addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpWithItems:(NSArray<NSString *> *)items childViewControllers:(NSArray<UIViewController *> *)childVCs
{
    NSAssert(items.count != 0 || items.count == childVCs.count, @"item和viewController的个数不一致！");
    
    self.segmentedBar.items = items;
    
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    
    for (UIViewController *vc in childVCs) {
        [self addChildViewController:vc];
    }
    self.contentView.contentSize = CGSizeMake(items.count * self.view.width, 0);
    
    self.segmentedBar.selectedIndex = 0;
}


- (void)showChildVCViewsAtIndex: (NSInteger)index {
    
    if (self.childViewControllers.count == 0 || index < 0 || index > self.childViewControllers.count - 1) {
        return;
    }
    
    UIViewController *vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(index * self.contentView.width, 0, self.contentView.width, self.contentView.height);
    [self.contentView addSubview:vc.view];
    
    // 滚动到对应的位置
    [self.contentView setContentOffset:CGPointMake(index * self.contentView.width, 0) animated:YES];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (self.segmentedBar.superview == self.view) {
        self.segmentedBar.frame = CGRectMake(0, 60, self.view.width, 35);
        
        CGFloat contentViewY = self.segmentedBar.y + self.segmentedBar.height;
        CGRect contentFrame = CGRectMake(0, contentViewY, self.view.width, self.view.height - contentViewY);
        self.contentView.frame = contentFrame;
        self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 0);
        
        return;
    }
    
    CGRect contentFrame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.contentView.frame = contentFrame;
    self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 0);
    
    self.segmentedBar.selectedIndex = self.segmentedBar.selectedIndex;
}


#pragma mark LTSegmentedBarDelegate

- (void)segmentBar:(LTSegmentedBar *)segmentedBar didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    [self showChildVCViewsAtIndex:toIndex];
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = self.contentView.contentOffset.x / self.contentView.width;
    
    //    [self showChildVCViewsAtIndex:index];
    self.segmentedBar.selectedIndex = index;
    
}





@end
