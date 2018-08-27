//
//  DataManager.h
//  dots
//
//  Created by tatsuya sagara on 12/03/03.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <Foundation/Foundation.h>

// 操作
enum op {
    OPERATION_AUTO,
    OPERATION_MANUAL,
    OPERATION_MAX
};
// 自動時の速度
enum sp {
    SPEED_FAST,
    SPEED_NORMAL,
    SPEED_SLOW,
    SPEED_MAX
};
// 使用するアイコン
enum ic {
    ICON_BALL,
    ICON_ANIMAL1,
    ICON_ANIMAL2,
    ICON_ANIMAL3,
    ICON_FRUITS1,
    ICON_FRUITS2,
    ICON_FRUITS3,
    ICON_SWEETS1,
    ICON_SWEETS2,
    ICON_SWEETS3,
    ICON_MAX
};
// 読み上げ音声
enum sc {
    SPEECH_OFF,
    SPEECH_JP,
    SPEECH_EN,
    SPEECH_MAX
};
// カウント実行範囲(countのみ)
enum cn {
    COUNT1,
    COUNT2,
    COUNT3,
    COUNT4,
    COUNT5,
    COUNT6,
    COUNT7,
    COUNT_MAX
};
// 四則演算(calcのみ)
enum at {
    OPERATOR_PLUS,
    OPERATOR_MINUS,
    OPERATOR_MAX
};
// モード
enum md {
    MODE_NONE,
    MODE_COUNT,
    MODE_CALC
};

// 読み上げ間隔
//#define SPEECH_TIME        1.0      // ベースとなる時間
//#define SPEECH_TIME_FAST   0.0      // 1秒間隔
//#define SPEECH_TIME_NORMAL 0.3      // 1.3秒間隔
//#define SPEECH_TIME_SLOW   0.7      // 1.7秒間隔
// v1.1
#define SPEECH_TIME        0.0      // ベースとなる時間
#define SPEECH_TIME_FAST   0.3      // 0.2秒間隔
#define SPEECH_TIME_NORMAL 0.4      // 0.3秒間隔
#define SPEECH_TIME_SLOW   0.7      // 0.7秒間隔

#define NUMBER_COUNT_1_START   1
#define NUMBER_COUNT_1_END    20 
#define NUMBER_COUNT_2_START  21
#define NUMBER_COUNT_2_END    40
#define NUMBER_COUNT_3_START  41
#define NUMBER_COUNT_3_END    60
#define NUMBER_COUNT_4_START  61
#define NUMBER_COUNT_4_END    80
#define NUMBER_COUNT_5_START  81
#define NUMBER_COUNT_5_END   100
#define NUMBER_COUNT_6_START   1
#define NUMBER_COUNT_6_END   100
#define NUMBER_COUNT_7_START   1
#define NUMBER_COUNT_7_END   100


@interface DataManager : NSObject
{
@private
    NSUserDefaults *userData_;                     // ユーザ設定データを保存
    NSString       *imgFnameIcon_[ICON_MAX];       // 表示アイコンのファイル名
    NSString       *imgFnameIcon72_[ICON_MAX];     // 表示アイコンのファイル名
    NSString       *imgFnameIcon232_[ICON_MAX];    // 表示アイコンのファイル名
    float           speedCount_[SPEED_MAX];        // 表示速度(Count用)
    float           speedCalc_[SPEED_MAX];         // hyoujisokudo(Calc用)
    NSInteger       count_[COUNT_MAX][2];          // アイコン表示数(Count用)
}

/*
 * Mode
 */
- (NSInteger)getMode;                   // Mode取得(Count or Calc)
- (void)setMode:(NSInteger)mode;        // Mode設定(Count or Calc)
/*
 * Operation
 */
- (NSInteger)getOperation;              // Operation取得
- (void)setOperation:(NSInteger)data;   // Operation設定
/*
 * Speed
 */
- (NSInteger)getSpeed;                  // Speed取得
- (void)setSpeed:(NSInteger)data;       // Speed設定
/*
 * Icon
 */
- (NSInteger)getIcon;                   // Icon取得
- (void)setIcon:(NSInteger)data;        // Icon設定
/*
 * Speech
 */
- (NSInteger)getSpeech;                 // Speech取得
- (void)setSpeech:(NSInteger)data;      // Speech設定
/*
 * Number (Count)
 */
- (NSInteger)getNumber;                 // Number取得
- (void)setNumber:(NSInteger)data;      // Number設定
/*
 *Operator (Calc)
 */
- (NSInteger)getOperator;                         // 四則演算取得
- (void)setOperator:(NSInteger)data;              // 四則演算設定
- (NSInteger)getOperatorAnswer;                   // 答え取得
- (void)setOperatorAnswer:(NSInteger)data;        // 答え設定
- (NSInteger)getOperatorQuestionLeft;             // Operatorの問題左辺取得
- (void)setOperatorQuestionLeft:(NSInteger)data;  // Operatorの問題左辺設定
- (NSInteger)getOperatorQuestionRight;            // Operatorの問題右辺取得
- (void)setOperatorQuestionRight:(NSInteger)data; // Operatorの問題右辺設定


- (NSString*)getNameIcon:(NSInteger)icon Size:(NSInteger)size;   // アイコン名取得(Icon)
//- (NSString*)getIconName:(NSInteger)mode;   // アイコン名取得(Icon)
//- (NSString*)getIconName72:(NSInteger)mode; // アイコン名取得(Icon)

- (float)getSpeedTime;                      // 表示速度取得

- (NSInteger)checkCount:(NSInteger)index;   // アイコン表示数取得(Count用)

@end
