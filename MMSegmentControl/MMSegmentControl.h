//
//  MMSegmentControl.h
//  MMSegmentControlDemo
//
//  Created by xueMingLuan on 2018/3/5.
//  Copyright © 2018年 mille. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMSegmentControl;
@protocol MMSegmentControlDelegate <NSObject>

/**
 在第index个界面停下了滚动
 */
- (void)segmentControl:(MMSegmentControl *)segmentControl viewDidAppearAtIndex:(NSUInteger)index;

@end

@interface MMSegmentControl : UIViewController
/**
 代理
 */
@property (nonatomic, weak) id<MMSegmentControlDelegate> delegate;

/**
 初始化方法
 
 @param controller 子控制器
 @param title 控制器标题 ，title数量需要与controler数量保持一致
 @return slider控制器
 */
- (instancetype)initWithControllers:(NSArray *)controller
                             titles:(NSArray *)title;

/**
 初始化方法
 
 @param controller 子控制器
 @param title 控制器标题 ，title数量需要与controler数量保持一致
 @return slider控制器
 */
- (instancetype)initWithControllers:(NSArray *)controller
                             titles:(NSArray *)title
                         firstIndex:(NSUInteger)firstIndex;
/**
 承载视图
 如果修改了headerView的frame，需要同时修改collectionView的frame
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 头视图
 头视图包含segmentView ,默认为segmentView高度（60）
 如果修改了headerView的frame，子视图中如果包含tableview需要修改contentInset
 */
@property (nonatomic, strong) UIView *headerView;

/**
 滑动条
 默认宽度 60 高度2
 
 修改宽度高度或者距离底部高度需要重新计算frame
 x:(BM_SCREEN_WIDTH / titles.count - width) / 2 【 BM_SCREEN_WIDTH:屏幕宽度  titles.count:传入标签或者controller的个数 width:修改的宽度 】
 y:segmentView.frame.height - height 【segmentView.frame.height:segmentView的高度 height:修改的高度】
 width:width    【width：修改的宽度】
 height:height  【height:修改的高度】
 */
@property (nonatomic, strong) UIView *selectionBarView;

/**
 保存segment按钮的数组
 可遍历修改button属性
 */
@property (nonatomic, strong) NSMutableArray *buttonArray;

/**
 子控制器
 */
@property (nonatomic, strong) NSMutableArray *controllers;

@end
