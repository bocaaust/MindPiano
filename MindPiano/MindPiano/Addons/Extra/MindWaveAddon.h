//
//  MindWaveAddon.h
//  MindPiano
//
//  Created by Austin Lubetkin on 12/17/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//



#import <Foundation/Foundation.h>

#import "CodeaAddon.h"

// The merged MWM instance
//#import "MWMDelegate.h"
//#import "MWMDevice.h"
#if TARGET_IPHONE_SIMULATOR
#else
#import "TGStreamDelegate.h"
#endif
#import <AlgoSdk/NskAlgoSdk.h>

#if TARGET_IPHONE_SIMULATOR
@interface MindWaveAddon : CodeaAddon <NskAlgoSdkDelegate>
#else
@interface MindWaveAddon : CodeaAddon <NskAlgoSdkDelegate, TGStreamDelegate>
#endif

//@interface MindWaveAddon : CodeaAddon<MWMDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    //BOOL mindwaveEnabled;
  // int isBlinking;
    //int attentionValue;
    //MWMDevice *mwDevice;
   // NSArray *devicesArray;
   // NSMutableArray *tempDevicesArray;
    
    //NSMutableArray *candidateIdArray;
   // NSMutableArray *devNameArray;
   // NSMutableArray *mfgIDArray;
    
    //There's two types devices
    //NSMutableArray *deviceTypeArray;
//}

+ (instancetype) sharedInstance;

//@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
//@property (weak, nonatomic) IBOutlet UIPickerView *devicePicker;
//@property (nonatomic, retain) NSArray *devicesArray;

//-(void)eegSample:(int) sample;
//-(void)eSense:(int)poorSignal Attention:(int)attention Meditation:(int)meditation;
//-(void)eegPowerDelta:(int)delta Theta:(int)theta LowAlpha:(int)lowAlpha HighAlpha:(int)highAlpha;
//-(void)eegPowerLowBeta:(int)lowBeta HighBeta:(int)highBeta LowGamma:(int)lowGamma
         //     MidGamma:(int)midGamma;
//-(void)didConnect;
//-(void)didDisconnect;

//-(void)connectDevice:(NSString *)deviceID;
//disconnect
//-(void)disconnectDevice;
//Device found
//-(void)deviceFound:(NSString *)devName MfgID:(NSString *)mfgID DeviceID:(NSString *)deviceID;

@end

