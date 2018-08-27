//
//  CountDisplayView.h
//  dots
//
//  Created by tatsuya sagara on 12/03/08.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>

#import "DataManager.h"
#import "AudioManager.h"

//#define K_PAGE_NUM 100
#define NUM_X 13            // 横に表示する個数(X)
#define NUM_Y 8             // 縦に表示個数(Y)

@interface CountView : UIView
{
@private
    NSMutableArray *buffer_;
    UIImageView    *imageView_[NUM_X*NUM_Y];
    DataManager    *dm_;
    AudioManager   *am_;
    NSInteger       index_;
    CALayer        *layer_[NUM_X*NUM_Y];
    UIImage        *myimg_;
    UILabel        *labelOperation_;
    UILabel        *labelSpeed_;
}
@end
