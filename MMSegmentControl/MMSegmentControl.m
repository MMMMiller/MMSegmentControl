//
//  MMSegmentControl.m
//  MMSegmentControlDemo
//
//  Created by xueMingLuan on 2018/3/5.
//  Copyright © 2018年 mille. All rights reserved.
//

#import "MMSegmentControl.h"
#import <Masonry/Masonry.h>

@interface MMSegmentBtn : UIButton

+ (instancetype)segmentBtnWithTitle:(NSString *)title
                              index:(NSUInteger)index
                      selectedColor:(UIColor *)selectedColor
                    unSelectedColor:(UIColor *)unSelectedColor;

@end

@implementation MMSegmentBtn

+ (instancetype)segmentBtnWithTitle:(NSString *)title
                              index:(NSUInteger)index
                      selectedColor:(UIColor *)selectedColor
                    unSelectedColor:(UIColor *)unSelectedColor
{
    MMSegmentBtn *button = [MMSegmentBtn buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:unSelectedColor forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    button.tag = index;
    button.selected = (index == 0);
    return button;
}

@end

@interface MMSegmentCell : UICollectionViewCell

@property (nonatomic, weak) UIViewController *vc;

@end

@implementation MMSegmentCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    NSArray *cellSubView = [self.contentView.subviews mutableCopy];
    for (UIView *view in cellSubView) {
        [view removeFromSuperview];
    }
}

- (void)setVc:(UIViewController *)vc {
    _vc = vc;

    [self.contentView addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

@end

@interface MMSegmentControl () <UICollectionViewDataSource, UICollectionViewDelegate>{
    NSInteger _selectedIndex;
    NSUInteger _preIndex;
    NSUInteger _firstIndex;
    
    CGSize _headerViewSize;
    CGSize _selectorSize;
    CGFloat _selectorToBottom;
}

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, weak) UIViewController<MMSegmentControlDelegate> *delegate;

@end

@implementation MMSegmentControl

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (_firstIndex) {
        [self selectedButtonAtIndex:_firstIndex];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                  controllers:(NSArray *)controller
                       titles:(NSArray *)title
                     delegate:(UIViewController<MMSegmentControlDelegate> *)delegate
                    initIndex:(NSUInteger)firstIndex
                   headHeight:(CGFloat)headHeight
                 sgementWidth:(CGFloat)sgementWidth
                 selectorSize:(CGSize)selectorSize
             selectorToBottom:(CGFloat)selectorToBottom
                selectedColor:(UIColor *)selectedColor
              unSelectedColor:(UIColor *)unSelectedColor
{
    if (self = [super init]) {
        NSAssert(controller.count == title.count, @"controller & title not the same count");
        self.frame = frame;
        
        _firstIndex = firstIndex;
        _preIndex = firstIndex;
        _headerViewSize = CGSizeMake(sgementWidth, headHeight);
        _selectorSize = selectorSize;
        _selectorToBottom = selectorToBottom;
        _selectedColor = selectedColor;
        _unSelectedColor = unSelectedColor;
        _delegate = delegate;
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

- (void)setUpHeaderView {
    _headView = [[UIView alloc] init];
    _headView.backgroundColor = [UIColor clearColor];
    [self addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.width.equalTo(self);
        make.height.mas_equalTo(_headerViewSize.height);
    }];
    
    _segmentView = [[UIView alloc] init];
    _segmentView.backgroundColor = [UIColor lightGrayColor];
    [_headView addSubview:_segmentView];
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView);
        make.centerX.equalTo(_headView);
        make.size.mas_equalTo(_headerViewSize);
    }];
    
    NSInteger nums = [self.titles count];
    MMSegmentBtn *preBtn = nil;
    CGFloat btnWidth = _headerViewSize.width / nums;
    for (int i = 0; i< nums; i++) {
        
        [self.delegate addChildViewController:_controllers[i]];
        MMSegmentBtn *button = [MMSegmentBtn segmentBtnWithTitle:[self.titles objectAtIndex:i]
                                                           index:i
                                                   selectedColor:self.selectedColor
                                                 unSelectedColor:self.unSelectedColor];
        [button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [_segmentView addSubview:button];
        [self.buttonArray addObject:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(_segmentView);
            } else {
                make.left.equalTo(preBtn.mas_right);
            }
            make.top.height.equalTo(_segmentView);
            make.width.mas_equalTo(btnWidth);
        }];
        preBtn = button;
    }
    
    CGFloat xOffset = (_headerViewSize.width / self.titles.count - _selectorSize.width) / 2;
    self.selectorBar = [[UIView alloc] init];
    self.selectorBar.backgroundColor = self.selectedColor;
    [_segmentView addSubview:self.selectorBar];
    [_selectorBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_selectorSize);
        make.left.equalTo(_segmentView).offset(xOffset);
        make.bottom.equalTo(_segmentView).offset(-_selectorToBottom);
    }];
}

- (void)setUpCollectionView {
    //-- Create Flow Layout
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //-- Create Collection View
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:flowLayout];
    
    [_collectionView registerClass:[MMSegmentCell class] forCellWithReuseIdentifier:@"kMMSegmentCellId"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self).offset(_headerViewSize.height);
    }];
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    _selectorBar.backgroundColor = selectedColor;
    for (UIButton *btn in self.buttonArray) {
        [btn setTitleColor:selectedColor forState:UIControlStateSelected];
    }
}

- (void)setUnSelectedColor:(UIColor *)unSelectedColor {
    _unSelectedColor = unSelectedColor;
    for (UIButton *btn in self.buttonArray) {
        [btn setTitleColor:unSelectedColor forState:UIControlStateNormal];
    }
}

- (void)clickedButton:(id)sender {
    [self selectedButtonAtIndex:((UIButton *)sender).tag];
}

- (void)selectedButtonAtIndex:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self buttonSelectAction:index];
        if (_selectedIndex != index) {
            BOOL showAnimation = YES;
            if (_firstIndex != 0) {
                showAnimation = NO;
            }
            
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionNone animated:showAnimation];
            _selectedIndex = index;
            _firstIndex = 0;
            if ([self.delegate respondsToSelector:@selector(segmentControl:viewDidAppearAtIndex:)]) {
                [self.delegate segmentControl:self viewDidAppearAtIndex:_selectedIndex];
            }
            
            UIViewController<MMSegmentControlChildVCDelegate> *vc = self.controllers[_selectedIndex];
            if ([vc respondsToSelector:@selector(viewInChildViewControllerWillAppear)]) {
                [vc viewInChildViewControllerWillAppear];
            }
        }
    });
}

- (void)buttonSelectAction:(NSInteger)index {
    for (UIButton *button in self.buttonArray) {
        if(button.selected)button.selected = NO;
        if(button.tag ==index)button.selected = YES;
    }
}

#pragma mark collection view delegate and data source methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.controllers.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_collectionView.frame.size.width, _collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MMSegmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kMMSegmentCellId" forIndexPath:indexPath];
    if ([[self.controllers objectAtIndex:indexPath.row] isKindOfClass:[UIViewController class]]) {
        UIViewController *controller = [self.controllers objectAtIndex:indexPath.row];
        cell.vc = controller;
    }
    return cell;
}

//界面滚动中， 将指示器同步滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([scrollView isKindOfClass:[UICollectionView class]]){
        CGFloat xoffset = scrollView.contentOffset.x;
        CGFloat length = _headerViewSize.width /self.titles.count;
        CGFloat x = xoffset/[UIScreen mainScreen].bounds.size.width *length + (length - _selectorSize.width) / 2 ;
        
        [_selectorBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(x);
        }];
    }
}

//用户停止了操作
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if([scrollView isKindOfClass:[UICollectionView class]]){
        CGFloat xoffset = scrollView.contentOffset.x;
        NSUInteger index = xoffset/[UIScreen mainScreen].bounds.size.width;
        [self selectedButtonAtIndex:index];
    }
}

@end
