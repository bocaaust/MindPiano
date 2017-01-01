//
//  MindWaveAddon.m
//  MindPiano
//
//  Created by Austin Lubetkin on 12/17/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MWMDevice.h"

#import "MindWaveAddon.h"

#import "StandaloneCodeaViewController.h"

#import "TGStream.h"
#import <AlgoSdk/NskAlgoSdk.h>

#define MINDWAVE_LIB_NAME "mindwave"


#import "lua.h"
#import "lauxlib.h"

typedef NS_ENUM(NSInteger, SegmentIndexType) {
    SegmentAppreciation = 0,
    SegmentMentalEffort,
    SegmentMentalEffort2,
    SegmentFamiliarity,
    SegmentFamiliarity2,
    SegmentCreativity,
    SegmentAlertness,
    SegmentCognitivePreparedness,
    SegmentEEGBandpower,
    SegmentMax
};

#pragma mark - Lua Functions

//static int mindwave_enabled(struct lua_State* L);

static int mindwave_attention(struct lua_State* L);

static int mindwave_isBlink(struct lua_State* L);

static int mindwave_status(struct lua_State* L);

#pragma mark - Lua Function Mappings

static const luaL_Reg mindwaveLibs[] =
{
   // {"enabled", mindwave_enabled},
    {"getAttention", mindwave_attention},
    {"isBlink", mindwave_isBlink},
    {"status",mindwave_status},
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
@interface MindWaveAddon () {
@private
    BOOL bRunning;
    BOOL bPaused;
    
  //  CPTXYGraph *graph;
    
    NskAlgoEegType algoTypes;
    
    NSTimer *graphTimer;
    
   // AlgoContext *algoList[SegmentMax];
}
@end

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

/*- (id)init
{
    self = [super init];
    if (self)
    {
        
        //_toolbar.hidden = YES;
        //_devicePicker.hidden = YES;
        
       // _devicePicker.delegate = self;
       // _devicePicker.dataSource = self;
        
       // tempDevicesArray = [[NSMutableArray alloc] init];
       // _devicesArray = tempDevicesArray;
        
       // deviceTypeArray =[[NSMutableArray alloc] init];
       // devNameArray = [[NSMutableArray alloc] init];
        
        //mfgIDArray = [[NSMutableArray alloc] init];

        
        // Initialise our Instance Variables
        //mindwaveEnabled = NO;
       // isBlinking = 0;
       // attentionValue = 0;
        
        // Initialize Device
        
        mwDevice = [MWMDevice sharedInstance];
        [mwDevice setDelegate:self];
        
        
        
    }
    return self;
}*/


#pragma mark - Mind Wave Helper Methods

NSMutableString *stateStr;
NSMutableString *signalStr;

long long tStart, tEnd;
/*
const ALGO_SETTING defaultAlgoSetting[SegmentMax] = {*/
    /*   xRange          plotMinY    plotMaxY   interval    minInterval maxInterval */
   /* {X_RANGE,        0.0f,       5.0f,      1,          1,          5},
    {X_RANGE,        -110,       200,       1,          1,          5},
    {X_RANGE,        0,          0,         30,         30,         300},
    {X_RANGE,        -110,       200,       1,          1,          5},
    {X_RANGE,        0,          0,         30,         30,         300},
    {X_RANGE,        -1,         2,         1,          1,          5},
    {X_RANGE,        -1,         2,         1,          1,          5},
    {X_RANGE,        -1,         2,         1,          1,          5},
    {X_RANGE,        -20,        40,        1,          1,          1}
};
*/
typedef struct _PLOT_PARAM {
    BOOL plotAvailable;
    char *graphTitle;
    
    char *plotName[5];
} PLOT_PARAM;

PLOT_PARAM defaultPlotParam[SegmentMax] = {
    /*    plotAvaliable graphTitle                  plotName */
    { YES,          "Appreciation",             {"AP Index",     nil} },
    { YES,          "Mental Effort",            {"Abs ME",       "Diff ME"} },
    { NO,           nil,                        {nil,            nil} },
    { YES,          "Familiarity",              {"Abs F",        "Diff F"} },
    { NO,           nil,                        {nil,            nil} },
    { YES,          "Creativity",               {"CR Value",     nil} },
    { YES,          "Alertness",                {"AL Value",     nil} },
    { YES,          "Cognitive Preparedness",   {"CP Value",     nil} },
    { YES,          "Bandpower",                {"Delta", "Theta", "Alpha", "Beta", "Gamma"} }
};
/*
- (void) removeAlgoPlot {
    for (int i=0;i<SegmentMax;i++) {
        if (algoList[i].plotAvailable) {
            for (int j=0;j<[algoList[i] getPlotCount];j++) {
                if ([algoList[i] getPlot:j] != nil) {
                    [graph removePlot:[algoList[i] getPlot:j]];
                    [algoList[i] setPlot:nil idx:j];
                }
            }
        }
    }
}

- (void) resetAlgoPlotData {
    for (int i=0;i<SegmentMax;i++) {
        for (int j=0;j<[algoList[i] getPlotCount];j++) {
            if ([algoList[i] getIndex:j] != nil) {
                [[algoList[i] getIndex:j] removeAllObjects];
            }
        }
    }
}

- (void) resetAlgoSettings {
    [self resetAlgoPlotData];
    
    for (int i=0;i<SegmentMax;i++) {
        algoList[i].setting = defaultAlgoSetting[i];
    }
}

*/
- (IBAction)setAlgos:(id)sender {
    algoTypes = 0;
    
   /* [self removeAlgoPlot];
    [self resetAlgoPlotData];
    [self resetAlgoSettings];
   
    
    for (int i=0;i<SegmentMax;i++) {
        [_segment setEnabled:NO forSegmentAtIndex:i];
    }
    [_segment setSelected:NO];
    
    //    [_bcqThresholdTitle setHidden:YES];
    //    [_bcqThreshold setHidden:YES];
    //    [_bcqWindowTitle setHidden:YES];
    //    [_bcqWindow setHidden:YES];
    //    [_bcqWindowStepper setHidden:YES];
    
    self.myGraph.hostedGraph = nil;
    [graph setHidden:YES];
    [self.textView setText:@""];
    [self.textView setHidden:YES];
    
    [stateStr setString:@""];
    [signalStr setString:@""];
    
    [self.stopButton setEnabled:NO];
    
    [self.attLabel setEnabled:NO];
    [self.attValue setEnabled:NO];
    [self.attLevelIndicator setProgress:0];
    [self.medLabel setEnabled:NO];
    [self.medValue setEnabled:NO];
    [self.medLevelIndicator setProgress:0];
   
    //    [self.intervalSlider setEnabled:NO];
    //    [self.configButton setEnabled:NO];
    //    [self.intervalSlider setValue:1];
    //    [self.intervalValue setText:@"1"];
    
    if ([_attCheckbox isOn]) {
        algoTypes |= NskAlgoEegTypeAtt;
        [self.attLabel setEnabled:YES];
        [self.attValue setEnabled:YES];
    }
    if ([_medCheckbox isOn]) {
        algoTypes |= NskAlgoEegTypeMed;
        [self.medLabel setEnabled:YES];
        [self.medValue setEnabled:YES];
    }
    if ([_blinkCheckbox isOn]) {
        algoTypes |= NskAlgoEegTypeBlink;
    }
    if ([_bpCheckbox isOn]) {
        algoTypes |= NskAlgoEegTypeBP;
        [_segment setEnabled:YES forSegmentAtIndex:SegmentEEGBandpower];
    }
      */
    if (algoTypes == 0) {
       /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please select at least ONE algorithm"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];*/
    } else {
        int ret;
        NskAlgoSdk *handle = [NskAlgoSdk sharedInstance];
        handle.delegate = self;
        
        if ((ret = [[NskAlgoSdk sharedInstance] setAlgorithmTypes:algoTypes]) != 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"Fail to init EEG SDK [%d]", ret]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        NSMutableString *version = [NSMutableString stringWithFormat:@"SDK Ver.: %@", [[NskAlgoSdk sharedInstance] getSdkVersion]];
        if (algoTypes & NskAlgoEegTypeAtt) {
            [version appendFormat:@"\nAttention Ver.: %@", [[NskAlgoSdk sharedInstance] getAlgoVersion:NskAlgoEegTypeAtt]];
        }
        if (algoTypes & NskAlgoEegTypeMed) {
            [version appendFormat:@"\nMeditation Ver.: %@", [[NskAlgoSdk sharedInstance] getAlgoVersion:NskAlgoEegTypeMed]];
        }
        if (algoTypes & NskAlgoEegTypeBP) {
            [version appendFormat:@"\nEEG Bandpower Ver.: %@", [[NskAlgoSdk sharedInstance] getAlgoVersion:NskAlgoEegTypeBP]];
        }
        if (algoTypes & NskAlgoEegTypeBlink) {
            [version appendFormat:@"\nBlink Detection Ver.: %@", [[NskAlgoSdk sharedInstance] getAlgoVersion:NskAlgoEegTypeBlink]];
        }        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                 message:version
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
        [alert show];
    }
    /*if (graphTimer == nil) {
        graphTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(reloadGraph) userInfo:nil repeats:YES];
    }*/
}
/*
- (void)reloadGraph {
    @synchronized(graph) {
        if (graph) {
            [graph reloadData];
        }
    }
}
*/

- (IBAction)startPausePress:(id)sender {
   // bPaused = YES;
    if (bPaused) {
        [[NskAlgoSdk sharedInstance] startProcess];
    } else {
        [[NskAlgoSdk sharedInstance] pauseProcess];
    }
}

- (IBAction)stopPress:(id)sender {
    [[NskAlgoSdk sharedInstance] stopProcess];
}

#ifdef IOS_DEVICE
#else
/*- (IBAction)dataPress:(id)sender {
    [self sendBulkData];
}*/

/*- (void) sendBulkData {
    if ([[NskAlgoSdk sharedInstance] dataStream:NskAlgoDataTypeBulkEEG data:raw_data_em_me length:(int32_t)(113*512)] == TRUE) {
        [self.dataButton setEnabled:NO];
    }
}*/
#endif

- (IBAction)configPress:(id)sender {
}

- (IBAction)sliderValueChanged:(id)sender {
}

/*- (IBAction)segmentChanged:(id)sender {
    UISegmentedControl *control = (UISegmentedControl*)self.segment;
    [self removeAlgoPlot];
    [graph setHidden:YES];
    
    [_configButton setEnabled:YES];
    
    // always hidden BCQ related UI components
    //    [_bcqThresholdTitle setHidden:YES];
    //    [_bcqThreshold setHidden:YES];
    //    [_bcqWindowTitle setHidden:YES];
    //    [_bcqWindowStepper setHidden:YES];
    //    [_bcqWindow setHidden:YES];
    
    if (algoList[control.selectedSegmentIndex].plotAvailable) {
        [self.myGraph setHidden:NO];
        [self.textView setHidden:YES];
        graph = [self setupGraph:self.myGraph yMin:algoList[control.selectedSegmentIndex].plotMinY length:algoList[control.selectedSegmentIndex].plotMaxY graphTitle:algoList[control.selectedSegmentIndex].graphTitle];
        
        for (int j=0;j<[algoList[control.selectedSegmentIndex] getPlotCount];j++) {
            if (defaultPlotParam[control.selectedSegmentIndex].plotName[j] != nil) {
                NSString *plotName = [NSString stringWithFormat:@"%s", defaultPlotParam[control.selectedSegmentIndex].plotName[j]];
                CPTPlot *plot = [self addPlotToGraph:graph color:[algoList[control.selectedSegmentIndex] getPlotColor:j] plotTitle:plotName];
                [algoList[control.selectedSegmentIndex] setPlot:plot idx:j];
            }
        }
        
        //        [self.configButton setEnabled:YES];
        //        [self.intervalSlider setEnabled:YES];
        //        [self.intervalSlider setMinimumValue:algoList[control.selectedSegmentIndex].minInterval];
        //        [self.intervalSlider setMaximumValue:algoList[control.selectedSegmentIndex].maxInterval];
        //        [self.intervalSlider setValue:algoList[control.selectedSegmentIndex].interval];
        //        self.intervalValue.text = [NSString stringWithFormat:@"%d", (int)algoList[control.selectedSegmentIndex].interval];
    } else {
        [self.myGraph setHidden:YES];
        [self.textView setHidden:NO];
        
        //        [self.configButton setEnabled:YES];
        //        [self.intervalSlider setEnabled:YES];
        //        [self.intervalSlider setMinimumValue:algoList[control.selectedSegmentIndex].minInterval];
        //        [self.intervalSlider setMaximumValue:algoList[control.selectedSegmentIndex].maxInterval];
        //        [self.intervalSlider setValue:algoList[control.selectedSegmentIndex].interval];
        //        self.intervalValue.text = [NSString stringWithFormat:@"%d", (int)algoList[control.selectedSegmentIndex].interval];
    }
}

*/

+ (long long) current_timestamp {
    NSDate *date = [NSDate date];
    return [@(floor([date timeIntervalSince1970] * 1000)) longLongValue];
}

- (void)viewDidLoad {
  //  [super viewDidLoad];
#ifdef IOS_DEVICE
    // we use real mindwave headset on iOS device
    [[TGStream sharedInstance] setDelegate:self];
    [[TGStream sharedInstance] initConnectWithAccessorySession];
#else
    // we use canned data for simulator
    //[self.dataButton setHidden:NO];
#endif
    
   /* for (int i=0;i<SegmentMax;i++) {
        algoList[i] = [[AlgoContext alloc] init];
        algoList[i].plotAvailable = defaultPlotParam[i].plotAvailable;
        [algoList[i] setSetting:defaultAlgoSetting[i]];
        
        if (defaultPlotParam[i].plotAvailable) {
            if (defaultPlotParam[i].graphTitle != nil) {
                algoList[i].graphTitle = [NSString stringWithUTF8String:defaultPlotParam[i].graphTitle];
            }
            for (int j=0;j<[algoList[i] getPlotCount];j++) {
                if (defaultPlotParam[i].plotName[j] != nil) {
                    [algoList[i] setIndex:j];
                    [algoList[i] setPlotName:[NSString stringWithUTF8String:defaultPlotParam[i].plotName[j]] idx:j];
                }
            }
        }
    }*/
    bRunning = FALSE;
}
/*
- (CPTXYGraph*)setupGraph: (CPTGraphHostingView*)hostView yMin:(float)yMin length:(float)length graphTitle:(NSString*)graphTitle {
    
    // Create graph from theme
    CPTXYGraph *newGraph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme      = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [newGraph applyTheme:theme];
    
    hostView.hostedGraph = newGraph;
    
    // Setup scatter plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)newGraph.defaultPlotSpace;
    NSTimeInterval xLow       = 0.0;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(xLow) length:CPTDecimalFromDouble(X_RANGE+2)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(yMin) length:CPTDecimalFromDouble(length)];
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)newGraph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.majorIntervalLength         = CPTDecimalFromDouble(0);
    x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0);
    x.minorTicksPerInterval       = 0;
    
    CPTXYAxis *y = axisSet.yAxis;
    if (length < 10) {
        y.majorIntervalLength         = CPTDecimalFromDouble(1);
        y.minorTicksPerInterval       = 5;
    } else if (length > 500) {
        y.majorIntervalLength         = CPTDecimalFromDouble(200);
        y.minorTicksPerInterval       = 200;
        y.orthogonalCoordinateDecimal = CPTDecimalFromDouble(X_RANGE/3);
    } else {
        y.majorIntervalLength         = CPTDecimalFromDouble(20);
        y.minorTicksPerInterval       = 2;
    }
    y.orthogonalCoordinateDecimal = CPTDecimalFromDouble(X_RANGE/3);
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    y.majorGridLineStyle = gridLineStyle;
    
    newGraph.title = graphTitle;
    
    return newGraph;
}

- (CPTPlot*) addPlotToGraph: (CPTXYGraph*)gp color:(CPTColor*)color plotTitle:(NSString*)plotTitle {
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 1.5;
    lineStyle.lineColor              = color;
    dataSourceLinePlot.dataLineStyle = lineStyle;
    dataSourceLinePlot.interpolation = CPTScatterPlotInterpolationLinear;
    
    dataSourceLinePlot.dataSource = self;
    
    dataSourceLinePlot.showLabels = YES;
    
    dataSourceLinePlot.title = plotTitle;
    
    [gp addPlot:dataSourceLinePlot];
    
    // Add legend
    gp.legend                 = [CPTLegend legendWithGraph:gp];
    gp.legend.fill            = [CPTFill fillWithColor:[CPTColor greenColor]];
    gp.legend.borderLineStyle = ((CPTXYAxisSet *)gp.axisSet).xAxis.axisLineStyle;
    gp.legend.cornerRadius    = 2.0;
    gp.legend.numberOfRows    = 1;
    gp.legend.numberOfColumns = 5;
    gp.legend.delegate        = self;
    gp.legendAnchor           = CPTRectAnchorBottom;
    gp.legendDisplacement     = CGPointMake( 0.0, 5.0f * CPTFloat(1.25) );
    
    dataSourceLinePlot.delegate = self;
    dataSourceLinePlot.plotSpace.delegate = self;
    
    return dataSourceLinePlot;
}
*/
/*- (NSString*)GetCurrentTimeStamp
{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss:SSS";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    return [dateFormatter stringFromDate:now];
}

- (NSString *) timeInMiliSeconds
{
    NSDate *date = [NSDate date];
    NSString * timeInMS = [NSString stringWithFormat:@"%lld", [@(floor([date timeIntervalSince1970] * 1000)) longLongValue]];
    return timeInMS;
}*/

/*- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}*/

- (NSString *)labelForDateAtIndex:(NSInteger)index {
    return @"";
}

-(NSString *) NowString{
    
    NSDate *date=[NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:date];
}

#ifdef IOS_DEVICE

static long long current_timestamp() {
    struct timeval te;
    gettimeofday(&te, NULL);
    long long milliseconds = te.tv_sec*1000LL + te.tv_usec/1000; // caculate milliseconds
    return milliseconds;
}

int rawCount = 0;
//int attentionValue;
#pragma mark
#pragma COMM SDK Delegate
-(void)onDataReceived:(NSInteger)datatype data:(int)data obj:(NSObject *)obj deviceType:(DEVICE_TYPE)deviceType {
    if (deviceType != DEVICE_TYPE_MindWaveMobile) {
        return;
    }
   // datatype = MindDataType_CODE_ATTENTION
    switch (datatype) {
            
        case MindDataType_CODE_POOR_SIGNAL:
            //NSLog(@"%@ POOR_SIGNAL %d\n",[self NowString], data);
        {
            long long timestamp = current_timestamp();
            static long long ltimestamp = 0;
            printf("PQ,%lld,%lld,%d\n", timestamp%100000, timestamp - ltimestamp, rawCount);
            ltimestamp = timestamp;
            rawCount = 0;
        }
        {
            int16_t poor_signal[1];
            poor_signal[0] = (int16_t)data;
            [[NskAlgoSdk sharedInstance] dataStream:NskAlgoDataTypePQ data:poor_signal length:1];
        }
            break;
            
        case MindDataType_CODE_RAW:
            rawCount++;
            //[self addValue:@(data) array:self->eegIndex];
            if (bRunning == FALSE) {
                return;
            }
        {
            int16_t eeg_data[1];
            eeg_data[0] = (int16_t)data;
            [[NskAlgoSdk sharedInstance] dataStream:NskAlgoDataTypeEEG data:eeg_data length:1];
            
        }
            //NSLog(@"%@\n CODE_RAW %d\n",[self NowString],data);
            break;
            
        case MindDataType_CODE_ATTENTION:
        {
            int16_t attention[1];
            attention[0] = (int16_t)data;
            [[NskAlgoSdk sharedInstance] dataStream:NskAlgoDataTypeAtt data:attention length:1];
        }
            NSLog(@"%@\n CODE_ATTENTION %d\n",[self NowString],data);
            break;
            
        case MindDataType_CODE_MEDITATION:
        {
            int16_t meditation[1];
            meditation[0] = (int16_t)data;
            [[NskAlgoSdk sharedInstance] dataStream:NskAlgoDataTypeMed data:meditation length:1];
        }
            //NSLog(@"%@\n CODE_MEDITATION %d\n",[self NowString],data);
            break;
            
        case MindDataType_CODE_EEGPOWER:
            //NSLog(@"%@\n CODE_EEGPOWER %d\n",[self NowString],data);
            break;
            
        case BodyDataType_CODE_HEARTRATE:
            //NSLog(@"%@\n CODE_CONFIGURATION %d\n",[self NowString],data);
            break;
            
        default:
            //NSLog(@"%@\n NO defined data type %ld %d\n",[self NowString],(long)datatype,data);
            break;
    }
}

static NSUInteger checkSum=0;
bool bTGStreamInited = false;

-(void) onChecksumFail:(Byte *)payload length:(NSUInteger)length checksum:(NSInteger)checksum{
    checkSum++;
    NSLog(@"%@\n Check sum Fail:%lu\n",[self NowString],(unsigned long)checkSum);
    NSLog(@"CheckSum lentgh:%lu  CheckSum:%lu",(unsigned long)length,(unsigned long)checksum);
}

static ConnectionStates lastConnectionState = -1;
-(void)onStatesChanged:(ConnectionStates)connectionState{
    //NSLog(@"%@\n Connection States:%lu\n",[self NowString],(unsigned long)connectionState);
    if (lastConnectionState == connectionState) {
        return;
    }
    lastConnectionState = connectionState;
    switch (connectionState) {
        case STATE_COMPLETE:
            NSLog(@"TGStream: complete");
            break;
        case STATE_CONNECTED:
            NSLog(@"TGStream: connected");
            if (bTGStreamInited == false) {
                [[TGStream sharedInstance] initConnectWithAccessorySession];
                bTGStreamInited = true;
            }
            break;
        case STATE_CONNECTING:
            NSLog(@"TGStream: connecting");
            break;
        case STATE_DISCONNECTED:
            NSLog(@"TGStream: disconnected");
            if (bTGStreamInited == true) {
                [[TGStream sharedInstance] tearDownAccessorySession];
                bTGStreamInited= false;
            }
            break;
        case STATE_ERROR:
            NSLog(@"TGStream: error");
            break;
        case STATE_FAILED:
            NSLog(@"TGStream: failed");
            break;
        case STATE_INIT:
            NSLog(@"TGStream: init");
            break;
        case STATE_RECORDING_END:
            NSLog(@"TGStream: record end");
            break;
        case STATE_RECORDING_START:
            NSLog(@"TGStream: record start");
            break;
        case STATE_STOPPED:
            NSLog(@"TGStream: stopped");
            break;
        case STATE_WORKING:
            NSLog(@"TGStream: working");
            break;
    }
}

-(void) onRecordFail:(RecrodError)flag{
    NSLog(@"%@\n Record Fail:%lu\n",[self NowString],(unsigned long)flag);
}
#endif

#pragma mark
#pragma NSK EEG SDK Delegate
- (void)stateChanged:(NskAlgoState)state reason:(NskAlgoReason)reason {
    if (stateStr == nil) {
        stateStr = [[NSMutableString alloc] init];
    }
    [stateStr setString:@""];
    [stateStr appendString:@"SDK State: "];
    switch (state) {
        case NskAlgoStateCollectingBaselineData:
        {
            bRunning = TRUE;
            bPaused = FALSE;
            [stateStr appendString:@"Collecting baseline"];
            dispatch_async(dispatch_get_main_queue(), ^{
            //    [_startPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
              //  [_startPauseButton setEnabled:YES];
              //  [_stopButton setEnabled:YES];
            });
        }
            break;
        case NskAlgoStateAnalysingBulkData:
        {
            bRunning = TRUE;
            bPaused = FALSE;
            [stateStr appendString:@"Analysing Bulk Data"];
            dispatch_async(dispatch_get_main_queue(), ^{
            //    [_startPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
              //  [_startPauseButton setEnabled:NO];
              //  [_stopButton setEnabled:YES];
            });
        }
            break;
        case NskAlgoStateInited:
        {
            bRunning = FALSE;
            bPaused = TRUE;
            [stateStr appendString:@"Inited"];
            dispatch_async(dispatch_get_main_queue(), ^{
              /*  [_startPauseButton setTitle:@"Start" forState:UIControlStateNormal];
                [_startPauseButton setEnabled:YES];
                [_stopButton setEnabled:NO];*/
             //   [_attLevelIndicator setProgress:0.0f];
              //  [_attValue setText:@""];
                
               /* [_medLevelIndicator setProgress:0.0f];
                [_medValue setText:@""];*/
                
                //                [_intervalSlider setEnabled:YES];
                //                [_intervalValue setEnabled:YES];
                //                [_configButton setEnabled:YES];
            });
        }
            break;
        case NskAlgoStatePause:
        {
            bPaused = TRUE;
            [stateStr appendString:@"Pause"];
            dispatch_async(dispatch_get_main_queue(), ^{
              /*  [_startPauseButton setTitle:@"Start" forState:UIControlStateNormal];
                [_startPauseButton setEnabled:YES];
                [_stopButton setEnabled:YES];*/
            });
        }
            break;
        case NskAlgoStateRunning:
        {
            [stateStr appendString:@"Running"];
            bRunning = TRUE;
            bPaused = FALSE;
            dispatch_async(dispatch_get_main_queue(), ^{
              /*  [_startPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
                [_startPauseButton setEnabled:YES];
                [_stopButton setEnabled:YES];*/
            });
        }
            break;
        case NskAlgoStateStop:
        {
            [stateStr appendString:@"Stop"];
            bRunning = FALSE;
            bPaused = TRUE;
            dispatch_async(dispatch_get_main_queue(), ^{
             /*   [_startPauseButton setTitle:@"Start" forState:UIControlStateNormal];
                [_startPauseButton setEnabled:YES];
                [_stopButton setEnabled:NO];
                [_attLevelIndicator setProgress:0.0f];
                [_attValue setText:@""];
                
                [_medLevelIndicator setProgress:0.0f];
                [_medValue setText:@""];*/
                
                //                [_bcqThresholdTitle setEnabled:YES];
                //                [_bcqThreshold setEnabled:YES];
                //                [_bcqWindowTitle setEnabled:YES];
                //                [_bcqWindow setEnabled:YES];
                //                [_bcqWindowStepper setEnabled:YES];
                
               // [self.dataButton setEnabled:YES];
            });
        }
            break;
        case NskAlgoStateUninited:
            [stateStr appendString:@"Uninit"];
            break;
    }
    switch (reason) {
        case NskAlgoReasonBaselineExpired:
            [stateStr appendString:@" | Baseline expired"];
            break;
        case NskAlgoReasonConfigChanged:
            [stateStr appendString:@" | Config changed"];
            break;
        case NskAlgoReasonNoBaseline:
            [stateStr appendString:@" | No Baseline"];
            break;
        case NskAlgoReasonSignalQuality:
            [stateStr appendString:@" | Signal quality"];
            break;
        case NskAlgoReasonUserProfileChanged:
            [stateStr appendString:@" | User profile changed"];
            break;
        case NskAlgoReasonUserTrigger:
            [stateStr appendString:@" | By user"];
            break;
    }
    printf([stateStr UTF8String]);
    printf("\n");
    dispatch_async(dispatch_get_main_queue(), ^{
        //code you want on the main thread.
       // self.stateLabel.text = stateStr;
    });
}

/*- (void) addValue: (NSNumber*)value array:(NSMutableArray*)array {
    @synchronized(graph) {
        if ([array count] >= X_RANGE) {
            [array removeObjectAtIndex:0];
        }
        [array addObject:
         @{ @(CPTScatterPlotFieldX): @([array count]),
            @(CPTScatterPlotFieldY): @([value floatValue]) }
         ];
        
        for (int j=0;j<SegmentMax;j++) {
            if (algoList[j].plotAvailable == YES) {
                for (int i=0;i<[algoList[j] getPlotCount];i++) {
                    NSMutableArray *index = nil;
                    if ([algoList[j] getIndex:i] == array) {
                        index = [algoList[j] getIndex:i];
                        
                        for (int i=0;i<[index count];i++) {
                            NSDictionary *dict = @{ @(CPTScatterPlotFieldX): @(i), @(CPTScatterPlotFieldY): index[i][@(CPTScatterPlotFieldY)] };
                            [index replaceObjectAtIndex:i withObject:dict];
                        }
                    }
                }
            }
        }
    }
}
*/
int status = 0;
- (void)signalQuality:(NskAlgoSignalQuality)signalQuality {
    if (signalStr == nil) {
        signalStr = [[NSMutableString alloc] init];
    }
    [signalStr setString:@""];
    [signalStr appendString:@"Signal quailty: "];
    switch (signalQuality) {
        case NskAlgoSignalQualityGood:
            status = 3;
            [signalStr appendString:@"Good"];
            break;
        case NskAlgoSignalQualityMedium:
            status = 2;
            [signalStr appendString:@"Medium"];
            break;
        case NskAlgoSignalQualityNotDetected:
            status = 0;
            [signalStr appendString:@"Not detected"];
            break;
        case NskAlgoSignalQualityPoor:
            status = 1;
            [signalStr appendString:@"Poor"];
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //code you want on the main thread.
       // self.signalLabel.text = signalStr;
    });
}

float lMeditation = 0;
float lAttention = 0;
int bp_index = 0;

- (void)bpAlgoIndex:(NSNumber *)delta theta:(NSNumber *)theta alpha:(NSNumber *)alpha beta:(NSNumber *)beta gamma:(NSNumber *)gamma {
    NSLog(@"bp[%d] = (delta)%1.6f (theta)%1.6f (alpha)%1.6f (beta)%1.6f (gamma)%1.6f", bp_index, [delta floatValue], [theta floatValue], [alpha floatValue], [beta floatValue], [gamma floatValue]);
    bp_index++;
    
   /* [self addValue:delta array:[algoList[SegmentEEGBandpower] getIndex:0]];
    [self addValue:theta array:[algoList[SegmentEEGBandpower] getIndex:1]];
    [self addValue:alpha array:[algoList[SegmentEEGBandpower] getIndex:2]];
    [self addValue:beta array:[algoList[SegmentEEGBandpower] getIndex:3]];
    [self addValue:gamma array:[algoList[SegmentEEGBandpower] getIndex:4]];*/
}

- (void)medAlgoIndex:(NSNumber *)med_index {
    //NSLog(@"Meditation: %f", [value floatValue]);
    lMeditation = [med_index floatValue];
    dispatch_sync(dispatch_get_main_queue(), ^{
       // [_medLevelIndicator setProgress:(lMeditation/100.0f)];
       // [_medValue setText:[NSString stringWithFormat:@"%3.0f", lMeditation]];
    });
}

- (void)attAlgoIndex:(NSNumber *)att_index {
    //NSLog(@"Attention: %f", [value floatValue]);
    lAttention = [att_index floatValue];
    dispatch_sync(dispatch_get_main_queue(), ^{
       // [_attLevelIndicator setProgress:(lAttention/100.0f)];
        //[_attValue setText:[NSString stringWithFormat:@"%3.0f", lAttention]];
    });
}

BOOL bBlink = NO;
- (void)eyeBlinkDetect:(NSNumber *)strength {
    NSLog(@"Eye blink detected: %d", [strength intValue]);
    dispatch_sync(dispatch_get_main_queue(), ^{
       // [_blinkImage setImage:[UIImage imageNamed:@"led-on"]];
        bBlink = YES;
        //[NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(eyeBlinkAnimate) userInfo:nil repeats:NO];
    });
}

- (void)eyeBlinkAnimate {
    if (bBlink) {
      //  [_blinkImage setImage:[UIImage imageNamed:@"led-off"]];
        bBlink = NO;
    }
}

#pragma mark -
#pragma mark Plot Data Source Methods

/*-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    for (int i=0;i<SegmentMax;i++) {
        for (int j=0;j<[algoList[i] getPlotCount];j++) {
            CPTPlot *pt = [algoList[i] getPlot:j];
            if (pt == plot) {
                return [[algoList[i] getIndex:j] count];
            }
        }
    }
    return 0;
}

-(id)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    for (int i=0;i<SegmentMax;i++) {
        for (int j=0;j<[algoList[i] getPlotCount];j++) {
            CPTPlot *pt = [algoList[i] getPlot:j];
            if (pt == plot) {
                return [algoList[i] getIndex:j][index][@(fieldEnum)];
            }
        }
    }
    return nil;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(UIEvent *)event atPoint:(CGPoint)point {
    return YES;
}*/

#pragma mark -
#pragma mark Plot Delegate Methods

/*-(void)plot:(CPTPlot *)plot dataLabelTouchDownAtRecordIndex:(NSUInteger)idx {
    NSLog(@"%lu is touched", (unsigned long)idx);
}*/




-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    // //NSLog(@"numberOfComponentsInPickerView-------");
    //
    // only 1 scrollable list
    return 1;
}

//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    // //NSLog(@"numberOfRowsInComponent-------");
  //  int count;
   // count = (int) devicesArray.count;
   // return count;
//}

//MWM Device delegate-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->-->
/*-(void)deviceFound:(NSString *)devName MfgID:(NSString *)mfgID DeviceID:(NSString *)deviceID
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
}

-(void)eegBlink:(int)blinkValue
{
    NSLog(@"%s >>>>>>>-----eegBlink: blinkValue:%d ", __func__,  blinkValue);
}

-(void)mwmBaudRate:(int)baudRate NotchFilter:(int)notchFilter
{
    NSLog(@"%s >>>>>>>-----mwmBaudRate:%d NotchFilter:%d ", __func__,  baudRate, notchFilter);
}

*/
#pragma mark - Codea Addon Protocol Implementation

- (void) codea:(StandaloneCodeaViewController*)codeaController didCreateLuaState:(struct lua_State*)L
{
    #ifdef IOS_DEVICE
    // we use real mindwave headset on iOS device
    [[TGStream sharedInstance] setDelegate:self];
    [[TGStream sharedInstance] initConnectWithAccessorySession];
    [[NskAlgoSdk sharedInstance] startProcess];
    #endif
    
    CODEA_ADDON_REGISTER(MINDWAVE_LIB_NAME, luaopen_mindwave);
}

static int mindwave_attention(struct lua_State* L)
{
 //     [[NskAlgoSdk sharedInstance] startProcess];
    //attAlgoIndex();
   // lAttention = [att_index floatValue];
    //lAttention
    int temp = lAttention;
   // int temp = attention;
   // int16_t attention;
    //attention[0] = (int16_t)data;
    //int temp =  [[NskAlgoSdk sharedInstance]]->Nsk;
    //printf("%.6f", lAttention);
    lua_pushinteger(L, temp);
    
    return 1;
}
static int mindwave_status(struct lua_State* L) {
    lua_pushinteger(L, status);
    return 1;
}
static int mindwave_isBlink(struct lua_State* L)
{
    //printf("%d\n", bBlink);
    lua_pushboolean(L, bBlink);
    if (bBlink) {
        bBlink = NO;
    }
    
    return 1;
}



@end

