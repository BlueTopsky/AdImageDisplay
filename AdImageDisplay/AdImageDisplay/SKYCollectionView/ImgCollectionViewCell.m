//
//  ImgCollectionViewCell.m
//  MyCategory
//
//  Created by Topsky on 2016/12/9.
//  Copyright © 2016年 Topsky. All rights reserved.
//

#import "ImgCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface ImgCollectionViewCell ()

@property (nonatomic,strong)UIImageView * imgView;

@end

@implementation ImgCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.imgView = [[UIImageView alloc]init];
    self.imgView.clipsToBounds = YES;
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.backgroundColor = [UIColor grayColor];
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setImgName:(NSString *)imgName {
    self.imgView.image = [UIImage imageNamed:imgName];
}

- (void)setImgUrlStr:(NSString *)imgUrlStr {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
}

@end
