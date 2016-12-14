/**
 @file TGStream.h
 @discussion TGStream Class in CommunicationSDK
 @author Angelo Wang
 @version 0.7.0  2/27/15 Creation
 @copyright Copyright (c) 2015 com.neurosky. All rights reserved.
 */
#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>

#import "TGStreamDelegate.h"
#import "TGStreamEnum.h"

extern BOOL                     TGSenableLogsFlag;
extern NSString  * const    TGSSDKLogPrefix;
extern NSString  * const    TGSEADSessionDataReceivedNotification;

extern dispatch_queue_t     logQueue;
extern NSString                  *path;

@class TGSEADSession;

@interface TGStream : NSObject <EAAccessoryDelegate,TGStreamDelegate>

@property (nonatomic, weak) id<TGStreamDelegate> delegate;


+ (TGStream *)sharedInstance;

-(NSString *) getVersion;

-(void)initConnectWithFile:(NSString *)path;

-(void)initConnectWithAccessorySession;

-(void)tearDownAccessorySession;

-(void)setParserWith:(ParserType)parserType SampleRate:(int)sampleRate;

-(void)enableLog:(BOOL)enabled;

-(void)setRecordStreamFilePath;

-(void)setRecordStreamFilePath:(NSString *)filePath;

-(void)startRecordRawData;

-(void)stopRecordRawData;


@end
