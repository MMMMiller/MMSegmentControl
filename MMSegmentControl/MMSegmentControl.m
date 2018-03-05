//
//  MMSegmentControl.m
//  MMSegmentControlDemo
//
//  Created by xueMingLuan on 2018/3/5.
//  Copyright © 2018年 mille. All rights reserved.
//

#import "MMSegmentControl.h"
#import <Masonry/Masonry.h>

#define MMSegmentHeight 32

@interface MMSegmentBtn : UIButton

+ (instancetype)segmentBtnWithTitle:(NSString *)title
                              index:(NSUInteger)index;

@end

@implementation MMSegmentBtn

+ (instancetype)segmentBtnWithTitle:(NSString *)title index:(NSUInteger)index {
    MMSegmentBtn *button = [MMSegmentBtn buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.75] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    button.tag = index;
    button.selected = (index == 0);
    return button;
}

@end

@interface MMSegmentControl () <UICollectionViewDataSource, UICollectionViewDelegate>{
    NSInteger _selectedIndex;
    NSUInteger _preIndex;
    NSUInteger _firstIndex;
}

@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation MMSegmentControl

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = NO;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_firstIndex) {
        [self selectedButtonAtIndex:_firstIndex];
        _firstIndex = 0;
    }
    if ([self.delegate respondsToSelector:@selector(segmentControl:viewDidAppearAtIndex:)]) {
        [self.delegate segmentControl:self viewDidAppearAtIndex:_selectedIndex];
    }
}

- (instancetype)initWithControllers:(NSArray *)controller titles:(NSArray *)title firstIndex:(NSUInteger)firstIndex {
    if (self = [super init]) {
        NSAssert(controller.count == title.count, @"controller & title not the same count");
        _firstIndex = firstIndex;
        _preIndex = firstIndex;
        self.controllers = [[NSMutableArray alloc] init];
        self.titles = [[NSMutableArray alloc] init];
        self.buttonArray = [[NSMutableArray alloc]init];
        
        [self.controllers addObjectsFromArray:controller];
        [self.titles addObjectsFromArray:title];
        [self setUpHeaderView];
        [self setUpCollectionView];
    }
    return self;
}

- (instancetype)initWithControllers:(NSArray *)controller titles:(NSArray *)title{
    return [self initWithControllers:controller titles:title firstIndex:0];
}

- (void)setUpCollectionView{
    //-- Create Flow Layout
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //-- Create Collection View
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:flowLayout];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"controllers"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(MMSegmentHeight);
    }];
    
}

- (void)setUpHeaderView{
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(MMSegmentHeight);
    }];
    
    NSInteger nums = [self.titles count];
    MMSegmentBtn *preBtn = nil;
    for (int i = 0; i< nums; i++) {
        MMSegmentBtn *button = [MMSegmentBtn segmentBtnWithTitle:[self.titles objectAtIndex:i] index:i];
        [button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:button];
        [self.buttonArray addObject:button];
        CGFloat btnWidth = self.view.frame.size.width / nums;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(_headerView);
            } else {
                make.left.equalTo(preBtn.mas_right);
            }
            make.top.height.equalTo(_headerView);
            make.width.mas_equalTo(btnWidth);
        }];
        preBtn = button;
    }
    
    [self setupSelector];
}

- (void)setupSelector {
    CGFloat selectorWidth = 60;
    CGFloat selectorHeight = 2;
    CGFloat xOffset = ([UIScreen mainScreen].bounds.size.width / self.titles.count - selectorWidth) / 2;
    self.selectionBarView = [[UIView alloc] init];
    self.selectionBarView.backgroundColor = [UIColor yellowColor];
    [_headerView addSubview:self.selectionBarView];
    [_selectionBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(selectorWidth, selectorHeight));
        make.left.equalTo(_headerView).offset(xOffset);
        make.bottom.equalTo(_headerView);
    }];
}


- (void)selectedButtonAtIndex:(NSInteger)index{
    [self buttonSelectAction:index];
    if (_selectedIndex != index) {
        _selectedIndex = index;
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}


- (void)clickedButton:(id)sender{
    [self selectedButtonAtIndex:((UIButton *)sender).tag];
    
}

- (void)buttonSelectAction:(NSInteger)index{
    for (UIButton  *button in self.buttonArray) {
        if(button.selected)button.selected = NO;
        if(button.tag ==index)button.selected = YES;
    }
    
    if (index != _preIndex) {   //说明用户在的操作并没有改变当前显示的界面
        if ([self.delegate respondsToSelector:@selector(segmentControl:viewDidAppearAtIndex:)]) {
            [self.delegate segmentControl:self viewDidAppearAtIndex:index];
        }
        _preIndex = index;
    }
}
#pragma mark collection view delegate and data source methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.controllers.count;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(_collectionView.frame.size.width, _collectionView.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"controllers" forIndexPath:indexPath];
    if ([[self.controllers objectAtIndex:indexPath.row] isKindOfClass:[UIViewController class]]) {
        UIViewController *controller = [self.controllers objectAtIndex:indexPath.row];
        controller.view.frame = CGRectMake(0, 0, _collectionView.frame.size.width, _collectionView.frame.size.height);
        controller.view.tag = 10001;
        NSArray *cellSubView = [cell.contentView.subviews mutableCopy];
        for (UIView *view in cellSubView) {
            if (view.tag == 10001) {
               [view removeFromSuperview];
            }
        }
        
        [cell.contentView addSubview:controller.view];
    }
    return cell;
}

//界面滚动中， 将指示器同步滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([scrollView isKindOfClass:[UICollectionView class]]){
        CGFloat xoffset = scrollView.contentOffset.x;
        CGFloat length = [UIScreen mainScreen].bounds.size.width /self.titles.count;
        CGFloat x = xoffset/[UIScreen mainScreen].bounds.size.width *length + (length - 60) / 2 ;
        
        [_selectionBarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(x);
        }];
    }
}

//用户停止了操作
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if([scrollView isKindOfClass:[UICollectionView class]]){
        CGFloat xoffset = scrollView.contentOffset.x;
        NSUInteger index = xoffset/[UIScreen mainScreen].bounds.size.width;
        _selectedIndex = index;
        [self buttonSelectAction:index];
    }
}


@end
