//
//  LrcParser.m
//  8-1-2
//
//  Created by 田子瑶 on 16/6/17.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

#import "LrcParser.h"

@implementation LrcLineObject

@synthesize lrc;
@synthesize startTime;


-(id)init{

    if (self = [super init]) {
        self.lrc = nil;
        self.startTime = 0;
    }
    return self;
}

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

-(NSComparisonResult)timeSort:(LrcLineObject *)lineObject{

    if (self.startTime > lineObject.startTime) {
        return NSOrderedDescending;
    }else if (self.startTime == lineObject.startTime){
        return NSOrderedSame;
    }else{
        return NSOrderedAscending;
    }
}

@end

@implementation LrcParser
@synthesize author;
@synthesize title;
@synthesize album;
@synthesize byWorker;
@synthesize offset;
@synthesize lrcArray;
@synthesize currentLine;
@synthesize totalLine;

-(id)init{

    if (self = [super init]) {
        self.author = nil;
        self.title = nil;
        self.album = nil;
        self.byWorker = nil;
        self.offset = 0;
        self.lrcArray = nil;
        self.currentLine = 0;
        self.totalLine = 0;
    }
    
    return self;
}

//第三步 将歌词按]分割为数组
-(void)parserLrcLine:(NSArray *)lrcLines{

    for (NSString*lrcLine in lrcLines) {
        //componentsSeparatedByString 将字符串按指定字符切割成数组
        //tmpArray = "[00:02.00"," 罗嘉良 准我留下"
        NSArray*tmpArray = [lrcLine componentsSeparatedByString:@"]"];
        
        if ([[tmpArray objectAtIndex:1] length] != 0) {
            long count = [tmpArray count] -1;
            
            for (int i=0; i<count; i++) {
                NSString *timeString = [tmpArray objectAtIndex:i];
                LrcLineObject *lineObject = [[LrcLineObject alloc]init];
                
                //获取歌词
                lineObject.lrc = [tmpArray lastObject];
        
                /*
                 substringWithRange需要传进来NSRange类型，表示从哪里开始截取和长度，返回字符串类型
                 NSMakeRange是一个结构体类型，包含两个参数，位置和长度。表示字符串要传进来从哪里开始的位置和需要的长度。
                 */

                lineObject.startTime = [[timeString substringWithRange:NSMakeRange(1, 2)] intValue];
                lineObject.startTime = lineObject.startTime*60+
                [[timeString substringWithRange:NSMakeRange(4, 2)] intValue];
                lineObject.startTime = lineObject.startTime*1000+
                [[timeString substringWithRange:NSMakeRange(7, 2)] intValue];
                
                if (self.lrcArray == nil) {
                    NSMutableArray *lrcTmpArray = [[NSMutableArray alloc] init];
                    self.lrcArray = lrcTmpArray;
                }
                
//                NSLog(@"no.3 startTime:%ld,lrc:%@",(long)lineObject.startTime,lineObject.lrc);
                [self.lrcArray addObject:lineObject];
            }
        }
    }
    //利用startTime给数组排序
    [self.lrcArray sortUsingSelector:@selector(timeSort:)];
    self.totalLine = [self.lrcArray count];
}


//第二步 去除多余空格 按转行符分割为数组 每个分割后的数组再按:分割  替换:以前的 ]
-(void)parserProperties:(NSString*)propertyString{

    //stringByTrimmingCharactersInSet 用于过滤特殊字符
    propertyString = [propertyString stringByTrimmingCharactersInSet:
                      //去除多余的空格
                      [NSCharacterSet newlineCharacterSet]];
    
    //componentsSeparatedByString字符串转数组 按转行符切割
    NSArray *properties = [propertyString componentsSeparatedByString:@"\n"];
    
    for (NSString *propertyLine in properties) {
        
        if ([propertyLine length] > 0) {
            
            //tmpArray = "[ti","准我留下]"
            NSArray *tmpArray = [propertyLine componentsSeparatedByString:@":"];
            
            //propertyName = [ti
            NSString *propertyName = [tmpArray objectAtIndex:0];
            
            if ([propertyName isEqualToString:@"[ar"]) {
                //stringByReplacingOccurrencesOfString 将]替换成空
                self.author = [[tmpArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"]" withString:@""];
            }else if ([propertyName isEqualToString:@"[ti"]){
                self.title = [[tmpArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"]" withString:@""];
            }else if([propertyName isEqualToString:@"[al"]){
                self.album = [[tmpArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"]" withString:@""];
            }else if([propertyName isEqualToString:@"[by"]){
                self.byWorker = [[tmpArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"]" withString:@""];
            }else if([propertyName isEqualToString:@"[offset"]){
                NSString *offsetStr = [[tmpArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"]" withString:@""];
                self.offset = [offsetStr intValue];
            }
        }
    }
//    NSLog(@"no.2 %@->parser",properties);
}

//第一步 解析lrc文件 获取 [00: 前的内容 传入第二步 获取 [00: 后的内容 传入第三步
-(void)parserLrc:(NSString *)lrcPath{
    
    NSError *error = noErr;
    
    //从path获取lrc文件
    NSString *lrcContent = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:&error];
    
    //rangeOfString 获取指定短字符串在长字符串中的开始，结尾索引值
    //从开始位置截取到[00:的位置
    NSString *propertyLines = [lrcContent substringToIndex:[lrcContent rangeOfString:@"[00:"].location];
    
    //截取的字符串传入parserProperties
    [self parserProperties:propertyLines];
    
    lrcContent = [lrcContent substringFromIndex:[lrcContent rangeOfString:@"[00:"].location];
    lrcContent = [lrcContent stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSArray *retArray = [lrcContent componentsSeparatedByString:@"\n"];
    
    [self parserLrcLine:retArray];

}






@end
