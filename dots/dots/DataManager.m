//
//  DataManager.m
//  dots
//
//  Created by tatsuya sagara on 12/03/03.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

#pragma mark - initialize

// 初期値の読み込み（UserDefaults.plist）
+ (void)initialize
{
    NSString        *userDefaultsValuesPath;
    NSDictionary    *userDefaultsValuesDict;
    
    userDefaultsValuesPath = 
    [[NSBundle mainBundle] pathForResource:@"UserDefaults" 
                                    ofType:@"plist"];
    userDefaultsValuesDict = 
    [NSDictionary
     dictionaryWithContentsOfFile:userDefaultsValuesPath];
    
    [[NSUserDefaults standardUserDefaults]
     registerDefaults:userDefaultsValuesDict];
}

// 初期化処理
- (id) init
{
    if(self == [super init]) {
        // NSUserDefaultsの取得
        userData_ = [NSUserDefaults standardUserDefaults];

        // アイコン名設定
        imgFnameIcon_[ICON_BALL]    = @"ball.png";
        imgFnameIcon_[ICON_ANIMAL1] = @"animal1.png";
        imgFnameIcon_[ICON_ANIMAL2] = @"animal2.png";
        imgFnameIcon_[ICON_ANIMAL3] = @"animal3.png";
        imgFnameIcon_[ICON_FRUITS1] = @"fruits1.png";
        imgFnameIcon_[ICON_FRUITS2] = @"fruits2.png";
        imgFnameIcon_[ICON_FRUITS3] = @"fruits3.png";
        imgFnameIcon_[ICON_SWEETS1] = @"sweets1.png";
        imgFnameIcon_[ICON_SWEETS2] = @"sweets2.png";
        imgFnameIcon_[ICON_SWEETS3] = @"sweets3.png";

        imgFnameIcon72_[ICON_BALL]    = @"ball_72.png";
        imgFnameIcon72_[ICON_ANIMAL1] = @"animal1_72.png";
        imgFnameIcon72_[ICON_ANIMAL2] = @"animal2_72.png";
        imgFnameIcon72_[ICON_ANIMAL3] = @"animal3_72.png";
        imgFnameIcon72_[ICON_FRUITS1] = @"fruits1_72.png";
        imgFnameIcon72_[ICON_FRUITS2] = @"fruits2_72.png";
        imgFnameIcon72_[ICON_FRUITS3] = @"fruits3_72.png";
        imgFnameIcon72_[ICON_SWEETS1] = @"sweets1_72.png";
        imgFnameIcon72_[ICON_SWEETS2] = @"sweets2_72.png";
        imgFnameIcon72_[ICON_SWEETS3] = @"sweets3_72.png";

        imgFnameIcon232_[ICON_BALL]    = @"ball_232.png";
        imgFnameIcon232_[ICON_ANIMAL1] = @"animal1_232.png";
        imgFnameIcon232_[ICON_ANIMAL2] = @"animal2_232.png";
        imgFnameIcon232_[ICON_ANIMAL3] = @"animal3_232.png";
        imgFnameIcon232_[ICON_FRUITS1] = @"fruits1_232.png";
        imgFnameIcon232_[ICON_FRUITS2] = @"fruits2_232.png";
        imgFnameIcon232_[ICON_FRUITS3] = @"fruits3_232.png";
        imgFnameIcon232_[ICON_SWEETS1] = @"sweets1_232.png";
        imgFnameIcon232_[ICON_SWEETS2] = @"sweets2_232.png";
        imgFnameIcon232_[ICON_SWEETS3] = @"sweets3_232.png";

        // 速度設定(Count)
        speedCount_[SPEED_FAST]   = SPEECH_TIME_FAST;
        speedCount_[SPEED_NORMAL] = SPEECH_TIME_NORMAL;
        speedCount_[SPEED_SLOW]   = SPEECH_TIME_SLOW;
        
        // 速度設定(Calc)
        speedCalc_[SPEED_FAST]   = SPEECH_TIME_FAST;
        speedCalc_[SPEED_NORMAL] = SPEECH_TIME_NORMAL;
        speedCalc_[SPEED_SLOW]   = SPEECH_TIME_SLOW;
        
        // 表示個数設定：開始-終了数(Count用) ※値は0インデックス
        count_[COUNT1][0] = NUMBER_COUNT_1_START - 1;    // 開始
        count_[COUNT1][1] = NUMBER_COUNT_1_END   - 1;    // 終了
        count_[COUNT2][0] = NUMBER_COUNT_2_START - 1;
        count_[COUNT2][1] = NUMBER_COUNT_2_END   - 1;
        count_[COUNT3][0] = NUMBER_COUNT_3_START - 1;
        count_[COUNT3][1] = NUMBER_COUNT_3_END   - 1;
        count_[COUNT4][0] = NUMBER_COUNT_4_START - 1;
        count_[COUNT4][1] = NUMBER_COUNT_4_END   - 1;
        count_[COUNT5][0] = NUMBER_COUNT_5_START - 1;
        count_[COUNT5][1] = NUMBER_COUNT_5_END   - 1;
        count_[COUNT6][0] = NUMBER_COUNT_6_START - 1;
        count_[COUNT6][1] = NUMBER_COUNT_6_END   - 1;
        count_[COUNT7][0] = NUMBER_COUNT_7_START - 1;
        count_[COUNT7][1] = NUMBER_COUNT_7_END   - 1;
    }
	
    return self;
}

#pragma mark - mode

// -----------------------------------------
// Mode
//   これをMODE_COUNTにしてDataManagerからgetOperationとかすると現在選択されている【Count】の操作モードを取得出来る
//   MODE_CALCにしてgetOperationとすると現在選択されている【Calc】の操作モードを取得出来る
// -----------------------------------------
// モードの取得(Count or Calc)
- (NSInteger)getMode
{
    return [userData_ integerForKey:@"mode"];
}
// モードの設定(Count or Calc)
- (void)setMode:(NSInteger)mode
{
    [userData_ setInteger:mode forKey:@"mode"];
}

// -----------------------------------------
// Operation
//   現在選択されている【操作】の設定と取得をする
// -----------------------------------------
// Operation取得
- (NSInteger)getOperation
{
    if( [userData_ integerForKey:@"mode"] == MODE_COUNT){
        // Count用
        return [userData_ integerForKey:@"count_operation"];
    }else{
        // Calc用
        return [userData_ integerForKey:@"calc_operation"];
    }
}
// Operation設定
- (void)setOperation:(NSInteger)data
{
    if( [userData_ integerForKey:@"mode"] == MODE_COUNT){
        // Count用
        [userData_ setInteger:data forKey:@"count_operation"];
    }else{
        // Calc用
        [userData_ setInteger:data forKey:@"calc_operation"];
    }
}
// -----------------------------------------
// Speed
//   現在選択されている【速度】の設定と取得をする
// -----------------------------------------
// Speed取得
- (NSInteger)getSpeed
{
    if( [userData_ integerForKey:@"mode"] == MODE_COUNT){
        // Count用
        return [userData_ integerForKey:@"count_speed"];
    }else{
        // Calc用
        return [userData_ integerForKey:@"calc_speed"];
    }
}
// Speed設定
- (void)setSpeed:(NSInteger)data
{
    if( [userData_ integerForKey:@"mode"] == MODE_COUNT){
        // Count用
        [userData_ setInteger:data forKey:@"count_speed"];
    }else{
        // Calc用
        [userData_ setInteger:data forKey:@"calc_speed"];
    }
}
// -----------------------------------------
// Icon
// -----------------------------------------
// Icon取得
- (NSInteger)getIcon
{
    if( [userData_ integerForKey:@"mode"] == MODE_COUNT)
    {
        // Count用
        return [userData_ integerForKey:@"count_icon"];
    }
    else
    {
        // Calc用
        return [userData_ integerForKey:@"calc_icon"];
    }
}
// Icon設定
- (void)setIcon:(NSInteger)data
{
    if( [userData_ integerForKey:@"mode"] == MODE_COUNT)
    {
        // Count用
        [userData_ setInteger:data forKey:@"count_icon"];
    }
    else
    {
        // Calc用
        [userData_ setInteger:data forKey:@"calc_icon"];
    }
}
// -----------------------------------------
// Speech
// -----------------------------------------
// Speech取得
- (NSInteger)getSpeech
{
    if( [userData_ integerForKey:@"mode"] == MODE_COUNT)
    {
        // Count用
        return [userData_ integerForKey:@"count_speech"];
    }
    else
    {
        // Calc用
        return [userData_ integerForKey:@"calc_speech"];
    }
}

// Speech設定
- (void)setSpeech:(NSInteger)data
{
    if( [userData_ integerForKey:@"mode"] == MODE_COUNT)
    {
        // Count用
        [userData_ setInteger:data forKey:@"count_speech"];
    }
    else
    {
        // Calc用
        [userData_ setInteger:data forKey:@"calc_speech"];
    }
}
// -----------------------------------------
// Number
// -----------------------------------------
// Number取得
- (NSInteger)getNumber
{
    if( [userData_ integerForKey:@"mode"] == MODE_COUNT)
    {
        // Count用
        return [userData_ integerForKey:@"count_number"];
    }
    else
    {
        // Calc用
        return [userData_ integerForKey:@"calc_number"];
    }
}
// Number設定
- (void)setNumber:(NSInteger)data
{
    if( [userData_ integerForKey:@"mode"] == MODE_COUNT)
    {
        // Count用
        [userData_ setInteger:data forKey:@"count_number"];
    }
    else
    {
        // Calc用
        [userData_ setInteger:data forKey:@"calc_number"];
    }
}
// -----------------------------------------
// Operator
// -----------------------------------------
// Operator取得
- (NSInteger)getOperator
{
    // Calc用
    return [userData_ integerForKey:@"calc_operator"];
}
// Operator設定
- (void)setOperator:(NSInteger)data
{
    // Calc用
    [userData_ setInteger:data forKey:@"calc_operator"];
}
// Operatorの答え取得
- (NSInteger)getOperatorAnswer
{
    // Calc用
    return [userData_ integerForKey:@"calc_operator_answer"];
}
// Operatorの答え設定
- (void)setOperatorAnswer:(NSInteger)data
{
    // Calc用
    [userData_ setInteger:data forKey:@"calc_operator_answer"];
}
// Operatorの問題左辺取得
- (NSInteger)getOperatorQuestionLeft
{
    // Calc用
    return [userData_ integerForKey:@"calc_operator_question_left"];
}
// Operatorの問題左辺設定
- (void)setOperatorQuestionLeft:(NSInteger)data
{
    // Calc用
    [userData_ setInteger:data forKey:@"calc_operator_question_left"];
}
// Operatorの問題右辺取得
- (NSInteger)getOperatorQuestionRight
{
    // Calc用
    return [userData_ integerForKey:@"calc_operator_question_right"];
}
// Operatorの問題右辺設定
- (void)setOperatorQuestionRight:(NSInteger)data
{
    // Calc用
    [userData_ setInteger:data forKey:@"calc_operator_question_right"];
}

#pragma mark - misc

// アイコン名取得
// Icon
- (NSString*)getNameIcon:(NSInteger)icon Size:(NSInteger)size
{
    if( 0 == size ){
        return imgFnameIcon_[icon];
    }
    else if( 72 == size ) {
        return imgFnameIcon72_[icon];
    }
    else if( 232 == size ) {
        return imgFnameIcon232_[icon];
    }
    else {
        return imgFnameIcon_[icon];
    }
}
//- (NSString*)getIconName:(NSInteger)icon
//{
//    return imgFnameIcon_[icon];
//}
//- (NSString*)getIconName72:(NSInteger)icon
//{
//    return imgFnameIcon72_[icon];
//}

// 表示速度取得
- (float)getSpeedTime
{
    if( [userData_ integerForKey:@"mode"] == MODE_COUNT)
    {
        // Countの場合
        return speedCount_[[userData_ integerForKey:@"count_speed"]] + SPEECH_TIME;
    }
    else
    {
        // Calcの場合
        if( SPEECH_OFF == [self getSpeech] )
        {
            // 音声なしの場合は速くする。
            return speedCalc_[[userData_ integerForKey:@"calc_speed"]] + SPEECH_TIME;
        }
        else {
            return speedCalc_[[userData_ integerForKey:@"calc_speed"]] + SPEECH_TIME;
        }
    }
}

// アイコン表示数取得(Count用)
// 0インデックスの値を返却する
- (NSInteger)checkCount:(NSInteger)index
{
    // CountがRandomの場合
    if( self.getNumber == COUNT7 ){
        return arc4random() % 100; // 0〜99が返却される
    }
    
    if( (index < count_[[userData_ integerForKey:@"count_number"]][0]) || count_[[userData_ integerForKey:@"count_number"]][1] < index )
    {
        return count_[[userData_ integerForKey:@"count_number"]][0];
    }
    
    return index;
}

@end
