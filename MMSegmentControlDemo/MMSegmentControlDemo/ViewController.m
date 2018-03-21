//
//  ViewController.m
//  MMSegmentControlDemo
//
//  Created by xueMingLuan on 2018/3/5.
//  Copyright © 2018年 mille. All rights reserved.
//

#import "ViewController.h"
#import "MMSegmentControl.h"
#import <Masonry.h>

@interface ViewController ()<MMSegmentControlDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *vc1 = [UIViewController new];
    vc1.view.backgroundColor = [UIColor yellowColor];
    
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = [UIColor whiteColor];
    
    UIViewController *vc3 = [UIViewController new];
    vc3.view.backgroundColor = [UIColor lightGrayColor];
    
    UIViewController *vc4 = [UIViewController new];
    vc4.view.backgroundColor = [UIColor redColor];
    
    CGRect frame = CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height - 88);
    MMSegmentControl *control = [[MMSegmentControl alloc] initWithFrame:frame
                                                            controllers:@[vc1, vc2, vc3, vc4]
                                                                 titles:@[@"标题1",@"标题2",@"标题3",@"标题4"]
                                                              initIndex:2
                                                             headHeight:40
                                                           sgementWidth:200
                                                           selectorSize:CGSizeMake(40, 5)
                                                       selectorToBottom:2
                                                          selectedColor:[UIColor blackColor]
                                                        unSelectedColor:[UIColor darkGrayColor]];
    
    control.delegate = self;
    [self addChildViewController:control];
    [self.view addSubview:control.view];
}

- (void)segmentControl:(MMSegmentControl *)segmentControl viewDidAppearAtIndex:(NSUInteger)index {
    NSLog(@"点了index ： %zd", index);
}


@end
