//
//  CalcViewController.h
//  dots
//
//  Created by tatsuya sagara on 12/03/02.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CalcAnswerViewController.h"
#import "CalcQuestionView.h"

@protocol CalcQuestionViewDelegate  
- (void) QuestionBackButtonDelegate;  
@end  

@interface CalcQuestionViewController : UIViewController <CalcAnswerViewDelegate>
{
    id                   delegate;
    CalcAnswerViewController *calcAnswerController_;
@private
    DataManager         *dm_;
    AudioManager        *am_;
    NSTimer             *timer_;
    NSTimer             *operationTimer_;
    NSInteger            cnt_;
    CalcQuestionView    *cdv_;
}
@property (nonatomic, retain) id delegate; 
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *TextLeftNumber;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *TextRightNumber;

// Back
- (IBAction)QuestionBackButton:(id)sender;

- (void)calcQuestionPauseEvent;
- (void)calcQuestionResumeEvent;

@end
