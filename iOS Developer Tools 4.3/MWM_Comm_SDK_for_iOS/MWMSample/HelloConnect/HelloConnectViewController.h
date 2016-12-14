//
//  HelloConnectViewController.h
//  HelloConnect
//
//  Created by neurosky on 1/24/14.
//  Copyright (c) 2014 neurosky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LineGraphView.h"

// The merged MWM instance
#import "MWMDelegate.h"
#import "MWMDevice.h"

@interface HelloConnectViewController : UIViewController<MWMDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    BOOL logging;

    NSArray *rawArray;
    int rawIndex;
    NSTimer* sendDataTimer;
    
    int  cardioZoneHeartRate;
    NSDate * cardioZoneHeartRate_TS;
    
    int  cardioZoneHRV;
    NSDate * cardioZoneHRV_TS;
    
    int  rrInt;
    NSDate * rrInt_TS;
    
    int  cardioZoneBreathingIndex;
    NSDate * cardioZoneBreathingIndex_TS;
    
    NSArray* cardioZone3D;
    NSDate * cardioZone3D_TS;
    
    int  heartAge;
    NSDate * heartAge_TS;
    
    int  heartFitnessLevel;
    NSDate * heartFitnessLevel_TS;
    
    int  heartLevel;
    NSDate * heartLevel_TS;
   
    int  relaxation;
    NSDate * relaxation_TS;
    
    int  mood;
    NSDate * mood_TS;
    
    int trainingZone;
    NSDate * trainingZone_TS;
    
    int  stress;
    NSDate * stress_TS;
    
    int smoothedWave;
    
    NSArray *devicesArray;
    NSMutableArray *tempDevicesArray;
    
    NSMutableArray *candidateIdArray;
    NSMutableArray *devNameArray;
    NSMutableArray *mfgIDArray;
    
    //There's two types devices
    NSMutableArray *deviceTypeArray;
    
    UIAlertView *put_alert;
    UIAlertView *put_alertLast;

    UIAlertView *labEKGalert;
    UIAlertView *labEKGalertLast;
    int labEKGcount;
    NSDate *labEKGstartTime;
    int labEKGsampleRate;
    bool labEKGrealTime;
    NSString *labEKGcomment;
    
    // mwm device info
    MWMDevice *mwDevice;
}

@property (weak, nonatomic) IBOutlet LineGraphView *ekgLineView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIPickerView *devicePicker;
@property (nonatomic, retain) NSArray *devicesArray;


- (IBAction)onDisconnectClicked:(id)sender;
- (IBAction)onSCandidateClicked:(id)sender;
- (IBAction)onFinishedButtonClicked:(id)sender;
- (IBAction)configMWM:(id)sender;

@end






















