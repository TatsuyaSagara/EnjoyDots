//
//  SettingIconViewController.h
//  dots
//
//  Created by tatsuya sagara on 12/02/11.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"
#import "AudioManager.h"
#import "SettingIconView.h"

// アイコンのボタンサイズ
#define NORMAL_BUTTON_WIDTH  72
#define NORMAL_BUTTON_HEIGHT 72
#define LARGE_BUTTON_WIDTH   92
#define LARGE_BUTTON_HEIGHT  92

@interface SettingIconViewController : UIViewController
{
    DataManager  *dm_;
    AudioManager *am_;
    id parent;
    BOOL isSetting;
    SettingIconView *siv_;
}

- (void)setIconDelegate:(id)parent;

// 戻るボタンイベント
- (IBAction)IconBackSettingViewButton:(id)sender;

// Iconボタンイベント
- (IBAction)IconBallButton:(id)sender;
- (IBAction)IconAnimal1Button:(id)sender;
- (IBAction)IconAnimal2Button:(id)sender;
- (IBAction)IconAnimal3Button:(id)sender;
- (IBAction)IconFruits1Button:(id)sender;
- (IBAction)IconFruits2Button:(id)sender;
- (IBAction)IconFruits3Button:(id)sender;
- (IBAction)IconSweets1Button:(id)sender;
- (IBAction)IconSweets2Button:(id)sender;
- (IBAction)IconSweets3Button:(id)sender;
- (IBAction)CloseButton:(id)sender;

- (IBAction)IconButtonDown:(id)sender;
- (IBAction)IconButtonDownExit:(id)sender;
// Iconボタンプロパティ
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonBall;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonAnimal1;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonAnimal2;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonAnimal3;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonFruits1;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonFruits2;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonFruits3;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonSweets1;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonSweets2;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonSweets3;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *LabelIconName;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonBack;
@end
