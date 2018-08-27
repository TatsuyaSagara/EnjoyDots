//
//  CalcAnswerDisplayView.h
//  dots
//
//  Created by tatsuya sagara on 12/03/11.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>

#import "DataManager.h"
#import "AudioManager.h"

#define ANSWER_ICON_X 6
#define ANSWER_ICON_Y 3
#define ANSWER_ICON_NUM 18

@interface CalcAnswerView : UIView
{
@private
    NSMutableArray *buffer_;
    DataManager    *dm_;
    CALayer        *layer_[ANSWER_ICON_X*ANSWER_ICON_Y];
    UIImageView    *imageView_answer_[ANSWER_ICON_NUM];
    UIImage        *myimg_;
    UIImageView    *calcImg_;
    UILabel        *labelAnswer_;
    UILabel        *labelOperation_;
    UILabel        *labelSpeed_;
}

@end
