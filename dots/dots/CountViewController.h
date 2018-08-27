//
//  CountViewController.h
//  dots
//
//  Created by tatsuya sagara on 12/03/05.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CountView.h"

@protocol CountViewDelegate  
- (void) CountBackButtonDelegate;  
@end  

@interface CountViewController : UIViewController
{
    id                   delegate;
@private
    DataManager         *dm_;
    AudioManager        *am_;
    NSTimer             *operationTimer_;
    CountView           *cdv_;
    UIButton            *btn1_;
}
@property (nonatomic, retain) id delegate; 
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *BackButton;

- (IBAction) CountBackButton:(id)sender;

- (void)countPauseEvent;
- (void)countResumeEvent;

@end
