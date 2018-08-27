//
//  CountViewController.m
//  dots
//
//  Created by tatsuya sagara on 12/03/05.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "CountViewController.h"

@interface CountViewController (private)
- (void) operationTimer;
- (void) setView;
- (void) setButton;
@end

@implementation CountViewController

@synthesize delegate;
@synthesize BackButton;

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

    dm_  = [DataManager new];            // 保存データ管理インスタンス作成

    /* 操作タイマー設定 */
    [self operationTimer];
    
    /* view初期化 */
    [self setView];

    /* Backボタン初期化 */
    [self setButton];
}

// viewの設定
- (void) setView {
    CGRect rect = self.view.bounds;
    cdv_ = [[CountView alloc] initWithFrame:rect];
    cdv_.alpha = 1.0;
    cdv_.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cdv_];
}

// Backボタン初期化
-(void) setButton {
    UIButton *btnBack_ = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnBack_ setTitle:@"Back" forState:UIControlStateNormal];
    [btnBack_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone
        UIScreen *screen = [UIScreen mainScreen];
        CGRect fullScreenRect = screen.bounds;
//        int startPositionX = (fullScreenRect.size.height-480)/2;
        int startPositionX = (fullScreenRect.size.width-480)/2;

        [btnBack_.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [btnBack_ setFrame:CGRectMake(407+startPositionX,0,50,35)];
    } else {
        // iPad
        [btnBack_.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
        [btnBack_ setFrame:CGRectMake(860,0,120,76)];
    }
//    [btnBack_ addTarget:self action:@selector(CountBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnBack_ addTarget:self action:@selector(CountBackButton:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnBack_];
}

- (void)viewDidUnload
{
    [self setBackButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // 横モードのみ対応
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeRight) ||
            (interfaceOrientation == UIInterfaceOrientationLandscapeLeft));
}

#pragma mark - event

// Back
- (IBAction) CountBackButton:(id)sender {
    [operationTimer_ invalidate];
    [am_ stopSound];
    // メイン画面（親ビュー）側で閉じてもらう
    if ([delegate respondsToSelector:@selector(CountBackButtonDelegate)]) {  
        [delegate CountBackButtonDelegate];  
    }    
}
// タップ
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if( OPERATION_AUTO == [dm_ getOperation] ) return;
    [am_ stopSound];
    /*
     * 画面表示
     */
    [cdv_ setNeedsDisplay];
}

- (void)countPauseEvent
{
    [operationTimer_ invalidate];
}
- (void)countResumeEvent
{
    /* 操作タイマー設定 */
    [self operationTimer];
}

#pragma mark - timer

// 自動タイマー
- (void) operationAutoTimer:(NSTimer*)theTimer {
    [am_ stopSound];
    /*
     * 画面表示
     */
    [cdv_ setNeedsDisplay];
}
// 自動タイマイベント
- (void) operationTimer {
    if( OPERATION_MANUAL == [dm_ getOperation] ) return;
    float time = [dm_ getSpeedTime];
    operationTimer_ = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector( operationAutoTimer: ) userInfo:nil repeats:YES];
}

@end
