//
//  AudioManager.h
//  dots
//
//  Created by tatsuya sagara on 12/03/03.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>
#include <AVFoundation/AVFoundation.h> 

#import "DataManager.h"

// 足す、引く、和の音声インデックス
enum ats {
    OPERATOR_PLUS_SOUND_INDEX = 101,
    OPERATOR_MINUS_SOUND_INDEX,
    OPERATOR_EQUALS_SOUND_INDEX
};

@interface AudioManager : NSObject
{
    ALCcontext  *alContext_;
    NSInteger    flg;
@private
    DataManager *dm_;
    ALuint       sources_;
    ALuint       buffers_;
    ALsizei      dataSize_;
    ALCdevice   *device_;
    
    AVAudioPlayer *audio;
}

- (void) AudioInit;
- (void) AudioTerm;
- (void) playSoundCount:(NSInteger)cnt;
- (void) playSoundFilename:(NSString*)fileName;
- (void) stopSound;

@end
