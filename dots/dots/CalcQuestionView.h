//
//  CalcQuestionDisplayView.h
//  dots
//
//  Created by tatsuya sagara on 12/03/09.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>

#import "DataManager.h"
#import "AudioManager.h"

#define QUESTION_ICON_X 3
#define QUESTION_ICON_Y 3

@interface CalcQuestionView : UIView
{
@private
    NSMutableArray *buffer_;
    DataManager    *dm_;
    CALayer        *leftLayer_[QUESTION_ICON_X*QUESTION_ICON_Y];
    CALayer        *rightLayer_[QUESTION_ICON_X*QUESTION_ICON_Y];
    UIImage        *myimg_;
    UIImageView    *calcImg_;
    UILabel        *labelLeft_;
    UILabel        *labelRight_;
    UILabel        *labelOperation_;
    UILabel        *labelSpeed_;
}

@end
