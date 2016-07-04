//
//  LrcParser.h
//  8-1-2
//
//  Created by 田子瑶 on 16/6/17.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrcLineObject : NSObject{

    NSString *lrc;
    NSInteger startTime;
}

@property(nonatomic,retain)NSString *lrc;  //接收歌词
@property(nonatomic,assign)NSInteger startTime; //接收对应时间

/*
 它的返回值NSComparisonResult是一个enum类型
 
 typedef NS_ENUM(NSInteger, NSComparisonResult) {
 NSOrderedAscending = -1L, 
 NSOrderedSame, 
 NSOrderedDescending
 };
 
 NSOrderedAscending表示左侧数值小于右侧；
 NSOrderedDescending表示右侧数值小于左侧；
 NSOrderedSame 则相等；
 */

-(NSComparisonResult)timeSort:(LrcLineObject*)lineObject;

@end

@interface LrcParser : NSObject{

    NSString *author;
    NSString *title;
    NSString *album;
    NSString *byWorker;
    NSInteger offset;
    
    NSMutableArray *lrcArray;
    NSInteger currentLine;
    NSInteger totalLine;
}

@property(nonatomic,retain)NSString *author;  //作者
@property(nonatomic,retain)NSString *title;  //歌曲名
@property(nonatomic,retain)NSString *album;  //唱片
@property(nonatomic,retain)NSString *byWorker; //制作人
@property(nonatomic,assign)NSInteger offset; //补偿
@property(nonatomic,retain)NSMutableArray *lrcArray;
@property(nonatomic,assign)NSInteger currentLine;
@property(nonatomic,assign)NSInteger totalLine;

-(void)parserLrc:(NSString*)lrcPath;

@end
