//
//  BViewController.m
//  MMSegmentControlDemo
//
//  Created by xueMingLuan on 2018/3/22.
//  Copyright © 2018年 mille. All rights reserved.
//

#import "BViewController.h"

@interface BViewController ()

@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSLog(@"已出现");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[self.class new] animated:YES];
}

- (void)viewInChildViewControllerWillAppear {
    NSLog(@"要出现");
}

@end
