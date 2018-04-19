//
//  SKYScrollView.h
//  MyCategory
//
//  Created by Topsky on 2016/12/9.
//  Copyright © 2016年 Topsky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ImgType) {
    ImgTypeLocal,//本地图片
    ImgTypeRemote,//网络图片
};

typedef NS_ENUM(NSInteger, ScrollDirection) {
    ScrollDirectionLeft,//向左滚动
    ScrollDirectionRight,//向右滚动
};

@protocol SKYCollectionViewDelegate <NSObject>

@optional
//点击哪张图片
-(void)didSelectedIndex:(NSInteger)index;
//滑动到哪张张图片
-(void)scrollToIndex:(NSInteger)index;

@end

@interface SKYCollectionView : UIView

@property (nonatomic, retain) id<SKYCollectionViewDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval timeInterval;//滚动时间间隔，默认3秒
@property (nonatomic, assign) ScrollDirection direction;//滚动方向，默认向左

/**
 添加图片数据

 @param datas 图片数组，工程中的图片则传图片名，网络图片则传URLString
 @param type 图片类型
 @param page 显示的初始图片下标
 */
- (void)reloadImageDatas:(NSMutableArray *)datas withType:(ImgType)type withCurrentIndex:(NSInteger)page;

//开启定时器，自动滑动
- (void)startRun;

@end
