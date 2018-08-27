//
//  CountDisplayView.m
//  dots
//
//  Created by tatsuya sagara on 12/03/08.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "CountView.h"

@interface CountView (private)
- (void) setStatus;
@end

@implementation CountView

- (id)initWithFrame:(CGRect)frame
{
    // 表示位置調整（iPhoneの場合）
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone用
        UIScreen *screen = [UIScreen mainScreen];
        CGRect fullScreenRect = screen.bounds;
//        int startPositionX = (fullScreenRect.size.height-IPHONE_WIDTH_SIZE)/2;
        int startPositionX = (fullScreenRect.size.width-480)/2;
        frame = CGRectMake(startPositionX,0,480,320);
    }
    else {
        // iPad用
        ;
    }

    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code

        /* 保存データ管理インスタンス作成 */
        dm_ = [DataManager new];
        am_ = [AudioManager new];

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
         * 状態の表示
         */
//        [self setStatus];

        /*
         * レイヤーのインスタンスを生成
         */
        for(int i=0;i<NUM_X*NUM_Y;i++) layer_[i] = [CALayer layer];

        /*
         * 表示するアイコン取得
         */
        NSString *fileName = [dm_ getNameIcon:[dm_ getIcon] Size:72];
        myimg_ = [UIImage imageNamed:fileName];
    }
    return self;
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
    NSInteger IconSizeW         = 0; // アイコンのサイズ
    NSInteger IconSizeH         = 0; // アイコンのサイズ
    NSInteger IconBasePositionX = 0; // アイコン全体を表示する左上の座標
    NSInteger IconBasePositionY = 0; // アイコン全体を表示する左上の座標
    NSInteger k=0,l=0;
    
//    // 表示させる個数取得
//    index_ = [dm_ checkCount:index_];

    // パーツの座標設定
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone用の座標
        IconSizeW         = 32;
        IconSizeH         = 32;
        IconBasePositionX = 32;
        IconBasePositionY = 43;
    } else {
        // iPad用の座標
        IconSizeW         = 72;
        IconSizeH         = 72;
        IconBasePositionX = 44;
        IconBasePositionY = 112;
    }
    
    // 表示させる個数取得
    index_ = [dm_ checkCount:index_];
    
    NSNumber       *nm;
    for(int i=0; i<NUM_X*NUM_Y; i++) {
        nm = [[NSNumber alloc ]initWithInt:i];
        [buffer_ insertObject:nm atIndex:i];
        [layer_[i] removeFromSuperlayer];
    }

    // CALayerのアニメーションを停止する処理開始
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];

    NSLog(@"=========%ld",(long)index_);
    
    // アイコンの表示
    for (int j = 0 ; j <= index_; j++) {
        
        NSInteger num = arc4random()%(NUM_X*NUM_Y-j);
        NSNumber *pos = [buffer_ objectAtIndex:num];
        
        k = [pos intValue] % NUM_X; // 何列目に表示するかを横に表示する数で割った余りで求める
        l = [pos intValue] / NUM_X; // 何行目に表示するかを横に表示する数で割った答え
        if((0==k && 0==l)         || ((NUM_X-1)==k && 0==l) ||
           (0==k && (NUM_Y-1)==l) || ((NUM_X-1)==k && (NUM_Y-1)==l)) {
            j--;
            continue;
        }
        [buffer_ removeObjectAtIndex:num];

        // 座標決定
        x = IconSizeW * k + IconBasePositionX; // 表示するベースとなるポジションをもとに座標を算出
        y = IconSizeH * l + IconBasePositionY; // 同上

        // レイヤーのサイズを設定します。
        [layer_[j] setBounds:CGRectMake(0, 0, IconSizeW, IconSizeH)];
        
        // 画像を設定
        layer_[j].contents = (id)myimg_.CGImage;

//        // CALayerのアニメーションを停止する処理開始
//        [CATransaction begin];
//        [CATransaction setValue:(id)kCFBooleanTrue
//                         forKey:kCATransactionDisableActions];

        // レイヤーを表示する位置を算出
        layer_[j].position = CGPointMake(x+IconSizeW/2, y+IconSizeH/2);

//        // CALayerのアニメーションを停止する処理終了
//        [CATransaction commit];

        [self.layer addSublayer:layer_[j]];
    }

    // CALayerのアニメーションを停止する処理終了
    [CATransaction commit];

    index_++;
    // 音声鳴動
    [am_ stopSound];
    [am_ playSoundCount:index_];
}

@end
