//
//  LTSegmentedBarViewController.h
//  LTSegmentBar
//
//  Created by 零號叔叔 on 2017/10/3.
//  Copyright © 2017年 零號叔叔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSegmentedBar.h"

@interface LTSegmentedBarViewController : UIViewController

@property (nonatomic, strong) LTSegmentedBar *segmentedBar;

- (void)setUpWithItems: (NSArray <NSString *>*)items childViewControllers: (NSArray <UIViewController *>*)childVCs;

@end
