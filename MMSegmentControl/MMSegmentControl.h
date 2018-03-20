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

@interface MMSegmentControl : UIViewController

@property (nonatomic, weak) id<MMSegmentControlDelegate> delegate;

@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, strong) UIColor *unSelectedColor;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIView *segmentView;

@property (nonatomic, strong) UIView *selectorBar;

@property (nonatomic, strong) NSMutableArray *controllers;

- (instancetype)initWithControllers:(NSArray *)controller
                             titles:(NSArray *)title;

- (instancetype)initWithControllers:(NSArray *)controller
                             titles:(NSArray *)title
                          initIndex:(NSUInteger)initIndex;

- (instancetype)initWithFrame:(CGRect)frame
                  controllers:(NSArray *)controller
                       titles:(NSArray *)title
                    initIndex:(NSUInteger)firstIndex
                   headHeight:(CGFloat)headHeight
                 sgementWidth:(CGFloat)sgementWidth
                 selectorSize:(CGSize)selectorSize
             selectorToBottom:(CGFloat)selectorToBottom
                selectedColor:(UIColor *)selectedColor
              unSelectedColor:(UIColor *)unSelectedColor;
@end
