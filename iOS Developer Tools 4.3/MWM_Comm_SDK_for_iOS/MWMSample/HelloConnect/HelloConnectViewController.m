//
//  HelloConnectViewController.m
//  HelloConnect
//
//  Created by neurosky on 1/24/14.
//  Copyright (c) 2014 neurosky. All rights reserved.
//

#import "HelloConnectViewController.h"

@interface HelloConnectViewController ()

@end

@implementation HelloConnectViewController
{
    dispatch_queue_t workBackgroundQueue;
     dispatch_queue_t ecgQueue;
}
@synthesize ekgLineView;

@synthesize toolbar;
@synthesize devicePicker;
@synthesize devicesArray;

#define TEST_SLEEP_DATA_FILE @"SleepRawSample"
#define SLEEP_START_TS 1411077600.00000
#define SLEEP_END_TS 1411102800.00000
#define SLEEP_DOWN_SAMPLE 5

#define FIND_ME_TEST_SYNC_IN_BACKGROUND

#define FIND_ME_DISABLE_ALARM_GOALS
//#define DISABLE_ALARM_GOALS

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    toolbar.hidden = YES;
    devicePicker.hidden = YES;
    
    devicePicker.delegate = self;
    devicePicker.dataSource = self;
    
    tempDevicesArray = [[NSMutableArray alloc] init];
    devicesArray = tempDevicesArray;
    
    deviceTypeArray =[[NSMutableArray alloc] init];
    devNameArray = [[NSMutableArray alloc] init];
    
    mfgIDArray = [[NSMutableArray alloc] init];
    
    //-init sgDevice before nTGBeManager
    
    mwDevice = [MWMDevice sharedInstance];
    [mwDevice setDelegate:self];
    //enable console log here
    [mwDevice enableConsoleLog:YES];
    
    NSDate *epochnow = [NSDate date];
    uint32_t nowEpochSeconds = [epochnow timeIntervalSince1970];
    uint32_t *sleeptime = (uint32_t*)malloc(sizeof(uint32_t)*3);
    sleeptime[0] = nowEpochSeconds;
    sleeptime[1] = nowEpochSeconds++;
    sleeptime[2] = nowEpochSeconds+2;
    
    NSMutableArray *sleepTimeArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    for(int i = 0; i < 3; i++){
        [sleepTimeArray addObject: [NSDate dateWithTimeIntervalSince1970:sleeptime[i]]];
    }
     ecgQueue=dispatch_queue_create("ecg_queue", DISPATCH_QUEUE_SERIAL);
}


-(void)viewWillAppear:(BOOL)animated{
    
    put_alert = put_alertLast = nil;
    labEKGalert = labEKGalertLast = nil;
    labEKGcount = 0;
    labEKGstartTime = nil;
    labEKGsampleRate = 0;
    labEKGrealTime = false;
    labEKGcomment = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
  //  [sgDevice teardownManager];
}

- (void)alertView:(UIAlertView *)bondDialogView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //NSLog(@"Button NO");
        // NO, do something
    }
    else if (buttonIndex == 1) {
        //NSLog(@"Button YES");
      //  [sgDevice takeBond];
        // Yes - take the bond
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    // //NSLog(@"numberOfComponentsInPickerView-------");
    //
    // only 1 scrollable list
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    // //NSLog(@"numberOfRowsInComponent-------");
    int count;
    count = (int) devicesArray.count;
    return count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    // //NSLog(@"titleForRow-------");
    NSString *listItem;
    listItem =  [NSString stringWithFormat:@"%@:%@",[mfgIDArray objectAtIndex:row],[devNameArray objectAtIndex:row]];
    
    return listItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)put_alertWithOK: (NSString*) title message:(NSString*) message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        put_alertLast = put_alert;
        put_alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@" OK ", nil];
        
        if (put_alertLast != nil) {
            [put_alertLast dismissWithClickedButtonIndex:0 animated:NO];
        }
        [put_alert show];
    }); // do all alerts on the main thread
}

- (IBAction)onDisconnectClicked:(id)sender{
    [mwDevice disconnectDevice];
}

- (IBAction)onSCandidateClicked:(id)sender
{
    [mwDevice scanDevice];
    
    toolbar.hidden = NO;
    devicePicker.hidden = NO;
}

- (IBAction)onFinishedButtonClicked:(id)sender {
    toolbar.hidden = YES;
    devicePicker.hidden = YES;
   // [nTGBleManager candidateStopScan];
    
    if (devicesArray.count < 1) {
        return;
    }
    
    int row_number = (int) [devicePicker selectedRowInComponent:0];
    if (row_number < 0) {
        //NSLog(@"%s STRANGE devicesArray row number: %d", __func__, row_number);
    }
    
    if (row_number >= 0)
    {
        NSString *deviceID = [devicesArray objectAtIndex:row_number];
        [mwDevice connectDevice:deviceID];
        
        // now release the lists so that they are empty and prepared for the next time.
        tempDevicesArray = [[NSMutableArray alloc] init];
        devicesArray = tempDevicesArray;
        
        deviceTypeArray =[[NSMutableArray alloc] init];
        devNameArray = [[NSMutableArray alloc] init];
        mfgIDArray = [[NSMutableArray alloc] init];

        // put picker into a good state
        devicePicker.userInteractionEnabled = NO;
        [devicePicker reloadAllComponents];
    }
}

-(NSString *)formatToken:(id)tokenObj
{

    NSString *hexStr = @"";
    if ([tokenObj isKindOfClass:[NSData class]])
    {
        Byte *bytes = (Byte*)[tokenObj bytes];
        for(int i=0;i< 20;i++)
        {
            NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];
            if([newHexStr length]==1)
                hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
            else
                hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
            
            NSLog(@"bytes 的16进制数为:%@",hexStr);
        }
    }else if ([tokenObj isKindOfClass:[NSString class]])
    {
        hexStr = (NSString *)tokenObj;
         NSLog(@"String format");
    }else
    {
        NSLog(@"%@", tokenObj);
    }
    return hexStr;
}

static int i = 0;
- (IBAction)configMWM:(id)sender
{
    [mwDevice readConfig];
    NSLog(@"--> mwm cmd: %d",i);
//    [sgDevice ConfigureMWMWithCMD:(i ++)%2];
//    usleep(1000 * 1000);
//    
}


//MWM Device delegate-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->
-(void)deviceFound:(NSString *)devName MfgID:(NSString *)mfgID DeviceID:(NSString *)deviceID
{
    //mfgID is null or @"", NULL
    if ([mfgID isEqualToString:@""] || nil == mfgID || NULL == mfgID) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{  // do all alerts on the main thread
        
        if (![devicesArray containsObject:deviceID])
        {
            [tempDevicesArray addObject:deviceID];
            devicesArray = tempDevicesArray;
            [devNameArray addObject:devName];
            [mfgIDArray addObject:mfgID];
            //store
            [deviceTypeArray addObject:@0];
            [devicePicker reloadAllComponents];
        }
        
        if (devicesArray.count > 0) {
            devicePicker.userInteractionEnabled = YES;
        }
        else{
            devicePicker.userInteractionEnabled = NO;
        }
    });
}

-(void)didConnect
{
    NSLog(@"%s", __func__);
    [[MWMDevice sharedInstance] enableLoggingWithOptions:LoggingOptions_Processed | LoggingOptions_Raw];
}

-(void)didDisconnect
{
    NSLog(@"%s", __func__);
}

-(void)eegSample:(int)sample
{
    [ekgLineView addValue:sample];
};

-(void)eegPowerLowBeta:(int)lowBeta HighBeta:(int)highBeta LowGamma:(int)lowGamma MidGamma:(int)midGamma
{
    NSLog(@"%s >>>>>>>-----eegPower: lowBeta:%d highBeta:%d lowGamma:%d midGamma:%d", __func__,  lowBeta, highBeta, lowGamma, midGamma);
}

-(void)eegPowerDelta:(int)delta Theta:(int)theta LowAlpha:(int)lowAplpha HighAlpha:(int)highAlpha
{
    NSLog(@"%s >>>>>>>-----eegPower: delta:%d theta:%d lowAplpha:%d hightAlpha:%d", __func__,  delta, theta, lowAplpha, highAlpha);
}

-(void)eSense:(int)poorSignal Attention:(int)attention Meditation:(int)meditation
{
    NSLog(@"%s >>>>>>>-----eSense:%d Attention:%d Meditation:%d", __func__,  poorSignal, attention, meditation);
}

-(void)eegBlink:(int)blinkValue
{
    NSLog(@"%s >>>>>>>-----eegBlink: blinkValue:%d ", __func__,  blinkValue);
}

-(void)mwmBaudRate:(int)baudRate NotchFilter:(int)notchFilter
{
    NSLog(@"%s >>>>>>>-----mwmBaudRate:%d NotchFilter:%d ", __func__,  baudRate, notchFilter);
}

//<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--

@end
