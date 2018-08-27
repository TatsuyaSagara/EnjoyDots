//
//  AudioManager.m
//  dots
//
//  Created by tatsuya sagara on 12/03/03.
//  Copyright (c) 2012年 Individual. All rights reserved.
//

// 自動 : AV Foundation
// 手動 : OpenAL

#import "AudioManager.h"

static ALCcontext *g_alContext;
static ALuint     g_sources;
static ALuint     g_buffers;

#define _SOUND_EFFECT_ 1

#pragma mark - Prototype declaration

static ALvoid* GetOpenALAudioData (CFURLRef fileURL, ALsizei* dataSize, ALenum* dataFormat, ALsizei *sampleRate);
static void SetAudioSessionListener (ALCcontext *acon);
static void SetDataSourceBuf(ALuint sources_, ALuint buffers_);

void openALInterruptionListener (void *inClientData, UInt32 inInterruptionState);

#pragma mark - Function

static ALvoid* GetOpenALAudioData(CFURLRef fileURL, ALsizei* dataSize, ALenum* dataFormat, ALsizei *sampleRate)
{
    OSStatus    err;
    UInt32      size;
    ALvoid*     data = nil;
    
    // オーディオファイルを開く
    ExtAudioFileRef audioFile = NULL;
    err = ExtAudioFileOpenURL(fileURL, &audioFile);
    if (err) {
        goto Exit;
    }
    
    // オーディオデータフォーマットを取得する
    AudioStreamBasicDescription fileFormat;
    size = sizeof(fileFormat);
    err = ExtAudioFileGetProperty(
                                  audioFile, kExtAudioFileProperty_FileDataFormat, &size, &fileFormat);
    if (err) {
        goto Exit;
    }
    
    // アウトプットフォーマットを設定する
    AudioStreamBasicDescription outputFormat;
    outputFormat.mSampleRate        = fileFormat.mSampleRate;
    outputFormat.mChannelsPerFrame  = fileFormat.mChannelsPerFrame;
    outputFormat.mFormatID          = kAudioFormatLinearPCM;
    outputFormat.mBytesPerPacket    = 2 * outputFormat.mChannelsPerFrame;
    outputFormat.mFramesPerPacket   = 1;
    outputFormat.mBytesPerFrame     = 2 * outputFormat.mChannelsPerFrame;
    outputFormat.mBitsPerChannel    = 16;
    outputFormat.mFormatFlags       = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
    err = ExtAudioFileSetProperty(audioFile, kExtAudioFileProperty_ClientDataFormat, sizeof(outputFormat), &outputFormat);
    if (err) {
        goto Exit;
    }
    
    // フレーム数を取得する
    SInt64  fileLengthFrames = 0;
    size = sizeof(fileLengthFrames);
    err = ExtAudioFileGetProperty(audioFile, kExtAudioFileProperty_FileLengthFrames, &size, &fileLengthFrames);
    if (err) {
        goto Exit;
    }

    // バッファを用意する
    AudioBufferList dataBuffer;
    UInt32 bufferSize = (UInt32)fileLengthFrames * outputFormat.mBytesPerFrame;;
    data = malloc(bufferSize);
    if (!data) {
        goto Exit;
    }
    dataBuffer.mNumberBuffers = 1;
    dataBuffer.mBuffers[0].mDataByteSize = bufferSize;
    dataBuffer.mBuffers[0].mNumberChannels = outputFormat.mChannelsPerFrame;
    dataBuffer.mBuffers[0].mData = data;
    
    // バッファにデータを読み込む
    err = ExtAudioFileRead(audioFile, (UInt32*)&fileLengthFrames, &dataBuffer);
    if (err) {
        free(data);
        goto Exit;
    }
    
    // 出力値を設定する
    *dataSize   = (ALsizei)bufferSize;
    *dataFormat = (outputFormat.mChannelsPerFrame > 1) ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
    *sampleRate = (ALsizei)outputFormat.mSampleRate;
    
Exit:
    // エラーの場合ログを出力する
    if (err != noErr) {
        NSLog(@"GetOpenALAudioData() err = %d", (int)err);
    }
    
    // オーディオファイルを破棄する
    if (audioFile) {
        ExtAudioFileDispose(audioFile);
    }
    
    // データが読み込まれたバッファを返却する
    return data;
}

// 割り込み発生時の処理
void openALInterruptionListener (
                                 void *inClientData,
                                 UInt32 inInterruptionState
                                 ){
    if (inInterruptionState == kAudioSessionBeginInterruption) {
        // 割り込みが発生した場合、一時的にを音を止める。
        alcMakeContextCurrent (NULL);
//        alcSuspendContext(g_alContext);
//        AudioSessionSetActive(false);
//        alSourcePause(g_sources);
    } else if (inInterruptionState == kAudioSessionEndInterruption) {
        // 復帰した場合、音を再会
//        AudioSessionSetActive(true);
        alcMakeContextCurrent (g_alContext);
//        alcProcessContext(g_alContext);
//        alSourcePlay(g_sources);
    }
}

// 割り込み発生時の関数を登録
static void SetAudioSessionListener(ALCcontext *alContext) {
// v1.2.1 chg
//    AudioSessionInitialize (
//                            NULL, // 1
//                            NULL, // 2
//                            openALInterruptionListener, // 3
//                            NULL // 4
//                            );
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];

    g_alContext = alContext;
    
    // 再生中に効果音を鳴らせるように設定する

// v1.2.1 chg
//    UInt32 category = kAudioSessionCategory_AmbientSound;
//    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
//    AudioSessionSetActive(true);
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
    [audioSession setActive:YES error:nil];
    
    return;
}

static void SetDataSourceBuf(ALuint sources_, ALuint buffers_) {

    g_sources = sources_;
    g_buffers = buffers_;
}

@interface AudioManager (private)
- (void) playSoundMP3filename:(NSString*)fileName;
@end

@implementation AudioManager

- (id) init {
    if(self == [super init]) {
        dm_ = [DataManager new];
    }
    
    return self;
}

#pragma mark - Public methods

- (void) AudioInit {
        
    // OpneALデバイスを開く
    device_ = alcOpenDevice(NULL);
    
    // 割り込みリスナー登録
    SetAudioSessionListener(alContext_);

    // OpenALコンテキスを作成して、カレントにする
    alContext_ = alcCreateContext(device_, NULL);
    alcMakeContextCurrent(alContext_);
}

- (void) AudioTerm {

    // カレントの設定削除
    alcMakeContextCurrent(NULL);
    
    // OpenALコンテキスを破棄
    alcDestroyContext(alContext_);    

    // OpneALデバイスを閉じる
    alcCloseDevice(device_);
}

- (void) playSoundCount:(NSInteger)cnt {
    
    // 範囲(1-103)外の場合何もしない
    if( cnt < 1 || 103 <cnt ) return;
    
    // サウンドファイルパスを取得する
    NSString*   fileName = nil;
    NSString*   strLanguage;
    if( SPEECH_JP == [dm_ getSpeech] ) strLanguage = @"jpn";
    else if( SPEECH_EN == [dm_ getSpeech] ) strLanguage = @"eng";
    else return;
    switch (cnt)
    {
        case OPERATOR_PLUS_SOUND_INDEX:
            fileName = [ NSString stringWithFormat : @"%@_tasu", strLanguage];
            break;
        case OPERATOR_MINUS_SOUND_INDEX:
            fileName = [ NSString stringWithFormat : @"%@_hiku", strLanguage];
            break;
        case OPERATOR_EQUALS_SOUND_INDEX:
            fileName = [ NSString stringWithFormat : @"%@_wa", strLanguage];
            break;
        default:
            fileName = [ NSString stringWithFormat : @"%@_%03ld", strLanguage, (long)cnt];
            break;
    }

    [self playSoundMP3filename:fileName];
}

// ファイル名を指定して音声を鳴動
- (void) playSoundFilename:(NSString*)filename {
    
    [self playSoundMP3filename:filename];
}

- (void) stopSound {

    // オーディオを停止する
    alSourceStop(sources_);
    
    // Source にアタッチされた複数の Buffer をキューから取り除く
    alSourceUnqueueBuffers(sources_, 1, &buffers_);
    
    alDeleteBuffers( 1, &buffers_ );
    alDeleteSources( 1, &sources_ );
}

// ファイル名を指定して鳴動させる
// MP3形式、拡張子無しで指定
- (void) playSoundMP3filename:(NSString*)fileName {
    
    // 範囲(1-103)外の場合何もしない
    if( fileName == nil ) return;

    // 自動の場合は、AV Foundationを使う v1.1
    if( OPERATION_AUTO == [dm_ getOperation] ){
        NSString      *path  = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];  
        NSURL         *url   = [NSURL fileURLWithPath:path];  
        audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];  
        audio.enableRate = YES;
        if( SPEED_FAST == [dm_ getSpeed] ){
            audio.rate = 3.4;
        }else if( SPEED_NORMAL == [dm_ getSpeed] ){
            audio.rate = 2.6;
        }else{
            audio.rate = 1.8;
        }
        [audio play];
    // 手動の場合は、OpenALを使う
    }else{
        // 初期化
        alGetError();
    
        // バッファとソースを作成する
        alDeleteBuffers( 1, &buffers_ );
        alDeleteSources( 1, &sources_ );

        alGenBuffers(1, &buffers_);
        alGenSources(1, &sources_);
        
        // サウンドファイルパスを取得する
        NSString*   path;
        path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
    
        // オーディオデータを取得する
        ALvoid* audioData;
        ALenum  dataFormat;
        ALsizei sampleRate;
        audioData = GetOpenALAudioData(
                                   (__bridge CFURLRef)[NSURL fileURLWithPath:path], &dataSize_, &dataFormat, &sampleRate);
    
        // データをバッファに設定する
        alBufferData(buffers_, dataFormat, audioData, dataSize_, sampleRate);
        free(audioData);

        // バッファをソースに設定する
        alSourcei(sources_, AL_BUFFER, buffers_);

        // バッファとソースをC言語側でも使えるようにグローバル変数に保存する
        SetDataSourceBuf(sources_, buffers_);

        // オーディオを再生する
        alSourcePlay(sources_);
    }
}

@end
