//
//  ViewController.m
//  AdImageDisplay
//
//  Created by Topsky on 2018/4/19.
//  Copyright © 2018年 Topsky. All rights reserved.
//

#import "ViewController.h"
#import "SKYCollectionView.h"
#import <Masonry.h>

@interface ViewController ()<SKYCollectionViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCollectionView];
}

-(void)addCollectionView{
    NSMutableArray *datas = [[NSMutableArray alloc]initWithArray:@[@"http://img.zcool.cn/community/05dc4a554aed4e00000115a8220d86.jpg",@"http://4493bz.1985t.com/uploads/allimg/141204/4-141204095J8.jpg",@"http://image5.tuku.cn/pic/wallpaper/fengjing/langmandushiweimeisheyingkuanpingbizhi/006.jpg",@"http://img15.3lian.com/2015/f2/160/d/119.jpg",@"http://f.hiphotos.baidu.com/image/pic/item/35a85edf8db1cb13e485f913df54564e93584bc6.jpg"]];
    
    CGFloat collectionViewWidth = self.view.bounds.size.width;
    CGFloat collectionViewHeight = 250;
    SKYCollectionView *collectionView = [[SKYCollectionView alloc]initWithFrame:CGRectMake(0, 0, collectionViewWidth, collectionViewHeight)];
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.left.equalTo(self.view);
        make.width.equalTo(@(collectionViewWidth));
        make.height.equalTo(@(collectionViewHeight));
    }];
    
    [collectionView reloadImageDatas:datas withType:ImgTypeRemote withCurrentIndex:0];
    [collectionView setTimeInterval:2];
    [collectionView setDirection:ScrollDirectionLeft];
    [collectionView startRun];
}

#pragma mark ----- SKYCollectionViewDelegate

//点击某张图片
-(void)didSelectedIndex:(NSInteger)index {
    NSLog(@"点击:%ld",(long)index);
}

//滑动到某张图片
-(void)scrollToIndex:(NSInteger)index {
    NSLog(@"滑动:%ld",(long)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
