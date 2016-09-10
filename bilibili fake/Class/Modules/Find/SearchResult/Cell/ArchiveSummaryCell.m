//
//  ArchiveSummaryCell.m
//  bilibili fake
//
//  Created by C on 16/9/11.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ArchiveSummaryCell.h"
#import "Macro.h"
#import <UIImageView+WebCache.h>

@implementation ArchiveSummaryCell{
    UIImageView* coverImageView;//封面
    UILabel* titleLabel;
    UILabel* authorLabel;
    
    UILabel* orderTypeValueLabel;
}
+(CGFloat)height{
    return 70;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        coverImageView = ({
            UIImageView* view = [[UIImageView alloc] init];
            view.layer.masksToBounds = YES;//圆角设置无效
            view.layer.cornerRadius = 6.0;
            [self addSubview:view];
            view;
        });
        
        titleLabel = ({
            UILabel* label = [UILabel new];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = ColorRGB(0, 0, 0);
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 2;
            [self addSubview:label];
            label;
        });
        
        authorLabel =({
            UILabel* label = [UILabel new];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = ColorRGB(100, 100, 100);
            [self addSubview:label];
            label;
        });
        
        orderTypeValueLabel = ({
            UILabel* label = [UILabel new];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = ColorRGB(100, 100, 100);
            [self addSubview:label];
            label;
        });
        //layout
        [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(8);
            make.width.equalTo(coverImageView.mas_height).multipliedBy(1.6);
            make.bottom.equalTo(self).offset(-8);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(coverImageView.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-5);
            make.top.equalTo(coverImageView.mas_top).offset(0);
            make.bottom.equalTo(authorLabel.mas_top);
        }];
        
        [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom);
            make.height.equalTo(@15);
            make.bottom.equalTo(coverImageView);
        }];
     
        [orderTypeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(authorLabel);
            make.width.equalTo(@100);
            make.left.equalTo(authorLabel.mas_right);
            make.right.equalTo(titleLabel);
        }];
    }
    return self;
}

-(void)setEntity:(ArchiveSummaryEntity *)entity{
    _entity = entity;
    [coverImageView sd_setImageWithURL:[NSURL URLWithString:entity.cover]];
    
    titleLabel.text = [entity.title stringByReplacingOccurrencesOfString:@"【" withString:@"["];
    titleLabel.text = [titleLabel.text stringByReplacingOccurrencesOfString:@"】" withString:@"]"];
    
    authorLabel.text = [NSString stringWithFormat:@"UP主:%@",entity.author];
    
    if (_orderType == 2) {
        orderTypeValueLabel.text = [NSString stringWithFormat:@"弹幕: %@",[self stringWithNumber:entity.danmaku]];
    }else{
        orderTypeValueLabel.text = [NSString stringWithFormat:@"播放: %@",[self stringWithNumber:entity.play]];
    }
}
#pragma 返回数字对应的字符串
-(NSString*)stringWithNumber:(NSInteger)num{
    if(num>9999){
        return [NSString stringWithFormat:@"%0.2f万",num/10000.0];
    }else{
        return [NSString stringWithFormat:@"%lu",num];
    }
}

#pragma 根据时间计算是长时间以前的
-(NSString*)getDateStr:(NSInteger)date{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now_time=[dat timeIntervalSince1970];
    
    NSInteger difference = now_time - date;
    NSString* str1 = @"";
    NSString* str2 = @"前";
    
    if (difference < 0) {
        str2 = @"以后";
        difference = -difference;
    }
    
    if(difference < 60){
        str1 = [NSString stringWithFormat:@"%lu秒",difference];
    } else if(difference>=60&&difference<3600){
        str1 = [NSString stringWithFormat:@"%lu分",difference/60];
    } else if(difference>=3600&&difference<86400){
        str1 = [NSString stringWithFormat:@"%lu时",difference/3600];
    } else if(difference>=86400&&difference<2592000){
        str1 = [NSString stringWithFormat:@"%lu天",difference/86400];
    } else if(difference>=2592000&&difference<31104000){
        str1 = [NSString stringWithFormat:@"%lu天",difference/86400];
        //str1 = [NSString stringWithFormat:@"%lu月",difference/2592000];
    } else if(difference>=31104000){
        str1 = [NSString stringWithFormat:@"%lu年",difference/31104000];
    }
    
    
    return [str1 stringByAppendingString:str2];
}
@end
