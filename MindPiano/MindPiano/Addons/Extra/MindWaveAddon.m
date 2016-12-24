//
//  MindWaveAddon.m
//  MindPiano
//
//  Created by Austin Lubetkin on 12/17/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWMDevice.h"

#import "MindWaveAddon.h"

#import "StandaloneCodeaViewController.h"

#define MINDWAVE_LIB_NAME "mindwave"


#import "lua.h"
#import "lauxlib.h"

#pragma mark - Lua Functions

//static int mindwave_enabled(struct lua_State* L);

static int mindwave_attention(struct lua_State* L);

//static int mindwave_isBlink(struct lua_State* L);

#pragma mark - Lua Function Mappings

static const luaL_Reg mindwaveLibs[] =
{
   // {"enabled", mindwave_enabled},
    {"getAttention", mindwave_attention},
   // {"isBlink", mindwave_isBlink},
    {NULL, NULL}
};

static int luaopen_mindwave(lua_State *L)
{
    //Register Mindwave functions with Lua
    lua_newtable(L);
    luaL_setfuncs(L, mindwaveLibs, 0);
    
    return 1;
}

//#pragma mark - Mindwave Addon

@implementation MindWaveAddon


#pragma mark - Singleton

+ (instancetype) sharedInstance
{
    static id _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

#pragma mark - Initialisation

- (id)init
{
    self = [super init];
    if (self)
    {
        
        _toolbar.hidden = YES;
        _devicePicker.hidden = YES;
        
        _devicePicker.delegate = self;
        _devicePicker.dataSource = self;
        
        tempDevicesArray = [[NSMutableArray alloc] init];
        _devicesArray = tempDevicesArray;
        
        deviceTypeArray =[[NSMutableArray alloc] init];
        devNameArray = [[NSMutableArray alloc] init];
        
        mfgIDArray = [[NSMutableArray alloc] init];

        
        // Initialise our Instance Variables
        //mindwaveEnabled = NO;
       // isBlinking = 0;
        attentionValue = 0;
        
        // Initialize Device
        
        mwDevice = [MWMDevice sharedInstance];
        [mwDevice setDelegate:self];
        
        
        
    }
    return self;
}


#pragma mark - Mind Wave Helper Methods



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
            [_devicePicker reloadAllComponents];
        }
        
        if (devicesArray.count > 0) {
            _devicePicker.userInteractionEnabled = YES;
        }
        else{
            _devicePicker.userInteractionEnabled = NO;
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
    attentionValue = attention;
}

-(void)eegBlink:(int)blinkValue
{
    NSLog(@"%s >>>>>>>-----eegBlink: blinkValue:%d ", __func__,  blinkValue);
}

-(void)mwmBaudRate:(int)baudRate NotchFilter:(int)notchFilter
{
    NSLog(@"%s >>>>>>>-----mwmBaudRate:%d NotchFilter:%d ", __func__,  baudRate, notchFilter);
}


#pragma mark - Codea Addon Protocol Implementation

- (void) codea:(StandaloneCodeaViewController*)codeaController didCreateLuaState:(struct lua_State*)L
{
    
    
    
    CODEA_ADDON_REGISTER(MINDWAVE_LIB_NAME, luaopen_mindwave);
}

static int mindwave_attention(struct lua_State* L)
{
    lua_pushinteger(L, [MindWaveAddon sharedInstance]->attentionValue);
    
    return 1;
}



@end

