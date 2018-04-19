//
//  ImgCollectionViewCell.h
//  MyCategory
//
//  Created by Topsky on 2016/12/9.
//  Copyright © 2016年 Topsky. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * ImgCellID = @"ImgCell";
@interface ImgCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imgName;//本地图片
@property (nonatomic, copy) NSString *imgUrlStr;//网络图片

@end
