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
                              index:(NSUInteger)index;

@end

@implementation MMSegmentBtn

+ (instancetype)segmentBtnWithTitle:(NSString *)title index:(NSUInteger)index {
    MMSegmentBtn *button = [MMSegmentBtn buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:0.0 alpha:0.75] forState:UIControlStateSelected];
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
    
    CGSize _headerViewSize;
    CGSize _selectorSize;
    CGFloat _selectorToBottom;
}

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *buttonArray;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_firstIndex) {
        [self selectedButtonAtIndex:_firstIndex];
    }
}

- (instancetype)initWithControllers:(NSArray *)controller
                             titles:(NSArray *)title
{
    return [self initWithControllers:controller titles:title initIndex:0];
}

- (instancetype)initWithControllers:(NSArray *)controller
                             titles:(NSArray *)title
                          initIndex:(NSUInteger)firstIndex
{
    return [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
                   controllers:controller
                        titles:title
                    initIndex:firstIndex
                    headHeight:40
                  sgementWidth:[UIScreen mainScreen].bounds.size.width
                  selectorSize:CGSizeMake(60, 2)
              selectorToBottom:0];
}

- (instancetype)initWithFrame:(CGRect)frame
                  controllers:(NSArray *)controller
                       titles:(NSArray *)title
                    initIndex:(NSUInteger)firstIndex
                   headHeight:(CGFloat)headHeight
                 sgementWidth:(CGFloat)sgementWidth
                 selectorSize:(CGSize)selectorSize
             selectorToBottom:(CGFloat)selectorToBottom
{
    if (self = [super init]) {
        NSAssert(controller.count == title.count, @"controller & title not the same count");
        self.view.frame = frame;
        
        _firstIndex = firstIndex;
        _preIndex = firstIndex;
        _headerViewSize = CGSizeMake(sgementWidth, headHeight);
        _selectorSize = selectorSize;
        _selectorToBottom = selectorToBottom;
        
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
    [self.view addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.width.equalTo(self.view);
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
        [self addChildViewController:_controllers[i]];
        MMSegmentBtn *button = [MMSegmentBtn segmentBtnWithTitle:[self.titles objectAtIndex:i] index:i];
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
    self.selectorBar.backgroundColor = [UIColor yellowColor];
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
        make.top.equalTo(self.view).offset(_headerViewSize.height);
    }];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"controllers" forIndexPath:indexPath];
    if ([[self.controllers objectAtIndex:indexPath.row] isKindOfClass:[UIViewController class]]) {
        UIViewController *controller = [self.controllers objectAtIndex:indexPath.row];
        controller.view.tag = 10001;
        NSArray *cellSubView = [cell.contentView.subviews mutableCopy];
        for (UIView *view in cellSubView) {
            if (view.tag == 10001) {
               [view removeFromSuperview];
            }
        }
        
        [cell.contentView addSubview:controller.view];
        [controller.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
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
        _selectedIndex = index;
        [self buttonSelectAction:index];
    }
}

@end
