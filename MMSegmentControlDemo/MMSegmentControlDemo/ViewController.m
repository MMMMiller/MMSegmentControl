//
//  ViewController.m
//  MMSegmentControlDemo
//
//  Created by xueMingLuan on 2018/3/5.
//  Copyright © 2018年 mille. All rights reserved.
//

#import "ViewController.h"
#import "MMSegmentControl.h"
#import "BViewController.h"
#import <Masonry.h>

@interface ViewController ()<MMSegmentControlDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BViewController *vc1 = [BViewController new];
    vc1.view.backgroundColor = [UIColor yellowColor];
    
    BViewController *vc2 = [BViewController new];
    vc2.view.backgroundColor = [UIColor whiteColor];
    
    BViewController *vc3 = [BViewController new];
    vc3.view.backgroundColor = [UIColor lightGrayColor];
    
    BViewController *vc4 = [BViewController new];
    vc4.view.backgroundColor = [UIColor redColor];
    
    CGRect frame = CGRectMake(0, 88, self.view.bounds.size.width, self.view.bounds.size.height - 88);
    MMSegmentControl *control = [[MMSegmentControl alloc] initWithFrame:frame
                                                            controllers:@[vc1, vc2, vc3, vc4]
                                                                 titles:@[@"标题1",@"标题2",@"标题3",@"标题4"]
                                                               delegate:self
                                                              initIndex:2
                                                             headHeight:40
                                                           sgementWidth:200
                                                           selectorSize:CGSizeMake(40, 5)
                                                       selectorToBottom:2
                                                          selectedColor:[UIColor blackColor]
                                                        unSelectedColor:[UIColor darkGrayColor]];
    
    [self.view addSubview:control];
}

- (void)segmentControl:(MMSegmentControl *)segmentControl viewDidAppearAtIndex:(NSUInteger)index {
    NSLog(@"index = %zd", index);
}
@end
