//
//  CalcQuestionDisplayView.m
//  dots
//
//  Created by tatsuya sagara on 12/03/09.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "CalcQuestionView.h"

@interface CalcQuestionView (private)
- (void) setNumber;
- (void) setStatus;
@end

@implementation CalcQuestionView

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
        for(int i=0;i<QUESTION_ICON_X*QUESTION_ICON_X;i++) leftLayer_[i] = [CALayer layer];
        for(int i=0;i<QUESTION_ICON_X*QUESTION_ICON_X;i++) rightLayer_[i] = [CALayer layer];

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
    // 左辺
    labelLeft_ = [UILabel new];
    labelLeft_.textColor = [UIColor blackColor];
    labelLeft_.textAlignment = NSTextAlignmentCenter;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone
        labelLeft_.font = [UIFont fontWithName:@"Helvetica-Bold" size:50];
        labelLeft_.frame = CGRectMake(80,40,64,64);
    } else {
        // iPad
        labelLeft_.font = [UIFont fontWithName:@"Helvetica-Bold" size:110];
        labelLeft_.frame = CGRectMake(164,132,128,128);
    }
    [self addSubview:labelLeft_];

    // 右辺
    labelRight_ = [UILabel new];
    labelRight_.textColor = [UIColor blackColor];
    labelRight_.textAlignment = NSTextAlignmentCenter;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone
        labelRight_.font = [UIFont fontWithName:@"Helvetica-Bold" size:50];
        labelRight_.frame = CGRectMake(336,40,64,64);
    } else {
        // iPad
        labelRight_.font = [UIFont fontWithName:@"Helvetica-Bold" size:110];
        labelRight_.frame = CGRectMake(736,128,128,128);
    }
    [self addSubview:labelRight_];
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
    NSInteger x=0,y=0;
    
    NSInteger IconSizeW        = 0;  // アイコンのサイズ(幅)
    NSInteger IconSizeH        = 0;  // アイコンのサイズ(高)
    NSInteger LeftPositionX    = 0;  // 左側のアイコンの位置(X)
    NSInteger LeftPositionY    = 0;  // 左側のアイコンの位置(Y)
    NSInteger CenterPositionX  = 0;  // 四則演算のアイコンの位置(X)
    NSInteger CenterPositionY  = 0;  // 四則演算のアイコンの位置(Y)
    NSInteger RightPositionX   = 0;  // 右側のアイコンの位置(X)
    NSInteger RightPositionY   = 0;  // 右側のアイコンの位置(Y)
    NSInteger k=0,l=0;
    NSNumber *nm;
    NSInteger leftNum=0;
    NSInteger rightNum=0;
    
    leftNum = [dm_ getOperatorQuestionLeft];
    rightNum = [dm_ getOperatorQuestionRight];
    
    // 各アイコンの座標設定
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhoneの場合の座標
        IconSizeW        = 64;
        IconSizeH        = 64;
        LeftPositionX    = 16
        ;    // 左側のアイコンの位置(X)
        LeftPositionY    = 112;  // 左側のアイコンの位置(Y)
        CenterPositionX  = 208;  // 四則演算のアイコンの位置(X)
        CenterPositionY  = 176;  // 四則演算のアイコンの位置(Y)
        RightPositionX   = 272;  // 右側のアイコンの位置(X)
        RightPositionY   = 112;  // 右側のアイコンの位置(Y)
    } else {
        // iPadの場合の座標
        IconSizeW        = 128;
        IconSizeH        = 128;
        LeftPositionX    = 32;   // 左側のアイコンの位置(X)
        LeftPositionY    = 288;  // 左側のアイコンの位置(Y)
        CenterPositionX  = 448;  // 四則演算のアイコンの位置(X)
        CenterPositionY  = 416;  // 四則演算のアイコンの位置(Y)
        RightPositionX   = 608;  // 右側のアイコンの位置(X)
        RightPositionY   = 288;  // 右側のアイコンの位置(Y)
    }
    
    for(int i=0; i<QUESTION_ICON_X*QUESTION_ICON_Y; i++) {
        nm = [NSNumber numberWithInt:i];
        [buffer_ insertObject:nm atIndex:i];
        [leftLayer_[i] removeFromSuperlayer];
    }

    /////////////////
    // 左辺描画
    /////////////////
    // アイコンの表示
    for (int j = 0 ; j < leftNum; j++) {
        
        NSInteger num = arc4random()%(QUESTION_ICON_X*QUESTION_ICON_Y-j);
        NSNumber *pos = [buffer_ objectAtIndex:num];
        [buffer_ removeObjectAtIndex:num];
        
        k = [pos intValue] % QUESTION_ICON_X; // 何列目に表示するかを横に表示する数で割った余りで求める
        l = [pos intValue] / QUESTION_ICON_X; // 何行目に表示するかを横に表示する数で割った答え
        
        // 座標決定
        x = IconSizeW * k + LeftPositionX; // 表示するベースとなるポジションをもとに座標を算出
        y = IconSizeH * l + LeftPositionY; // 同上
        
        // レイヤーのサイズを設定します。
        [leftLayer_[j] setBounds:CGRectMake(0, 0, IconSizeW, IconSizeH)];
        leftLayer_[j].contents = (id)myimg_.CGImage;
        
        // CALayerのアニメーションを停止する処理開始
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        
        // レイヤーを表示する位置を算出
        leftLayer_[j].position = CGPointMake(x+IconSizeW/2, y+IconSizeH/2);
        
        // CALayerのアニメーションを停止する処理終了
        [CATransaction commit];
        
        [self.layer addSublayer:leftLayer_[j]];
        
    }

    [labelLeft_ setText:[NSString stringWithFormat:@"%ld",(long)leftNum]];

//    NSLog(@"leftNum=%ld"  ,(long)leftNum);

    /////////////////
    // 四則演算（＋,−）部分描画
    /////////////////
    @synchronized(self)
    {
        calcImg_ = [UIImageView new];
        if( nil != calcImg_ )
        {
            calcImg_.frame = CGRectMake(
                                        CenterPositionX,
                                        CenterPositionY,
                                        IconSizeW,
                                        IconSizeH
                                        );
            if( OPERATOR_PLUS == [dm_ getOperator] ) {
                calcImg_.image = [UIImage imageNamed:@"plus.png"];
            }
            else if( OPERATOR_MINUS == [dm_ getOperator] ) {
                calcImg_.image = [UIImage imageNamed:@"minus.png"];
            }
            else {
                calcImg_.image = [UIImage imageNamed:@"plus.png"];
            }
            calcImg_.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:calcImg_];
        }
    }
    
    for(int i=0; i<QUESTION_ICON_X*QUESTION_ICON_Y; i++) {
        nm = [NSNumber numberWithInt:i];
        [buffer_ insertObject:nm atIndex:i];
        [rightLayer_[i] removeFromSuperlayer];
    }

    for (int j = 0 ; j < rightNum; j++) {
        
        NSInteger num = arc4random()%(QUESTION_ICON_X*QUESTION_ICON_Y-j);
        NSNumber *pos = [buffer_ objectAtIndex:num];
        [buffer_ removeObjectAtIndex:num];
        
        k = [pos intValue] % QUESTION_ICON_X; // 何列目に表示するかを横に表示する数で割った余りで求める
        l = [pos intValue] / QUESTION_ICON_X; // 何行目に表示するかを横に表示する数で割った答え
        
        // 座標決定
        x = IconSizeW * k + RightPositionX; // 表示するベースとなるポジションをもとに座標を算出
        y = IconSizeH * l + RightPositionY; // 同上
        
        // レイヤーのサイズを設定します。
        [rightLayer_[j] setBounds:CGRectMake(0, 0, IconSizeW, IconSizeH)];
        rightLayer_[j].contents = (id)myimg_.CGImage;
        
        // CALayerのアニメーションを停止する処理開始
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
        
        // レイヤーを表示する位置を算出
        rightLayer_[j].position = CGPointMake(x+IconSizeW/2, y+IconSizeH/2);
        
        // CALayerのアニメーションを停止する処理終了
        [CATransaction commit];
        
        [self.layer addSublayer:rightLayer_[j]];
        
    }

    [labelRight_ setText:[NSString stringWithFormat:@"%ld",(long)rightNum]];

//    NSLog(@"rightNum=%ld" ,(long)rightNum);
}

@end
