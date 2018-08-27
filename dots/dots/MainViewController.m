//
//  SettingViewController.m
//  dots
//
//  Created by tatsuya sagara on 12/01/17.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController (private)
- (void)displayData;            // データの表示
// Count
- (void)OperationToggleCountButton; // Operationトグル処理(Count)
- (void)SpeedToggleCountButton;     // Speedトグル処理(Count)
- (void)SpeechToggleCountButton;    // Speechトグル処理(Count)
- (void)NumberToggleCountButton;    // Numberトグル処理
// Calc
- (void)OperationToggleCalcButton;  // Operationトグル処理(Calc)
- (void)SpeedToggleCalcButton;      // Speedトグル処理(Calc)
- (void)SpeechToggleCalcButton;     // Speechトグル処理(Calc)
- (void)OperatorToggleCalcButton;   // Operatorトグル処理
// Common
- (void)IconSelect;                 // Icon選択処理
// hold(Count)
- (void)OperationToggleCountButtonHold; // Operationトグル処理(Count)
- (void)SpeedToggleCountButtonHold;     // Speedトグル処理(Count)
- (void)SpeechToggleCountButtonHold;    // Speechトグル処理(Count)
- (void)NumberToggleCountButtonHold;    // Numberトグル処理
// Hold(Calc)
- (void)OperationToggleCalcButtonHold;  // Operationトグル処理(Calc)
- (void)SpeedToggleCalcButtonHold;      // Speedトグル処理(Calc)
- (void)SpeechToggleCalcButtonHold;     // Speechトグル処理(Calc)
- (void)OperatorToggleCalcButtonHold;   // Operatorトグル処理
// Hold(Common)
//- (void)IconSelectHold;                 // Icon選択処理

@end

@implementation MainViewController

@synthesize CharacterCountImage;
@synthesize CharacterCalcImage;
@synthesize ButtonCountOperation;
@synthesize ButtonCountSpeed;
@synthesize ButtonCountIcon;
@synthesize ButtonCountSpeech;
@synthesize ButtonCountNumber;

@synthesize ButtonCalcOperation;
@synthesize ButtonCalcSpeed;
@synthesize ButtonCalcIcon;
@synthesize ButtonCalcSpeech;
@synthesize ButtonCalcOperator;

@synthesize ButtonCountStart;
@synthesize ButtonCalcStart;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        countController_ = nil;
        calcQuestionController_ = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    /* 保存データ管理インスタンス生成 */
    dm_ = [DataManager new];
    
    /* 音声管理インスタンス生成＆初期化 */
    am_ = [AudioManager new];
    [am_ AudioInit];

    /* 「数える」、「計算」ボタン、「キャラクー」項目名表示 */
//    NSString *str = nil;
//    str = NSLocalizedString(@"Count", @"MainView Count StartButton Message");
//    [ButtonCountStart setTitle:str forState:UIControlStateNormal];
//    str = NSLocalizedString(@"Calc", @"MainView Count StartButton Message");
//    [ButtonCalcStart setTitle:str forState:UIControlStateNormal];
//    str = NSLocalizedString(@"Character", @"Character Message");
//    [ButtonCountIcon setTitle:str forState:UIControlStateNormal];
//    [ButtonCalcIcon setTitle:str forState:UIControlStateNormal];
    
    /*
     * 選択データ表示
     */
    [self displayData];
}

- (void)viewDidUnload
{
    [self setButtonCountOperation:nil];
    [self setButtonCountSpeed:nil];
    [self setButtonCountIcon:nil];
    [self setButtonCountSpeech:nil];
    [self setButtonCountNumber:nil];
    [self setButtonCalcOperator:nil];
    [self setButtonCalcOperation:nil];
    [self setButtonCalcSpeed:nil];
    [self setButtonCalcIcon:nil];
    [self setButtonCalcSpeech:nil];
    [self setButtonCountStart:nil];
    [self setButtonCalcStart:nil];
    [self setCharacterCountImage:nil];
    [self setCharacterCalcImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// 画面の向きの設定
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // 横モードのみ対応
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeRight) ||
            (interfaceOrientation == UIInterfaceOrientationLandscapeLeft));
}

// 戻る以外のボタンが押されたら呼ばれる
- (void)onSetSetting
{
    [self displayData];
}

#pragma mark - delegate

// Count Back Button Delegate
- (void) CountBackButtonDelegate {
    // スリープ禁止解除
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    // Count画面（子ビュー）を閉じる
    [self dismissViewControllerAnimated:NO completion:NULL];
    countController_ = nil;
} 

// Calc Back Button Delegate
- (void) QuestionBackButtonDelegate {
    // スリープ禁止解除
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    // Question画面（子ビュー）を閉じる
    [self dismissViewControllerAnimated:NO completion:NULL];
    calcQuestionController_ = nil;
} 

#pragma mark - event

// Operationボタン(Count)
- (IBAction)OperationCountOperationButton:(id)sender {
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setMode:MODE_COUNT];
    [self OperationToggleCountButton];
}

// Speedボタン(Count)
- (IBAction)OperationCountSpeedButton:(id)sender {
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setMode:MODE_COUNT];
    [self SpeedToggleCountButton];
}
// Iconボタン(Count)
- (IBAction)OperationCountIconButton:(id)sender {
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setMode:MODE_COUNT];
//    [NSThread sleepForTimeInterval:0.2];
    [self IconSelect];
}
// Speechボタン(Count)
- (IBAction)OperationCountSpeechButton:(id)sender {
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setMode:MODE_COUNT];
    [self SpeechToggleCountButton];
}
// Numberボタン(Count)
- (IBAction)OperationCountNumberButton:(id)sender {
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setMode:MODE_COUNT];
    [self NumberToggleCountButton];
}

// Operationボタン(Calc)
- (IBAction)OperationCalcOperationButton:(id)sender {
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setMode:MODE_CALC];
    [self OperationToggleCalcButton];
}
// Speedボタン(Calc)
- (IBAction)OperationCalcSpeedButton:(id)sender {
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setMode:MODE_CALC];
    [self SpeedToggleCalcButton];
}
// Iconボタン(Calc)
- (IBAction)OperationCalcIconButton:(id)sender {
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setMode:MODE_CALC];
//    [NSThread sleepForTimeInterval:0.2];
    [self IconSelect];
}
// Speechボタン(Calc)
- (IBAction)OperationCalcSpeechButton:(id)sender {
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setMode:MODE_CALC];
    [self SpeechToggleCalcButton];
}
// Operatorボタン(Calc)
- (IBAction)OperationCalcOperatorButton:(id)sender {
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setMode:MODE_CALC];
    [self OperatorToggleCalcButton];
}

// Count選択イベント
- (IBAction)OperationCountStartButton:(id)sender {
    // スリープ禁止
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    // モードをCountに設定
    [dm_ setMode:MODE_COUNT];
    // Countの実行画面に遷移
//    CountViewController *controller;
//    controller = [[CountViewController alloc] initWithNibName:nil bundle:nil];
//    controller.delegate = self;
//    [self presentModalViewController:controller animated:NO];
    countController_ = [[CountViewController alloc] initWithNibName:nil bundle:nil];
    countController_.delegate = self;
    [self presentViewController:countController_ animated:NO completion: nil];
}
// Calc選択イベント
- (IBAction)OperationCalcStartButton:(id)sender {
    // スリープ禁止
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    // モードをCalcに設定
    [dm_ setMode:MODE_CALC];
    // Calcの実行画面に遷移
//    CalcQuestionViewController *controller;
//    controller = [[CalcQuestionViewController alloc] initWithNibName:nil bundle:nil];
//    controller.delegate = self;
//    [self presentModalViewController:controller animated:NO];
    calcQuestionController_ = [[CalcQuestionViewController alloc] initWithNibName:nil bundle:nil];
    calcQuestionController_.delegate = self;
    [self presentViewController:calcQuestionController_ animated:NO completion: nil];
}

- (IBAction)LogoButton:(id)sender {
    InformationViewController *controller;
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0) {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.width == 568.0) {
        // iPhone 4インチ Retina用xib読み込み
        controller = [[InformationViewController alloc] initWithNibName:@"InformationViewController_iPhone4inchRetina" bundle:nil];
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone用xib読み込み
        controller = [[InformationViewController alloc] initWithNibName:@"InformationViewController_iPhone" bundle:nil];
    } else {
        // iPad用xib読み込み
        controller = [[InformationViewController alloc] initWithNibName:@"InformationViewController_iPad" bundle:nil];
    }
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion: nil];
}

// 割り込み時のタイマー停止
- (void)pauseEvent
{
    // Countのタイマー停止
    if( nil != countController_ ){
        [countController_ countPauseEvent];
    }
    // Calc(Question)のタイマー停止
    if( nil != calcQuestionController_ ){
        [calcQuestionController_ calcQuestionPauseEvent];
    }
}
// 割り込み終了時のタイマー開始
- (void)resumeEvent
{
    // Countのタイマー開始
    if( nil != countController_ ){
        [countController_ countResumeEvent];
    }
    // Calc(Question)のタイマー開始
    if( nil != calcQuestionController_ ){
        [calcQuestionController_ calcQuestionResumeEvent];
    }
}

#pragma mark - toggle

// Operationトグル処理
// Count
- (void)OperationToggleCountButton {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [ButtonCountOperation.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    } else {
        [ButtonCountOperation.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
    }
    [ButtonCountOperation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    if( OPERATION_AUTO == [dm_ getOperation] )
    {
        // Autoだった場合、Manulにする
        NSString *str = NSLocalizedString(@"CountOpManual", @"CountOpManual file");
        [ButtonCountOperation setTitle:str forState:UIControlStateNormal];
        [dm_ setOperation:OPERATION_MANUAL];
    }
    else if( OPERATION_MANUAL == [dm_ getOperation] )
    {
        // Manualだった場合、Autoにする
        NSString *str = NSLocalizedString(@"CountOpAuto", @"CountOpAuto file");
        [ButtonCountOperation setTitle:str forState:UIControlStateNormal];
        [dm_ setOperation:OPERATION_AUTO];
    }
}
// Calc
- (void)OperationToggleCalcButton {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [ButtonCalcOperation.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    } else {
        [ButtonCalcOperation.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
    }
    [ButtonCalcOperation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    if( OPERATION_AUTO == [dm_ getOperation] )
    {
        // Autoだった場合、Manulにする
        NSString *str = NSLocalizedString(@"CalcOpManual", @"CalcOpManual file");
        [ButtonCalcOperation setTitle:str forState:UIControlStateNormal];
        [dm_ setOperation:OPERATION_MANUAL];
    }
    else if( OPERATION_MANUAL == [dm_ getOperation] )
    {
        // Manualだった場合、Autoにする
        NSString *str = NSLocalizedString(@"CalcOpAuto", @"CalcOpAuto file");
        [ButtonCalcOperation setTitle:str forState:UIControlStateNormal];
        [dm_ setOperation:OPERATION_AUTO];
    }
}

// Speedトグル処理
// Count
- (void)SpeedToggleCountButton {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [ButtonCountSpeed.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    } else {
        [ButtonCountSpeed.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
    }
    [ButtonCountSpeed setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    if( SPEED_FAST == [dm_ getSpeed] )
    {
        // Hightだった場合、Normalにする
        NSString *str = NSLocalizedString(@"CountSpNormal", @"CountSpNormal file");
        [ButtonCountSpeed setTitle:str forState:UIControlStateNormal];
        [dm_ setSpeed:SPEED_NORMAL];
    }
    else if( SPEED_NORMAL == [dm_ getSpeed] )
    {
        // Normalだった場合、Lowにする
        NSString *str = NSLocalizedString(@"CountSpSlow", @"CountSpSlow file");
        [ButtonCountSpeed setTitle:str forState:UIControlStateNormal];
        [dm_ setSpeed:SPEED_SLOW];
    }
    else if( SPEED_SLOW == [dm_ getSpeed] )
    {
        // Lowだった場合、Highにする
        NSString *str = NSLocalizedString(@"CountSpFast", @"CountSpFast file");
        [ButtonCountSpeed setTitle:str forState:UIControlStateNormal];
        [dm_ setSpeed:SPEED_FAST];
    }
}

// Calc
- (void)SpeedToggleCalcButton {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [ButtonCalcSpeed.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    } else {
        [ButtonCalcSpeed.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
    }
    [ButtonCalcSpeed setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    if( SPEED_FAST == [dm_ getSpeed] )
    {
        // Hightだった場合、Normalにする
        NSString *str = NSLocalizedString(@"CalcSpNormal", @"CalcSpNormal file");
        [ButtonCalcSpeed setTitle:str forState:UIControlStateNormal];
        [dm_ setSpeed:SPEED_NORMAL];
    }
    else if( SPEED_NORMAL == [dm_ getSpeed] )
    {
        // Normalだった場合、Lowにする
        NSString *str = NSLocalizedString(@"CalcSpSlow", @"CalcSpSlow file");
        [ButtonCalcSpeed setTitle:str forState:UIControlStateNormal];
        [dm_ setSpeed:SPEED_SLOW];
    }
    else if( SPEED_SLOW == [dm_ getSpeed] )
    {
        // Lowだった場合、Highにする
        NSString *str = NSLocalizedString(@"CalcSpFast", @"CalcSpFast file");
        [ButtonCalcSpeed setTitle:str forState:UIControlStateNormal];
        [dm_ setSpeed:SPEED_FAST];
    }
}

// Icon選択処理
- (void)IconSelect {
    SettingIconViewController *controller;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.width == 568.0) {
        // iPhone 4インチ Retina用xib読み込み
        controller = [[SettingIconViewController alloc] initWithNibName:@"SettingIconViewController_iPhone4inchRetina" bundle:nil];
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone用xib読み込み
        controller = [[SettingIconViewController alloc] initWithNibName:@"SettingIconViewController_iPhone" bundle:nil];
    } else {
        // iPad用xib読み込み
        controller = [[SettingIconViewController alloc] initWithNibName:@"SettingIconViewController_iPad" bundle:nil];
    }
    [controller setIconDelegate:self];
    [self presentViewController:controller animated:NO completion: nil];
}

// Speechトグル処理
// Count
- (void)SpeechToggleCountButton {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [ButtonCountSpeech.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    } else {
        [ButtonCountSpeech.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
    }
    [ButtonCountSpeech setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    if( SPEECH_OFF == [dm_ getSpeech] )
    {
        // Offだった場合、Japaneseにする
        // Japanese フォント調整 start
        NSString *strFontSize = NSLocalizedString(@"jpn_font_size", @"Japanese Font Size");
        NSInteger iFontSize = 0;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            iFontSize = [strFontSize intValue];
        } else {
            iFontSize = [strFontSize intValue]*2;
        }
        [ButtonCountSpeech.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:iFontSize]];
        // Japanese フォント調整 end
       NSString *str = NSLocalizedString(@"CountScJapanese", @"CountScJapanese file");
        [ButtonCountSpeech setTitle:str forState:UIControlStateNormal];
        [dm_ setSpeech:SPEECH_JP];
    }
    else if( SPEECH_JP == [dm_ getSpeech] )
    {
        // Japaneseだった場合、Englishにする
        NSString *str = NSLocalizedString(@"CountScEnglish", @"CountScEnglish file");
        [ButtonCountSpeech setTitle:str forState:UIControlStateNormal];
        [dm_ setSpeech:SPEECH_EN];
    }
    else if( SPEECH_EN == [dm_ getSpeech] )
    {
        // Englishだった場合、Offにする
        NSString *str = NSLocalizedString(@"CountScNone", @"CountScNone file");
        [ButtonCountSpeech setTitle:str forState:UIControlStateNormal];
        [dm_ setSpeech:SPEECH_OFF];
    }
}
// Calc
- (void)SpeechToggleCalcButton {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [ButtonCalcSpeech.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    } else {
        [ButtonCalcSpeech.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
    }
    [ButtonCalcSpeech setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    if( SPEECH_OFF == [dm_ getSpeech] )
    {
        // Offだった場合、Japaneseにする
        // Japanese フォント調整 start
        NSString *strFontSize = NSLocalizedString(@"jpn_font_size", @"Japanese Font Size");
        NSInteger iFontSize = 0;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            iFontSize = [strFontSize intValue];
        } else {
            iFontSize = [strFontSize intValue]*2;
        }
        [ButtonCalcSpeech.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:iFontSize]];
        // Japanese フォント調整 end
        NSString *str = NSLocalizedString(@"CalcScJapanese", @"CalcScJapanese file");
        [ButtonCalcSpeech setTitle:str forState:UIControlStateNormal];
        [dm_ setSpeech:SPEECH_JP];
    }
    else if( SPEECH_JP == [dm_ getSpeech] )
    {
        // Japaneseだった場合、Englishにする
        NSString *str = NSLocalizedString(@"CalcScEnglish", @"CalcScEnglish file");
        [ButtonCalcSpeech setTitle:str forState:UIControlStateNormal];
        [dm_ setSpeech:SPEECH_EN];
    }
    else if( SPEECH_EN == [dm_ getSpeech] )
    {
        // Englishだった場合、Offにする
        NSString *str = NSLocalizedString(@"CalcScNone", @"CalcScNone file");
        [ButtonCalcSpeech setTitle:str forState:UIControlStateNormal];
        [dm_ setSpeech:SPEECH_OFF];
    }
}

// Numberトグル処理
- (void)NumberToggleCountButton {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [ButtonCountNumber.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    } else {
        [ButtonCountNumber.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
    }
    [ButtonCountNumber setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    if( COUNT1 == [dm_ getNumber] )
    {
        // 1-20だった場合、21-40にする
        NSString *str = NSLocalizedString(@"CountNm21-40", @"CountNm21-40 file");
        [ButtonCountNumber setTitle:str forState:UIControlStateNormal];
        [dm_ setNumber:COUNT2];
    }
    else if( COUNT2 == [dm_ getNumber] )
    {
        // 21-40だった場合、41-60にする
        NSString *str = NSLocalizedString(@"CountNm41-60", @"CountNm41-60 file");
        [ButtonCountNumber setTitle:str forState:UIControlStateNormal];
        [dm_ setNumber:COUNT3];
    }
    else if( COUNT3 == [dm_ getNumber] )
    {
        // 41-60だった場合、61-80にする
        NSString *str = NSLocalizedString(@"CountNm61-80", @"CountNm61-80 file");
        [ButtonCountNumber setTitle:str forState:UIControlStateNormal];
        [dm_ setNumber:COUNT4];
    }
    else if( COUNT4 == [dm_ getNumber] )
    {
        // 61-80だった場合、81-100にする
        NSString *str = NSLocalizedString(@"CountNm81-100", @"CountNm81-100 file");
        [ButtonCountNumber setTitle:str forState:UIControlStateNormal];
        [dm_ setNumber:COUNT5];
    }
    else if( COUNT5 == [dm_ getNumber] )
    {
        // 81-100だった場合、1-100にする
        NSString *str = NSLocalizedString(@"CountNm1-100", @"CountNm1-100 file");
        [ButtonCountNumber setTitle:str forState:UIControlStateNormal];
        [dm_ setNumber:COUNT6];
    }
    else if( COUNT6 == [dm_ getNumber] )
    {
        // 1-100だった場合、Randomにする
        // Random フォント調整 start
        NSString *strFontSize = NSLocalizedString(@"random_font_size", @"Random Font Size");
        NSInteger iFontSize = 0;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            iFontSize = [strFontSize intValue];
        } else {
            iFontSize = [strFontSize intValue]*2;
        }
        [ButtonCountNumber.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:iFontSize]];
        NSString *str = NSLocalizedString(@"CountNmRandom", @"CountNmRandom file");
        [ButtonCountNumber setTitle:str forState:UIControlStateNormal];
        [dm_ setNumber:COUNT7];
    }
    else if( COUNT7 == [dm_ getNumber] )
    {
        // Randomだった場合、1-20にする
        // Random フォント調整 end
        NSString *str = NSLocalizedString(@"CountNm1-20", @"CountNm1-20 file");
        [ButtonCountNumber setTitle:str forState:UIControlStateNormal];
        [dm_ setNumber:COUNT1];
    }
}
// Operatorトグル処理
- (void)OperatorToggleCalcButton {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [ButtonCalcOperator.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    } else {
        [ButtonCalcOperator.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40]];
    }
    [ButtonCalcOperator setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    if( OPERATOR_PLUS == [dm_ getOperator] )
    {
        // Plusだった場合、Minusにする
        NSString *str = NSLocalizedString(@"CalcOrMinus", @"CalcOrMinus file");
        [ButtonCalcOperator setTitle:str forState:UIControlStateNormal];
        [dm_ setOperator:OPERATOR_MINUS];
    }
    else if( OPERATOR_MINUS == [dm_ getOperator] )
    {
        // Minusだった場合、Plusにする
        NSString *str = NSLocalizedString(@"CalcOrPlus", @"CalcOrPlus file");
        [ButtonCalcOperator setTitle:str forState:UIControlStateNormal];
        [dm_ setOperator:OPERATOR_PLUS];
    }
}

#pragma mark - misc

/////////////////////////////////////////////////////////////
// 各種処理
/////////////////////////////////////////////////////////////
//#define SETTING_FONT_SIZE 13 // テスト用
- (void)displayData
{
    UIImage *img = nil;
    CGFloat fontSize = 0;

    img = [UIImage imageNamed:NSLocalizedString(@"CountButton", @"CountButton file")];
    [ButtonCountStart setImage:img forState:UIControlStateNormal];

    img = [UIImage imageNamed:NSLocalizedString(@"CalcButton", @"CalcButton file")];
    [ButtonCalcStart setImage:img forState:UIControlStateNormal];

    // フォントサイズ設定
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        fontSize = 20;  // iPhone用
    } else {
        fontSize = 40;  // iPad用
    }

    //
    // Countデータの表示
    //
    // DataMagagerをCountデータ取得用にする
    [dm_ setMode:MODE_COUNT];
    
    // Operation (Count)
    // フォントタイプ指定
    [ButtonCountOperation.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize]];
    // フォントの色設定
    [ButtonCountOperation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 表示する名前をUserDefaults.plistから読み込む
    if( OPERATION_AUTO == [dm_ getOperation] ) {
        // 自動
        NSString *str = NSLocalizedString(@"CountOpAuto", @"CountOpAuto file");
        [ButtonCountOperation setTitle:str forState:UIControlStateNormal];
    } else {
        // 手動
        NSString *str = NSLocalizedString(@"CountOpManual", @"CountOpManual file");
        [ButtonCountOperation setTitle:str forState:UIControlStateNormal];
    }
    
    // Speed (Count)
    [ButtonCountSpeed.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize]];
    [ButtonCountSpeed setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if( SPEED_FAST == [dm_ getSpeed] ) {
        NSString *str = NSLocalizedString(@"CountSpFast", @"CountSpFast file");
        [ButtonCountSpeed setTitle:str forState:UIControlStateNormal];
    } else if( SPEED_NORMAL == [dm_ getSpeed] ) {
        NSString *str = NSLocalizedString(@"CountSpNormal", @"CountSpNormal file");
        [ButtonCountSpeed setTitle:str forState:UIControlStateNormal];
    } else {
        NSString *str = NSLocalizedString(@"CountSpSlow", @"CountSpSlow file");
        [ButtonCountSpeed setTitle:str forState:UIControlStateNormal];
    }
    
    // Icon (Count)
    UIImage *imgCount = nil;
    if( ICON_BALL == [dm_ getIcon] ) {
        imgCount = [UIImage imageNamed:[dm_ getNameIcon:ICON_BALL Size:0]];
    } else if( ICON_ANIMAL1 == [dm_ getIcon] ) {
        imgCount = [UIImage imageNamed:[dm_ getNameIcon:ICON_ANIMAL1 Size:0]]; 
    } else if( ICON_ANIMAL2 == [dm_ getIcon] ) {
        imgCount = [UIImage imageNamed:[dm_ getNameIcon:ICON_ANIMAL2 Size:0]]; 
    } else if( ICON_ANIMAL3 == [dm_ getIcon] ) {
        imgCount = [UIImage imageNamed:[dm_ getNameIcon:ICON_ANIMAL3 Size:0]]; 
    } else if( ICON_FRUITS1 == [dm_ getIcon] ) {
        imgCount = [UIImage imageNamed:[dm_ getNameIcon:ICON_FRUITS1 Size:0]]; 
    } else if( ICON_FRUITS2 == [dm_ getIcon] ) {
        imgCount = [UIImage imageNamed:[dm_ getNameIcon:ICON_FRUITS2 Size:0]]; 
    } else if( ICON_FRUITS3 == [dm_ getIcon] ) {
        imgCount = [UIImage imageNamed:[dm_ getNameIcon:ICON_FRUITS3 Size:0]]; 
    } else if( ICON_SWEETS1 == [dm_ getIcon] ) {
        imgCount = [UIImage imageNamed:[dm_ getNameIcon:ICON_SWEETS1 Size:0]]; 
    } else if( ICON_SWEETS2 == [dm_ getIcon] ) {
        imgCount = [UIImage imageNamed:[dm_ getNameIcon:ICON_SWEETS2 Size:0]]; 
    } else  {
        imgCount = [UIImage imageNamed:[dm_ getNameIcon:ICON_SWEETS3 Size:0]]; 
    }
    [CharacterCountImage setImage:imgCount];
    
    // Speech (Count)
    [ButtonCountSpeech.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize]];
    [ButtonCountSpeech setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if( SPEECH_OFF == [dm_ getSpeech] ) {
        NSString *str = NSLocalizedString(@"CountScNone", @"CountScNone file");
        [ButtonCountSpeech setTitle:str forState:UIControlStateNormal];
    } if( SPEECH_JP == [dm_ getSpeech] ) {
        // Japanese フォント調整 start
        NSString *strFontSize = NSLocalizedString(@"jpn_font_size", @"Japanese Font Size");
        NSInteger iFontSize = 0;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            iFontSize = [strFontSize intValue];
        } else {
            iFontSize = [strFontSize intValue]*2;
        }
        [ButtonCountSpeech.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:iFontSize]];
        // Japanese フォント調整 end
        NSString *str = NSLocalizedString(@"CountScJapanese", @"CountScJapanese file");
        [ButtonCountSpeech setTitle:str forState:UIControlStateNormal];
    } if( SPEECH_EN == [dm_ getSpeech] ) {
        NSString *str = NSLocalizedString(@"CountScEnglish", @"CountScEnglish file");
        [ButtonCountSpeech setTitle:str forState:UIControlStateNormal];
    }
    
    // Number (Count)
    [ButtonCountNumber.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize]];
    [ButtonCountNumber setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if( COUNT1 == [dm_ getNumber] ) {
        NSString *str = NSLocalizedString(@"CountNm1-20", @"CountNm1-20 file");
        [ButtonCountNumber setTitle:str forState:UIControlStateNormal];
    } if( COUNT2 == [dm_ getNumber] ) {
        NSString *str = NSLocalizedString(@"CountNm21-40", @"CountNm21-40 file");
        [ButtonCountNumber setTitle:str forState:UIControlStateNormal];
    } if( COUNT3 == [dm_ getNumber] ) {
        NSString *str = NSLocalizedString(@"CountNm41-60", @"CountNm41-60 file");
        [ButtonCountNumber setTitle:str forState:UIControlStateNormal];
    } if( COUNT4 == [dm_ getNumber] ) {
        NSString *str = NSLocalizedString(@"CountNm61-80", @"CountNm61-80 file");
        [ButtonCountNumber setTitle:str forState:UIControlStateNormal];
    } if( COUNT5 == [dm_ getNumber] ) {
        NSString *str = NSLocalizedString(@"CountNm81-100", @"CountNm81-100 file");
        [ButtonCountNumber setTitle:str forState:UIControlStateNormal];
    } if( COUNT6 == [dm_ getNumber] ) {
        NSString *str = NSLocalizedString(@"CountNm1-100", @"CountNm1-100 file");
        [ButtonCountNumber setTitle:str forState:UIControlStateNormal];
    } if( COUNT7 == [dm_ getNumber] ) {
        // Random フォント調整 start
        NSString *strFontSize = NSLocalizedString(@"random_font_size", @"Random Font Size");
        NSInteger iFontSize = 0;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            iFontSize = [strFontSize intValue];
        } else {
            iFontSize = [strFontSize intValue]*2;
        }
        [ButtonCountNumber.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:iFontSize]];
        // Random フォント調整 end
        NSString *str = NSLocalizedString(@"CountNmRandom", @"CountNmRandom file");
        [ButtonCountNumber setTitle:str forState:UIControlStateNormal];
    }

    //
    // Calcデータの表示
    //
    [dm_ setMode:MODE_CALC];
    
    // Operation (Calc)
    [ButtonCalcOperation.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize]];
    [ButtonCalcOperation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if( OPERATION_AUTO == [dm_ getOperation] ) {
        NSString *str = NSLocalizedString(@"CalcOpAuto", @"CalcOpAuto file");
        [ButtonCalcOperation setTitle:str forState:UIControlStateNormal];
    } else {
        NSString *str = NSLocalizedString(@"CalcOpManual", @"CalcOpManual file");
        [ButtonCalcOperation setTitle:str forState:UIControlStateNormal];
    }
    
    // Speed (Calc)
    [ButtonCalcSpeed.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize]];
    [ButtonCalcSpeed setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if( SPEED_FAST == [dm_ getSpeed] ) {
        NSString *str = NSLocalizedString(@"CalcSpFast", @"CalcSpFast file");
        [ButtonCalcSpeed setTitle:str forState:UIControlStateNormal];
    } else if( SPEED_NORMAL == [dm_ getSpeed] ) {
        NSString *str = NSLocalizedString(@"CalcSpNormal", @"CalcSpNormal file");
        [ButtonCalcSpeed setTitle:str forState:UIControlStateNormal];
    } else {
        NSString *str = NSLocalizedString(@"CalcSpSlow", @"CalcSpSlow file");
        [ButtonCalcSpeed setTitle:str forState:UIControlStateNormal];
    }
    
    // Icon (Calc)
    UIImage *imgCalc = nil;
    if( ICON_BALL == [dm_ getIcon] ) {
        imgCalc = [UIImage imageNamed:[dm_ getNameIcon:ICON_BALL Size:0]]; 
    } else if( ICON_ANIMAL1 == [dm_ getIcon] ) {
        imgCalc = [UIImage imageNamed:[dm_ getNameIcon:ICON_ANIMAL1 Size:0]]; 
    } else if( ICON_ANIMAL2 == [dm_ getIcon] ) {
        imgCalc = [UIImage imageNamed:[dm_ getNameIcon:ICON_ANIMAL2 Size:0]]; 
    } else if( ICON_ANIMAL3 == [dm_ getIcon] ) {
        imgCalc = [UIImage imageNamed:[dm_ getNameIcon:ICON_ANIMAL3 Size:0]]; 
    } else if( ICON_FRUITS1 == [dm_ getIcon] ) {
        imgCalc = [UIImage imageNamed:[dm_ getNameIcon:ICON_FRUITS1 Size:0]]; 
    } else if( ICON_FRUITS2 == [dm_ getIcon] ) {
        imgCalc = [UIImage imageNamed:[dm_ getNameIcon:ICON_FRUITS2 Size:0]]; 
    } else if( ICON_FRUITS3 == [dm_ getIcon] ) {
        imgCalc = [UIImage imageNamed:[dm_ getNameIcon:ICON_FRUITS3 Size:0]]; 
    } else if( ICON_SWEETS1 == [dm_ getIcon] ) {
        imgCalc = [UIImage imageNamed:[dm_ getNameIcon:ICON_SWEETS1 Size:0]]; 
    } else if( ICON_SWEETS2 == [dm_ getIcon] ) {
        imgCalc = [UIImage imageNamed:[dm_ getNameIcon:ICON_SWEETS2 Size:0]]; 
    } else {
        imgCalc = [UIImage imageNamed:[dm_ getNameIcon:ICON_SWEETS3 Size:0]]; 
    }
    [CharacterCalcImage setImage:imgCalc];
    
    // Speech (Calc)
    [ButtonCalcSpeech.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize]];
    [ButtonCalcSpeech setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if( SPEECH_OFF == [dm_ getSpeech] ) {
        NSString *str = NSLocalizedString(@"CalcScNone", @"CalcScNone file");
        [ButtonCalcSpeech setTitle:str forState:UIControlStateNormal];
    } else if( SPEECH_JP == [dm_ getSpeech] ) {
        // Japanese フォント調整 start
        NSString *strFontSize = NSLocalizedString(@"jpn_font_size", @"Japanese Font Size");
        NSInteger iFontSize = 0;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            iFontSize = [strFontSize intValue];
        } else {
            iFontSize = [strFontSize intValue]*2;
        }
        [ButtonCalcSpeech.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:iFontSize]];
        // Japanese フォント調整 end
        NSString *str = NSLocalizedString(@"CalcScJapanese", @"CalcScJapanese file");
        [ButtonCalcSpeech setTitle:str forState:UIControlStateNormal];
    } else if( SPEECH_EN == [dm_ getSpeech] ) {
        NSString *str = NSLocalizedString(@"CalcScEnglish", @"CalcScEnglish file");
        [ButtonCalcSpeech setTitle:str forState:UIControlStateNormal];
    }
    
    // Operator (Calc)
    [ButtonCalcOperator.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize]];
    [ButtonCalcOperator setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if( OPERATOR_PLUS == [dm_ getOperator] ) {
        NSString *str = NSLocalizedString(@"CalcOrPlus", @"CalcOrPlus file");
        [ButtonCalcOperator setTitle:str forState:UIControlStateNormal];
    } else {
        NSString *str = NSLocalizedString(@"CalcOrMinus", @"CalcOrMinus file");
        [ButtonCalcOperator setTitle:str forState:UIControlStateNormal];
    }
}

@end
