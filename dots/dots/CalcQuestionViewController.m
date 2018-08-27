//
//  CalcViewController.m
//  dots
//
//  Created by tatsuya sagara on 12/03/02.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "CalcQuestionViewController.h"

@interface CalcQuestionViewController (private)
- (void) operationTimer;
- (void) setView;
- (void) setButton;
- (void) setQuestionAnswerNumber;
@end

@implementation CalcQuestionViewController

@synthesize delegate;  
@synthesize TextLeftNumber;
@synthesize TextRightNumber;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        calcAnswerController_ = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    NSLog(@"--- viewDidLoad() ---");

    /* 初期化 */
    am_  = [AudioManager new];           // 音声鳴動インスタンス作成
    dm_  = [DataManager new];            // 保存データ管理インスタンス作成

    cdv_ = [CalcQuestionView new];
        
    /* view配置 */
    [self setView];
    
    /* Backボタン配置 */
    [self setButton];

    /* 問題と答えの計算 */
    [self setQuestionAnswerNumber];

    /* 操作タイマー設定 */
    [self operationTimer];
    
    /* 音声鳴動 */
    cnt_ = 0;                            // 問題が面表示カウンタ初期化（0:左辺、1:四則演算、2:右辺）
    [self soundTimer:NULL];
}

// view配置
- (void) setView {
    CGRect rect = self.view.bounds;
//    cdv_ = [[CalcQuestionView alloc] initWithFrame:CGRectMake(0,0,rect.size.width,rect.size.height)];
    cdv_ = [[CalcQuestionView alloc] initWithFrame:rect];
    cdv_.opaque = YES;
    cdv_.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cdv_];
}

// Backボタン設置
-(void) setButton {
    UIButton *btnBack_ = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnBack_ setTitle:@"Back" forState:UIControlStateNormal];
    [btnBack_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone
        UIScreen *screen = [UIScreen mainScreen];
        CGRect fullScreenRect = screen.bounds;
        int startPositionX = (fullScreenRect.size.width-480)/2;

        [btnBack_.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [btnBack_ setFrame:CGRectMake(startPositionX+407,0,50,35)];
    } else {
        // iPad
        [btnBack_.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
        [btnBack_ setFrame:CGRectMake(860,0,120,76)];
    }
//    [btnBack_ addTarget:self action:@selector(QuestionBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnBack_ addTarget:self action:@selector(QuestionBackButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnBack_];
}

- (void)viewDidUnload
{
    NSLog(@"--- viewDidUnload() ---");

    [self setTextLeftNumber:nil];
    [self setTextRightNumber:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [operationTimer_ invalidate];
    [timer_ invalidate];
    [am_ stopSound];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"--- shouldAutorotateToInterfaceOrientation() ---");
    
    // 横モードのみ対応
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeRight) ||
            (interfaceOrientation == UIInterfaceOrientationLandscapeLeft));
}

#pragma mark - delegate

// Anser画面でBackが選択された時に呼ばれる
- (void) AnswerBackButtonDelegate {
    // Answer画面（子ビュー）を閉じる
    [self dismissViewControllerAnimated:NO completion:nil];
    // 自分もメイン画面（親ビュー）側で閉じてもらう
    if ([delegate respondsToSelector:@selector(QuestionBackButtonDelegate)]) {  
        [delegate QuestionBackButtonDelegate];
    }
    calcAnswerController_ = nil;
}

// Anser画面でTapまたは自動実行で終了後に呼ばれる
- (void) AnswerTapDelegate {
    // Answer画面（子ビュー）を閉じる
    [self dismissViewControllerAnimated:NO completion:nil];

    // 問題と答えの計算
    [self setQuestionAnswerNumber];

    /*
     * 操作タイマー設定
     */
    [self operationTimer];
    
    /*
     * 音声鳴動
     */
    cnt_ = 0;                            // 問題画面表示カウンタ初期化（0:左辺、1:四則演算、2:右辺）
    [self soundTimer:NULL];

    // 再描画
    [cdv_ setNeedsDisplay];
}

#pragma mark - event

// Back
- (IBAction) QuestionBackButton:(id)sender {
    [operationTimer_ invalidate];
    [timer_ invalidate];
    [am_ stopSound];
    // メイン画面（親ビュー）側で閉じてもらう
    if ([delegate respondsToSelector:@selector(QuestionBackButtonDelegate)]) {  
        [delegate QuestionBackButtonDelegate];  
    }    
}

// タップ
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Question touchesEnded");
    if ([[touches anyObject] view] != cdv_) return;
    if( OPERATION_AUTO == [dm_ getOperation] ) return;
    [timer_ invalidate];
    [am_ stopSound];
    // 答え画面の表示
    calcAnswerController_ = [[CalcAnswerViewController alloc] initWithNibName:nil bundle:nil];
    calcAnswerController_.delegate = self;
    // Calc画面（子ビュー）を開く
    [self presentViewController:calcAnswerController_ animated:NO completion:nil];
}

- (void)calcQuestionPauseEvent
{
    [timer_ invalidate];
    [operationTimer_ invalidate];
    if( nil == calcAnswerController_ ){
        [calcAnswerController_ calcAnswerPauseEvent];
    }
}

- (void)calcQuestionResumeEvent
{
    /*
     * 操作タイマー設定
     */
    [self operationTimer];
    
    /*
     * 音声鳴動
     */
    [self soundTimer:NULL];

    if( nil == calcAnswerController_ ){
        [calcAnswerController_ calcAnswerResumeEvent];
    }
}

#pragma mark - timer

// サウンドタイマイベント
- (void)soundTimer:(NSTimer*)theTimer
{
    [timer_ invalidate];
    if( cnt_ > 2 ) return;
    [am_ stopSound];
    float time = [dm_ getSpeedTime];
    if( cnt_ == 0 ) {
        // 左辺
        [am_ playSoundCount:[dm_ getOperatorQuestionLeft]];
        timer_ = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector( soundTimer: ) userInfo:nil repeats:NO];
    }
    if( cnt_ == 1 ) {
        // 四則演算
        if     (OPERATOR_PLUS  == [dm_ getOperator]) [am_ playSoundCount:OPERATOR_PLUS_SOUND_INDEX];
        else if(OPERATOR_MINUS == [dm_ getOperator]) [am_ playSoundCount:OPERATOR_MINUS_SOUND_INDEX];
        else                                         [am_ playSoundCount:OPERATOR_PLUS_SOUND_INDEX];
        // 設定されていない場合は”日本語音声”に設定

        timer_ = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector( soundTimer: ) userInfo:nil repeats:NO];
    }
    if( cnt_ == 2 ) {
        // 右辺
        [am_ playSoundCount:[dm_ getOperatorQuestionRight]];
        timer_ = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector( soundTimer: ) userInfo:nil repeats:NO];

    }
    cnt_++;
}

// 自動タイマー
- (void) operationAutoTimer:(NSTimer*)theTimer {
    [operationTimer_ invalidate];
    [timer_ invalidate];
    [am_ stopSound];
    // 答え画面の表示
    CalcAnswerViewController* viewController = [[CalcAnswerViewController alloc] initWithNibName:nil bundle:nil];  
    viewController.delegate = self;
    // Calc画面（子ビュー）を開く
    [self presentViewController:viewController animated:NO completion:nil];
}

// 操作タイマー
- (void) operationTimer {
    if( OPERATION_MANUAL == [dm_ getOperation] ) return;
    float time = [dm_ getSpeedTime];
    operationTimer_ = [NSTimer scheduledTimerWithTimeInterval:time*3 target:self selector:@selector( operationAutoTimer: ) userInfo:nil repeats:NO];
}

#pragma mark - misc

// 問題数と答えを設定
- (void) setQuestionAnswerNumber {
    
    while(1) {
        // 左部分に表示する個数
        NSInteger leftNum  = (arc4random()%(QUESTION_ICON_X*QUESTION_ICON_Y))+1;
        // 右部分に表示する個数
        NSInteger rightNum = (arc4random()%(QUESTION_ICON_X*QUESTION_ICON_Y))+1;        

        if( OPERATOR_PLUS == [dm_ getOperator] ) {
            // プラスの答え保存
            [dm_ setOperatorAnswer:(leftNum+rightNum)];
        } else if( OPERATOR_MINUS == [dm_ getOperator] ) {
            // マイナスの答え保存
            if( (leftNum-rightNum) < 1 ) continue;   // 答えが0以下の場合はやり直し
            [dm_ setOperatorAnswer:(leftNum-rightNum)];
        } else {
            // あり得ないけど、プラスとマイナス以外であれば、プラスの動作をする。
            [dm_ setOperatorAnswer:leftNum+rightNum];
            NSLog(@"計算式不正");
        }
        // プラスの問題保存
        [dm_ setOperatorQuestionLeft:leftNum];
        [dm_ setOperatorQuestionRight:rightNum];
        break;
    }
}

@end
