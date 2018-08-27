//
//  SettingIconViewController.m
//  dots
//
//  Created by tatsuya sagara on 12/02/11.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "SettingIconViewController.h"

#import "MainViewController.h"

@interface SettingIconViewController (private)
- (void)displayItemName;                     // 項目名の表示
- (void) setView;
@end

@implementation SettingIconViewController

@synthesize ButtonBall;
@synthesize ButtonAnimal1;
@synthesize ButtonAnimal2;
@synthesize ButtonAnimal3;
@synthesize ButtonFruits1;
@synthesize ButtonFruits2;
@synthesize ButtonFruits3;
@synthesize ButtonSweets1;
@synthesize ButtonSweets2;
@synthesize ButtonSweets3;
@synthesize LabelIconName;
@synthesize ButtonBack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        dm_ = [DataManager new];
        am_ = [AudioManager new];
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

    // 項目名表示
    [self displayItemName];

    isSetting=false;
    
    if( ICON_BALL == [dm_ getIcon] )
    {
        [ButtonBall setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else if( ICON_ANIMAL1 == [dm_ getIcon] )
    {
        [ButtonAnimal1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else if( ICON_ANIMAL2 == [dm_ getIcon] )
    {
        [ButtonAnimal2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else if( ICON_ANIMAL3 == [dm_ getIcon] )
    {
        [ButtonAnimal3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else if( ICON_FRUITS1 == [dm_ getIcon] )
    {
        [ButtonFruits1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else if( ICON_FRUITS2 == [dm_ getIcon] )
    {
        [ButtonFruits2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else if( ICON_FRUITS3 == [dm_ getIcon] )
    {
        [ButtonFruits3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else if( ICON_SWEETS1 == [dm_ getIcon] )
    {
        [ButtonSweets1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else if( ICON_SWEETS2 == [dm_ getIcon] )
    {
        [ButtonSweets2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else
    {
        [ButtonSweets3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
    /*
     * view初期化
     */
    [self setView];
}
// view初期化
- (void) setView {
    CGRect rect = self.view.bounds;
    CGRect mRect = CGRectMake(0,0,rect.size.height,rect.size.width); // 横画面専用なので高さと幅を逆にする
    siv_ = [[SettingIconView alloc] initWithFrame:mRect];
    siv_.opaque=YES;
    siv_.alpha=0.0;
    siv_.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:siv_];
}

- (void)viewDidUnload
{
    [self setButtonBall:nil];
    [self setButtonAnimal1:nil];
    [self setButtonAnimal2:nil];
    [self setButtonAnimal3:nil];
    [self setButtonFruits1:nil];
    [self setButtonFruits2:nil];
    [self setButtonFruits3:nil];
    [self setButtonSweets1:nil];
    [self setButtonSweets2:nil];
    [self setButtonSweets3:nil];
    [self setLabelIconName:nil];
    [self setButtonBack:nil];
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

// 画面が終了するときに「SettingViewController」の「onSetSetting」メソッドを呼ぶ
// 「Back」ボタンは除く
- (void)dealloc
{
    if (!isSetting && parent)
    {
//        SEL sel = sel_registerName("onSetSetting:");
//        [parent performSelector:sel withObject:nil afterDelay:0.0f];
        [parent performSelector:@selector(onSetSetting)];
    }
}
// このViewControllerを読んだオブジェクトを保存しておく
- (void)setIconDelegate:(id)p {
    parent = p;
    //closeAction = action;
}

/////////////////////////////////////////////////////////////
// 各種イベント
/////////////////////////////////////////////////////////////
// 戻るボタン
- (IBAction)IconBackSettingViewButton:(id)sender {
    isSetting = true;
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [self dismissViewControllerAnimated:NO completion:nil];
}
// ボールボタン
- (IBAction)IconBallButton:(id)sender {
    isSetting = false;
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setIcon:ICON_BALL];
    [NSThread sleepForTimeInterval:0.3];
    [self dismissViewControllerAnimated:NO completion:nil];
}
// 動物１ボタン
- (IBAction)IconAnimal1Button:(id)sender {
    isSetting = false;
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setIcon:ICON_ANIMAL1];
    [NSThread sleepForTimeInterval:0.3];
    [self dismissViewControllerAnimated:NO completion:nil];
}
// 動物２ボタン
- (IBAction)IconAnimal2Button:(id)sender {
    isSetting = false;
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setIcon:ICON_ANIMAL2];
    [NSThread sleepForTimeInterval:0.3];
    [self dismissViewControllerAnimated:NO completion:nil];
}
// 動物３ボタン
- (IBAction)IconAnimal3Button:(id)sender {
    isSetting = false;
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setIcon:ICON_ANIMAL3];
    [NSThread sleepForTimeInterval:0.3];
    [self dismissViewControllerAnimated:NO completion:nil];
}
// フルーツ１ボタン
- (IBAction)IconFruits1Button:(id)sender {
    isSetting = false;
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setIcon:ICON_FRUITS1];
    [NSThread sleepForTimeInterval:0.3];
    [self dismissViewControllerAnimated:NO completion:nil];
}
// フルーツ２ボタン
- (IBAction)IconFruits2Button:(id)sender {
    isSetting = false;
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setIcon:ICON_FRUITS2];
    [NSThread sleepForTimeInterval:0.3];
    [self dismissViewControllerAnimated:NO completion:nil];
}
// フルーツ３ボタン
- (IBAction)IconFruits3Button:(id)sender {
    isSetting = false;
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setIcon:ICON_FRUITS3];
    [NSThread sleepForTimeInterval:0.3];
    [self dismissViewControllerAnimated:NO completion:nil];
}
// お菓子１ボタン
- (IBAction)IconSweets1Button:(id)sender {
    isSetting = false;
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setIcon:ICON_SWEETS1];
    [NSThread sleepForTimeInterval:0.3];
    [self dismissViewControllerAnimated:NO completion:nil];
}
// お菓子２ボタン
- (IBAction)IconSweets2Button:(id)sender {
    isSetting = false;
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setIcon:ICON_SWEETS2];
    [NSThread sleepForTimeInterval:0.3];
    [self dismissViewControllerAnimated:NO completion:nil];
}
// お菓子３ボタン
- (IBAction)IconSweets3Button:(id)sender {
    isSetting = false;
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [dm_ setIcon:ICON_SWEETS3];
    [NSThread sleepForTimeInterval:0.3];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)CloseButton:(id)sender {
    isSetting = false;
    [am_ stopSound];
    [am_ playSoundFilename:@"click"];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)IconButtonDown:(id)sender {
    // iPhoneの場合、アイコンのサイズをボタンサイズ変更で実現する
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {

        UIScreen *screen = [UIScreen mainScreen];
        CGRect fullScreenRect = screen.bounds;
        int startPositionX = (fullScreenRect.size.width-480)/2;

        NSInteger tag = [sender tag];
        if( 0 == tag )
            ButtonBall.frame = CGRectMake(startPositionX+101, 126, LARGE_BUTTON_WIDTH, LARGE_BUTTON_HEIGHT);
        if( 1 == tag )
            ButtonAnimal1.frame = CGRectMake(startPositionX+289, 126, LARGE_BUTTON_WIDTH, LARGE_BUTTON_HEIGHT);
        if( 2 == tag )
            ButtonAnimal2.frame = CGRectMake(startPositionX+50, 48, LARGE_BUTTON_WIDTH, LARGE_BUTTON_HEIGHT);
        if( 3 == tag )
            ButtonAnimal3.frame = CGRectMake(startPositionX+147, 48, LARGE_BUTTON_WIDTH, LARGE_BUTTON_HEIGHT);
        if( 4 == tag )
            ButtonFruits1.frame = CGRectMake(startPositionX+242, 48, LARGE_BUTTON_WIDTH, LARGE_BUTTON_HEIGHT);
        if( 5 == tag )
            ButtonFruits2.frame = CGRectMake(startPositionX+339, 48, LARGE_BUTTON_WIDTH, LARGE_BUTTON_HEIGHT);
        if( 6 == tag )
            ButtonFruits3.frame = CGRectMake(startPositionX+60, 203, LARGE_BUTTON_WIDTH, LARGE_BUTTON_HEIGHT);
        if( 7 == tag )
            ButtonSweets1.frame = CGRectMake(startPositionX+147, 203, LARGE_BUTTON_WIDTH, LARGE_BUTTON_HEIGHT);
        if( 8 == tag )
            ButtonSweets2.frame = CGRectMake(startPositionX+242, 203, LARGE_BUTTON_WIDTH, LARGE_BUTTON_HEIGHT);
        if( 9 == tag )
            ButtonSweets3.frame = CGRectMake(startPositionX+339, 203, LARGE_BUTTON_WIDTH, LARGE_BUTTON_HEIGHT);
    }
}
- (IBAction)IconButtonDownExit:(id)sender {
    // iPhoneの場合、アイコンのサイズをボタンサイズ変更で実現する
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {

        UIScreen *screen = [UIScreen mainScreen];
        CGRect fullScreenRect = screen.bounds;
        int startPositionX = (fullScreenRect.size.width-480)/2;

        NSInteger tag = [sender tag];
        if( 0 == tag )
            ButtonBall.frame = CGRectMake(startPositionX+119, 136, NORMAL_BUTTON_WIDTH, NORMAL_BUTTON_HEIGHT);
        if( 1 == tag )
            ButtonAnimal1.frame = CGRectMake(startPositionX+311, 136, NORMAL_BUTTON_WIDTH, NORMAL_BUTTON_HEIGHT);
        if( 2 == tag )
            ButtonAnimal2.frame = CGRectMake(startPositionX+60, 58, NORMAL_BUTTON_WIDTH, NORMAL_BUTTON_HEIGHT);
        if( 3 == tag )
            ButtonAnimal3.frame = CGRectMake(startPositionX+157, 58, NORMAL_BUTTON_WIDTH, NORMAL_BUTTON_HEIGHT);
        if( 4 == tag )
            ButtonFruits1.frame = CGRectMake(startPositionX+252, 58, NORMAL_BUTTON_WIDTH, NORMAL_BUTTON_HEIGHT);
        if( 5 == tag )
            ButtonFruits2.frame = CGRectMake(startPositionX+349, 58, NORMAL_BUTTON_WIDTH, NORMAL_BUTTON_HEIGHT);
        if( 6 == tag )
            ButtonFruits3.frame = CGRectMake(startPositionX+60, 213, NORMAL_BUTTON_WIDTH, NORMAL_BUTTON_HEIGHT);
        if( 7 == tag )
            ButtonSweets1.frame = CGRectMake(startPositionX+157, 213, NORMAL_BUTTON_WIDTH, NORMAL_BUTTON_HEIGHT);
        if( 8 == tag )
            ButtonSweets2.frame = CGRectMake(startPositionX+252, 213, NORMAL_BUTTON_WIDTH, NORMAL_BUTTON_HEIGHT);
        if( 9 == tag )
            ButtonSweets3.frame = CGRectMake(startPositionX+349, 213, NORMAL_BUTTON_WIDTH, NORMAL_BUTTON_HEIGHT);
    }
}

/////////////////////////////////////////////////////////////
// 各種処理
/////////////////////////////////////////////////////////////
// 項目名表示
- (void)displayItemName
{
    NSString *strText = nil;
    
    // Icon
    LabelIconName.textColor = [UIColor blackColor];
    strText = NSLocalizedString(@"Icon", @"Icon Message");
    LabelIconName.text = strText;
    [self.view addSubview:LabelIconName];

    // Back Button
    strText = NSLocalizedString(@"Back", @"Back Button");
    [ButtonBack setTitle:strText forState:UIControlStateNormal];
}
@end
