//
//  SettingViewController.h
//  dots
//
//  Created by tatsuya sagara on 12/01/17.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CountViewController.h"
#import "CalcQuestionViewController.h"
#import "SettingIconViewController.h"
#import "InformationViewController.h"
#import "DataManager.h"
#import "AudioManager.h"

@interface MainViewController : UIViewController <CountViewDelegate,CalcQuestionViewDelegate>
{
    CountViewController         *countController_;
    CalcQuestionViewController  *calcQuestionController_;
@private
    DataManager  *dm_;
    AudioManager *am_;
}
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *CharacterCountImage;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *CharacterCalcImage;

- (IBAction)LogoButton:(id)sender;

// アイコンイベント
// Count
- (IBAction)OperationCountOperationButton:(id)sender;
- (IBAction)OperationCountSpeedButton:(id)sender;
- (IBAction)OperationCountIconButton:(id)sender;
- (IBAction)OperationCountSpeechButton:(id)sender;
- (IBAction)OperationCountNumberButton:(id)sender;

// Calc
- (IBAction)OperationCalcOperationButton:(id)sender;
- (IBAction)OperationCalcSpeedButton:(id)sender;
- (IBAction)OperationCalcIconButton:(id)sender;
- (IBAction)OperationCalcSpeechButton:(id)sender;
- (IBAction)OperationCalcOperatorButton:(id)sender;

// Count & Calc Startボタン
- (IBAction)OperationCountStartButton:(id)sender;
- (IBAction)OperationCalcStartButton:(id)sender;

// アイコンプロパティ
// Count
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonCountOperation;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonCountSpeed;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonCountIcon;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonCountSpeech;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonCountNumber;

// Calc
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonCalcOperation;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonCalcSpeed;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonCalcIcon;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonCalcSpeech;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonCalcOperator;

// Count & Calc Item Name
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonCountStart;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *ButtonCalcStart;

- (void)pauseEvent;
- (void)resumeEvent;
- (void)onSetSetting;

@end
