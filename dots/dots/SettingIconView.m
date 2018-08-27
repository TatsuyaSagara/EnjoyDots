//
//  SettingIconView.m
//  dots
//
//  Created by tatsuya sagara on 12/03/17.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "SettingIconView.h"

@implementation SettingIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIImage *img = [UIImage imageNamed:@"ball.png"];
    UIImageView *iv = [[UIImageView alloc] initWithImage:img];
    iv.frame = CGRectMake(0, 0, 64, 64);  // 100x100サイズのUIImageViewを作成し
    iv.center = CGPointMake(400, 300);  // 200,100の位置に配置する
    
    [UIView beginAnimations:nil context:nil];  // 条件指定開始
    [UIView setAnimationDuration:2.0];  // 2秒かけてアニメーションを終了させる
    [UIView setAnimationDelay:3.0];  // 3秒後にアニメーションを開始する
    [UIView setAnimationRepeatCount:5.0];  // アニメーションを5回繰り返す
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];  // アニメーションは一定速度
    iv.center = CGPointMake(500, 400);  // 終了位置を200,400の位置に指定する
    
    [UIView commitAnimations];  // アニメーション開始！
}

@end
