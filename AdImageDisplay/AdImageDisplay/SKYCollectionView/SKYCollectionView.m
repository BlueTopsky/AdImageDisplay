//
//  SKYScrollView.m
//  MyCategory
//
//  Created by Topsky on 2016/12/9.
//  Copyright © 2016年 Topsky. All rights reserved.
//

#import "SKYCollectionView.h"
#import "ImgCollectionViewCell.h"
#import <Masonry.h>

@interface SKYCollectionView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *loaclImgData;
@property (nonatomic, strong) NSMutableArray *remoteImgData;
@property (nonatomic, strong) NSTimer *mTimer;
@property (nonatomic, assign) BOOL isAutoScroll;
@end

@implementation SKYCollectionView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.timeInterval = 3;
    //添加collectionview与页面控制器
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.bounds.size.width,self.bounds.size.height);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeZero;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = self.backgroundColor;
    [_collectionView registerClass:[ImgCollectionViewCell class] forCellWithReuseIdentifier:ImgCellID];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.userInteractionEnabled = YES;
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.pageControl = [[UIPageControl alloc]init];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    _pageControl.enabled = NO;
    [self addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(@-20);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
}

-(void)reloadImageDatas:(NSMutableArray *)datas withType:(ImgType)type withCurrentIndex:(NSInteger)page {
    if (type == ImgTypeLocal) {
        [self.remoteImgData removeAllObjects];
        self.loaclImgData = datas;
    }else{
        [self.loaclImgData removeAllObjects];
        self.remoteImgData = datas;
    }
    _pageControl.numberOfPages = datas.count;
    [_collectionView reloadData];
    _pageControl.currentPage = page;
    _currentPage = page;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView setContentOffset:CGPointMake(self.bounds.size.width*(page+1), 0) animated:NO];
    });
}

- (void)startRun {
    self.isAutoScroll = YES;
    [self startTimer];
}

- (void)startTimer {
    if (!self.mTimer){
        self.mTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    }
}

-(void)cancleTimer{
    if (self.mTimer) {
        [self.mTimer invalidate];
        self.mTimer = nil;
    }
}

-(void)autoScroll{
    NSInteger count = 0;
    if (self.loaclImgData.count != 0) {
        count = self.loaclImgData.count;
    }else{
        count = self.remoteImgData.count;
    }
    if (count == 0) {
        return;
    }
    if (self.direction == ScrollDirectionLeft) {
        _currentPage++;
    }else{
        _currentPage--;
    }
    
    [_collectionView setContentOffset:CGPointMake(self.bounds.size.width*(_currentPage+1), -0) animated:YES];
    if (_currentPage == count) {
        _currentPage = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView setContentOffset:CGPointMake(self.bounds.size.width*(self.currentPage+1), -0) animated:NO];
        });
    }else if (_currentPage == -1){
        _currentPage = count-1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView setContentOffset:CGPointMake(self.bounds.size.width*(self.currentPage+1), -0) animated:NO];
        });
    }
    _pageControl.currentPage = _currentPage;
    if ([self.delegate respondsToSelector:@selector(scrollToIndex:)]) {
        [self.delegate scrollToIndex:_currentPage];
    }
}

#pragma mark - UIScorllViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.collectionView) {
        return;
    }
    NSInteger page = scrollView.contentOffset.x/self.bounds.size.width;
    NSMutableArray *datas = [NSMutableArray array];
    if (self.loaclImgData.count != 0) {
        datas = self.loaclImgData;
    }else{
        datas = self.remoteImgData;
    }
    if (page == datas.count + 1) {
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width * 1, 0) animated:NO];
        page = 1;
    }else if(page == 0) {
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width * datas.count, 0) animated:NO];
        page = datas.count;
    }
    _currentPage = page - 1;
    _pageControl.currentPage = page - 1;
    if ([self.delegate respondsToSelector:@selector(scrollToIndex:)]) {
        [self.delegate scrollToIndex:_currentPage];
    }
    if (self.isAutoScroll) {
        [self startTimer];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.isAutoScroll) {
        [self cancleTimer];
    }
}

#pragma mark -UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.loaclImgData.count != 0) {
        return self.loaclImgData.count + 2;
    }else{
        return self.remoteImgData.count + 2;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImgCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImgCellID forIndexPath:indexPath];
    
    if (self.loaclImgData.count != 0) {
        if (indexPath.row == 0) {
            [cell setImgName:[self.loaclImgData lastObject]];
        }else if (indexPath.row == self.loaclImgData.count + 1) {
            [cell setImgName:[self.loaclImgData firstObject]];
        }else {
            [cell setImgName:self.loaclImgData[indexPath.row - 1]];
        }
    }else{
        if (indexPath.row == 0) {
            [cell setImgUrlStr:[self.remoteImgData lastObject]];
        }else if (indexPath.row == self.remoteImgData.count + 1) {
            [cell setImgUrlStr:[self.remoteImgData firstObject]];
        }else {
            [cell setImgUrlStr:self.remoteImgData[indexPath.row - 1]];
        }
    }
    return cell;
}

#pragma mark = UIColletionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
        [self.delegate didSelectedIndex:_currentPage];
    }
}

-(NSMutableArray *)loaclImgData{
    
    if (!_loaclImgData) {
        _loaclImgData = [[NSMutableArray alloc]init];
    }
    return _loaclImgData;
}

-(NSMutableArray *)remoteImgData{
    
    if (!_remoteImgData) {
        _remoteImgData = [[NSMutableArray alloc]init];
    }
    return _remoteImgData;
}

@end
