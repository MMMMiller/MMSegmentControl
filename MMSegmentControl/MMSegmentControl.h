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

- (void)segmentControl:(MMSegmentControl *)segmentControl viewDidAppearAtIndex:(NSUInteger)index;

@end

@protocol MMSegmentControlChildVCDelegate <NSObject>

- (void)viewInChildViewControllerWillAppear;

@end

@interface MMSegmentControl : UIView

@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, strong) UIColor *unSelectedColor;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIView *segmentView;

@property (nonatomic, strong) UIView *selectorBar;

@property (nonatomic, strong) NSMutableArray *controllers;

- (instancetype)initWithFrame:(CGRect)frame
                  controllers:(NSArray<UIViewController<MMSegmentControlChildVCDelegate> *> *)controller
                       titles:(NSArray *)title
                     delegate:(UIViewController<MMSegmentControlDelegate> *)delegate
                    initIndex:(NSUInteger)firstIndex
                   headHeight:(CGFloat)headHeight
                 sgementWidth:(CGFloat)sgementWidth
                 selectorSize:(CGSize)selectorSize
             selectorToBottom:(CGFloat)selectorToBottom
                selectedColor:(UIColor *)selectedColor
              unSelectedColor:(UIColor *)unSelectedColor;
@end
