//
//  MindWaveAddon.h
//  MindPiano
//
//  Created by Austin Lubetkin on 12/17/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//



#import <Foundation/Foundation.h>

#import "CodeaAddon.h"

@interface MindWaveAddon : CodeaAddon<MWMDelegate>

+ (instancetype) sharedInstance;

@property (nonatomic, assign) BOOL mindwaveEnabled;
@property (nonatomic, assign) BOOL isBlinking;
@property (nonatomic, assign) int attention;

-(void)eegSample:(int) sample;
-(void)eSense:(int)poorSignal Attention:(int)attention Meditation:(int)meditation;
-(void)eegPowerDelta:(int)delta Theta:(int)theta LowAlpha:(int)lowAlpha HighAlpha:(int)highAlpha;
-(void)eegPowerLowBeta:(int)lowBeta HighBeta:(int)highBeta LowGamma:(int)lowGamma
              MidGamma:(int)midGamma;
-(void)didConnect;
-(void)didDisconnect;

-(void)connectDevice:(NSString *)deviceID;
//disconnect
-(void)disconnectDevice;
//Device found
-(void)deviceFound:(NSString *)devName MfgID:(NSString *)mfgID DeviceID:(NSString *)deviceID;

@end

