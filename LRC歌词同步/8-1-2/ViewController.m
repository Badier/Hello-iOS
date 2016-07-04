//
//  ViewController.m
//  8-1-2
//
//  Created by 田子瑶 on 16/6/17.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

#import "ViewController.h"
#import "LrcParser.h"

#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioPlayerDelegate>{
    
    LrcParser* lrcParser;
    AVAudioPlayer *player;
    NSURL *musicUrl;
    NSTimer *timer;
    
}

- (IBAction)playBtnClicked:(UIButton *)sender;

- (IBAction)stopBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *chineseTextView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    player = nil;
    timer = nil;
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"准我留下" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:filepath];
    musicUrl = url;
    
    LrcParser *tmpParser = [[LrcParser alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LRC" ofType:@"txt"];
    [tmpParser parserLrc:path];
    lrcParser = tmpParser;
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:nil];
    player.delegate = self;
    
    [player prepareToPlay];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
}



- (IBAction)playBtnClicked:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqual:@"Play"]) {
                
        [player play];
        [self startTimer];
        [sender setTitle:@"Pause" forState:UIControlStateNormal];
        
    }else{
    
        [player pause];
        [self stopTimer];
    
        [sender setTitle:@"Play" forState:UIControlStateNormal];
    }
}

- (IBAction)stopBtnClicked:(id)sender {
    
    [player stop];
    player.currentTime = 0;
    
    [self stopTimer];
    
    lrcParser.currentLine = 0;
    _chineseTextView.text = @"...";
    
    [_playBtn setTitle:@"Play" forState:UIControlStateNormal];
    
}



- (void)updateStatus:(NSTimer*)tm{
    
    float progress = [self getCurrentTime];
    
    if (lrcParser.currentLine < lrcParser.totalLine) {
        LrcLineObject *lineObject = [lrcParser.lrcArray objectAtIndex:lrcParser.currentLine];
        if (progress > lineObject.startTime*1.0/1000) {
            _chineseTextView.text = lineObject.lrc;
            lrcParser.currentLine++;
            //            NSLog(@"time:%ld lrc:%@",(long)lineObject.startTime,lineObject.lrc);
        }
    }
}

- (void)startTimer{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(updateStatus:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)stopTimer{
    
    if (timer != nil) {
        [timer invalidate];
    }
    timer = nil;
}

- (float)getCurrentTime{
    
    return  player.currentTime;
    
}


@end
