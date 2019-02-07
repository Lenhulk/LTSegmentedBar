//
//  ViewController.m
//  LTSegmentBar
//
//  Created by 零號叔叔 on 2017/10/3.
//  Copyright © 2017年 零號叔叔. All rights reserved.
//

#import "ViewController.h"
#import "LTSegmentedBarViewController.h"

@interface ViewController ()
@property (nonatomic, weak) LTSegmentedBarViewController *segBarVC;
@end

@implementation ViewController

- (LTSegmentedBarViewController *)segBarVC{
    if (!_segBarVC)
    {
        LTSegmentedBarViewController *segBarVC = [[LTSegmentedBarViewController alloc] init];
        
        segBarVC.segmentedBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35);
        self.navigationItem.titleView = segBarVC.segmentedBar;
        
        segBarVC.view.frame = self.view.frame;
        [self addChildViewController:segBarVC];
        [self.view addSubview:segBarVC.view];
        _segBarVC = segBarVC;
    }
    return  _segBarVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSArray *items = @[@"HelloWorld", @"Josephine", @"Lenhulk", @"走过路过给个star", @"大石碎胸口", @"飞天茅台"];
        
        UIViewController *vc1 = [UIViewController new];
        vc1.view.backgroundColor = [UIColor redColor];
        
        UIViewController *vc2 = [UIViewController new];
        vc2.view.backgroundColor = [UIColor greenColor];
        
        UIViewController *vc3 = [UIViewController new];
        vc3.view.backgroundColor = [UIColor yellowColor];
        
        UIViewController *vc4 = [UIViewController new];
        vc4.view.backgroundColor = [UIColor purpleColor];
        
        UIViewController *vc5 = [UIViewController new];
        vc5.view.backgroundColor = [UIColor blueColor];
        
        UIViewController *vc6 = [UIViewController new];
        vc6.view.backgroundColor = [UIColor brownColor];
        
        
        // Setup Title and VC here
        [self.segBarVC setUpWithItems:items childViewControllers:@[vc1, vc2, vc3, vc4, vc5, vc6]];
        
        // Setup SegmentedBar Configuration here
        [self.segBarVC.segmentedBar updateWithConfig:^(LTSegmentedBarConfig *config) {
            
            // 普通赋值
//            config.itemNormalColor = [UIColor brownColor];
//            config.itemSelectColor = [UIColor yellowColor];
//            config.itemFont = [UIFont fontWithName:@"Zapfino" size:14];
//            config.indicatorHeight = 2;
//            config.indicatorColor = [UIColor yellowColor];
//            config.indicatorExtraW = 10;
            
            // 链式编程
            config.lNormalColor([UIColor whiteColor]).lSelectColor([UIColor orangeColor]).lIndicatorColor([UIColor orangeColor]).lIndicatorH(2.0).lIndicatorExtraW(8).lBackColor([UIColor lightGrayColor]);
            
        }];
        
        
    });
}


@end
