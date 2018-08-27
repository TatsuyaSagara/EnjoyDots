//
//  CalcAnswerViewController.h
//  dots
//
//  Created by tatsuya sagara on 12/03/02.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "CalcAnswerView.h"

@protocol CalcAnswerViewDelegate <NSObject>
- (void) AnswerBackButtonDelegate; 
- (void) AnswerTapDelegate;
@end  

@interface CalcAnswerViewController : UIViewController
{
    id                 delegate;
@private
    DataManager       *dm_;
    AudioManager      *am_;
    NSTimer           *timer_;
    NSTimer           *operationTimer_;
    NSInteger          cnt_;
    CalcAnswerView    *cdv_;
}
@property (nonatomic, retain) id<CalcAnswerViewDelegate> delegate;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *TextAnswer;

- (IBAction)AnswerBackButton:(id)sender;

- (void)calcAnswerPauseEvent;
- (void)calcAnswerResumeEvent;

@end
