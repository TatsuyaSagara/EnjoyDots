//
//  CalcAnswerDisplayView.m
//  dots
//
//  Created by tatsuya sagara on 12/03/11.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "CalcAnswerView.h"

@interface CalcAnswerView (private)
- (void) setNumber;
- (void) setStatus;
@end

@implementation CalcAnswerView

- (id)initWithFrame:(CGRect)frame
{
    // 表示位置調整（iPhoneの場合）
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone用
        UIScreen *screen = [UIScreen mainScreen];
        CGRect fullScreenRect = screen.bounds;
        int startPositionX = (fullScreenRect.size.width-480)/2;
        frame = CGRectMake(startPositionX,0,480,320);
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        /* 保存データ管理インスタンス作成 */
        dm_ = [DataManager new];
        
        /* アイコン有無配列宣言 */
        buffer_ = [NSMutableArray array];
        
        /* 背景をレイヤーとして表示 */
        UIImage *myimg=nil;
        CALayer *layer = [CALayer layer];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            // iPhone用
            NSString *aImagePath = [[NSBundle mainBundle] pathForResource:@"misc_back" ofType:@"png"];
            myimg = [[UIImage alloc]initWithContentsOfFile:aImagePath];
            [layer setBounds:CGRectMake(0,0,480,320)];
            layer.contents = (id)myimg.CGImage;
            layer.position = CGPointMake(480/2, 320/2);
        } else {
            // iPad用
            NSString *aImagePath = [[NSBundle mainBundle] pathForResource:@"misc_back" ofType:@"png"];
            myimg = [[UIImage alloc]initWithContentsOfFile:aImagePath];
            [layer setBounds:CGRectMake(0,0,1024,768)];
            layer.contents = (id)myimg.CGImage;
            layer.position = CGPointMake(1024/2, 768/2);
        }
        [self.layer addSublayer:layer];
        
        /*
         * 数表示
         */
        [self setNumber];

        /*
         * 状態の表示
         */
//        [self setStatus];
        
        /*
         * レイヤーのインスタンスを生成
         */
        for(int i=0;i<ANSWER_ICON_X*ANSWER_ICON_Y;i++) layer_[i] = [CALayer layer];
        
        /*
         * 表示するアイコン取得
         */
        NSString *fileName = [dm_ getNameIcon:[dm_ getIcon] Size:0];
        myimg_ = [UIImage imageNamed:fileName];
    }
    return self;
}

// 数の表示
- (void) setNumber {
    // 答え
    labelAnswer_ = [UILabel new];
    labelAnswer_.text = @"a";
    labelAnswer_.textColor = [UIColor blackColor];
    labelAnswer_.textAlignment = NSTextAlignmentCenter;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone
        labelAnswer_.font = [UIFont fontWithName:@"Helvetica-Bold" size:50];
        labelAnswer_.frame = CGRectMake(208,40,64,64);
    } else {
        // iPad
        labelAnswer_.font = [UIFont fontWithName:@"Helvetica-Bold" size:110];
        labelAnswer_.frame = CGRectMake(450,126,128,128);
    }
    [self addSubview:labelAnswer_];
}

// 状態の表示
- (void) setStatus {
    // 操作
    labelOperation_ = [UILabel new];
    labelOperation_.textColor = [UIColor blackColor];
    labelOperation_.textAlignment = NSTextAlignmentCenter;
    if( OPERATION_AUTO == [dm_ getOperation] )
    {
        labelOperation_.text = NSLocalizedString(@"Auto", @"Auto Message");
    }
    else
    {
        labelOperation_.text = NSLocalizedString(@"Manual", @"Manual Message");
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone
        labelOperation_.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        labelOperation_.frame = CGRectMake(280,5,96,16);
    } else {
        // iPad
        labelOperation_.font = [UIFont fontWithName:@"Helvetica-Bold" size:34];
        labelOperation_.frame = CGRectMake(600,15,192,32);
    }
    [self addSubview:labelOperation_];
    
    // 速度
    labelSpeed_ = [UILabel new];
    labelSpeed_.textColor = [UIColor blackColor];
    labelSpeed_.textAlignment = NSTextAlignmentCenter;
    if( SPEED_FAST == [dm_ getSpeed] )
    {
        labelSpeed_.text = NSLocalizedString(@"Fast", @"Fast Message");
    }
    else if( SPEED_NORMAL == [dm_ getSpeed] )
    {
        labelSpeed_.text = NSLocalizedString(@"Normal", @"Normal Message");
    }
    else
    {
        labelSpeed_.text = NSLocalizedString(@"Slow", @"Slow Message");
    }
    if( OPERATION_AUTO == [dm_ getOperation] )
    {
        labelOperation_.text = NSLocalizedString(@"Auto", @"Auto Message");
    }
    else
    {
        labelOperation_.text = NSLocalizedString(@"Manual", @"Manual Message");
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone
        labelSpeed_.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        labelSpeed_.frame = CGRectMake(380,5,96,16);
    } else {
        // iPad
        labelSpeed_.font = [UIFont fontWithName:@"Helvetica-Bold" size:34];
        labelSpeed_.frame = CGRectMake(800,15,192,32);
    }
    [self addSubview:labelSpeed_];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSInteger u=0;
    NSInteger x=0,y=0;
//    NSInteger i=0,j=0;
//    NSInteger imageIndex=0;
    
    NSInteger IconSizeW        = 0;  // アイコンのサイズ(幅)
    NSInteger IconSizeH        = 0;  // アイコンのサイズ(高)
    NSInteger RightPositionX   = 0;
    NSInteger RightPositionY   = 0;
    NSInteger k=0,l=0;
    NSNumber *nm;
    
    // 各アイコンの座標設定
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhoneのとき
        IconSizeW        = 64;  // アイコンのサイズ(幅)
        IconSizeH        = 64;  // アイコンのサイズ(高)
        RightPositionX   = 80;
        RightPositionY   = 112;
    } else {
        // iPadのとき
        IconSizeW        = 128;  // アイコンのサイズ(幅)
        IconSizeH        = 128;  // アイコンのサイズ(高)
        RightPositionX   = 195;
        RightPositionY   = 288;
    }
    
    // 答えの取り出し
    u = [dm_ getOperatorAnswer];

    for(int i=0; i<ANSWER_ICON_X*ANSWER_ICON_Y; i++) {
        nm = [NSNumber numberWithInt:i];
        [buffer_ insertObject:nm atIndex:i];
        [layer_[i] removeFromSuperlayer];
    }
    
    for (int j = 0 ; j < u; j++) {

        NSInteger num = arc4random()%(ANSWER_ICON_X*ANSWER_ICON_Y-j);
        NSNumber *pos = [buffer_ objectAtIndex:num];
        [buffer_ removeObjectAtIndex:num];
        
        k = [pos intValue] % ANSWER_ICON_X; // 何列目に表示するかを横に表示する数で割った余りで求める
        l = [pos intValue] / ANSWER_ICON_X; // 何行目に表示するかを横に表示する数で割った答え
        
        // 座標決定
        x = IconSizeW * k + RightPositionX; // 表示するベースとなるポジションをもとに座標を算出
        y = IconSizeH * l + RightPositionY; // 同上
        
        // レイヤーのサイズを設定します。
        [layer_[j] setBounds:CGRectMake(0, 0, IconSizeW, IconSizeH)];
        layer_[j].contents = (id)myimg_.CGImage;
        
        // CALayerのアニメーションを停止する処理開始
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        
        // レイヤーを表示する位置を算出
        layer_[j].position = CGPointMake(x+IconSizeW/2, y+IconSizeH/2);
        
        // CALayerのアニメーションを停止する処理終了
        [CATransaction commit];
        
        [self.layer addSublayer:layer_[j]];
        
    }

    [labelAnswer_ setText:[NSString stringWithFormat:@"%ld",(long)u]];

}

@end
