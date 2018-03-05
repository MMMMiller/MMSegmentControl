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

@interface ViewController ()

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
    
    MMSegmentControl *control = [[MMSegmentControl alloc] initWithControllers:@[vc1, vc2, vc3, vc4] titles:@[@"标题1",@"标题2",@"标题3",@"标题4"]  firstIndex:2];
    
    [self.view addSubview:control.view];
    [control.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(88);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self addChildViewController:control];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
