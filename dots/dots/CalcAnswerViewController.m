//
//  CalcAnswerViewController.m
//  dots
//
//  Created by tatsuya sagara on 12/03/02.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "CalcAnswerViewController.h"

@interface CalcAnswerViewController (private)
- (void) operationTimer;
- (void) setView;
- (void) setButton;
@end

@implementation CalcAnswerViewController

@synthesize delegate; 
@synthesize TextAnswer;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /* 初期化 */
    am_  = [AudioManager new];           // 音声鳴動インスタンス作成
    dm_  = [DataManager new];            // 保存データ管理インスタンス作成
        
    /* view初期化 */
    [self setView];
    
    /* Backボタン初期化 */
    [self setButton];

    /* 操作タイマー設定 */
    [self operationTimer];

    /* 音声鳴動 */
    cnt_ = 0;                            // 問題が面表示カウンタ初期化（0:左辺、1:四則演算、2:右辺）
    [self soundTimer:NULL];
}

// view初期化
- (void) setView {
    CGRect rect = self.view.bounds;
//    CGRect mRect = CGRectMake(0,0,rect.size.height,rect.size.width); // 横画面専用なので高さと幅を逆にする
//    CGRect mRect = CGRectMake(0,0,rect.size.width,rect.size.height);
    cdv_ = [[CalcAnswerView alloc] initWithFrame:rect];
    cdv_.opaque = YES;
    cdv_.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cdv_];
}

// Backボタン初期化と設置
-(void) setButton {

    // 4インチRetina対応用
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds;
    int startPositionX = (fullScreenRect.size.width-480)/2;

    // 戻る
    UIButton *btnBack_ = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnBack_ setTitle:@"Back" forState:UIControlStateNormal];
    [btnBack_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone
        [btnBack_.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [btnBack_ setFrame:CGRectMake(startPositionX+407,0,50,35)];
    } else {
        // iPad
        [btnBack_.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
        [btnBack_ setFrame:CGRectMake(860,0,120,76)];
    }
//    [btnBack_ addTarget:self action:@selector(AnswerBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnBack_ addTarget:self action:@selector(AnswerBackButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnBack_];

    // イコール
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone
        UIImageView *imgEquals_ = [UIImageView new];
        imgEquals_.frame = CGRectMake( startPositionX+13, 177, 64, 64 );
        imgEquals_.image = [UIImage imageNamed:@"equal.png"];
        imgEquals_.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imgEquals_];
    } else {
        // iPad
        UIImageView *imgEquals_ = [UIImageView new];
        imgEquals_.frame = CGRectMake( 40, 416, 128, 128 );
        imgEquals_.image = [UIImage imageNamed:@"equal.png"];
        imgEquals_.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imgEquals_];
    }
}

- (void)viewDidUnload
{
    [self setTextAnswer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //[timer invalidate];
    [am_ stopSound];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // 横モードのみ対応
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeRight) ||
            (interfaceOrientation == UIInterfaceOrientationLandscapeLeft));
}

#pragma mark - event

// Back
- (IBAction) AnswerBackButton:(id)sender {
    [operationTimer_ invalidate];
    [timer_ invalidate];
    [am_ stopSound];
    // Question画面（親ビュー）側で閉じてもらう
    if ([delegate respondsToSelector:@selector(AnswerBackButtonDelegate)]) {  
        [delegate AnswerBackButtonDelegate];  
    }    
}

// タップ
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Answer touchesEnded");
    if ([[touches anyObject] view] != cdv_) return;
    if( OPERATION_AUTO == [dm_ getOperation] ) return;
    [timer_ invalidate];
    [am_ stopSound];
    // Question画面（親ビュー）側で閉じてもらう
    if ([delegate respondsToSelector:@selector(AnswerTapDelegate)]) {  
        [delegate AnswerTapDelegate];
    }
}

- (void)calcAnswerPauseEvent
{
    [timer_ invalidate];
    [operationTimer_ invalidate];
}
- (void)calcAnswerResumeEvent
{
    /* 操作タイマー設定 */
    [self operationTimer];

    /* 音声鳴動 */
    [self soundTimer:NULL];
}

#pragma mark - timer

// タイマイベント
- (void)soundTimer:(NSTimer*)theTimer
{
    [timer_ invalidate];
    if( cnt_ > 1 ) return;
    [am_ stopSound];
    float time = [dm_ getSpeedTime];
    if( cnt_ == 0 ) {
        // 和
        [am_ playSoundCount:OPERATOR_EQUALS_SOUND_INDEX];
        timer_ = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector( soundTimer: ) userInfo:nil repeats:NO];
    }
    if( cnt_ == 1 ) {
        // 答え（DataManagerから答えを取得する）
        [am_ playSoundCount:[dm_ getOperatorAnswer]];
        timer_ = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector( soundTimer: ) userInfo:nil repeats:NO];
    }
    cnt_++;
}

// 自動タイマー
- (void) operationAutoTimer:(NSTimer*)theTimer {
    [operationTimer_ invalidate];
    [timer_ invalidate];
    [am_ stopSound];
    // Question画面（親ビュー）側で閉じてもらう
    if ([delegate respondsToSelector:@selector(AnswerTapDelegate)]) {  
        [delegate AnswerTapDelegate];  
    }    
}

// 操作タイマー
- (void) operationTimer {
    if( OPERATION_MANUAL == [dm_ getOperation] ) return;
    float time = [dm_ getSpeedTime];
    operationTimer_ = [NSTimer scheduledTimerWithTimeInterval:time*2 target:self selector:@selector( operationAutoTimer: ) userInfo:nil repeats:NO];
}

@end
