//
//  LineGraphView.m
//  MindView
//
//  Created by NeuroSky on 10/13/11.
//  Copyright 2012. All rights reserved.
//

#import "LineGraphView.h"

@implementation LineGraphView
//
// this filter is just an example
// it has not been adapted for this sample rate
//
static float bandpass[] = { 0.0000000393290004,  0.0000000548608123,  0.0000000407899905, -0.0000000047891431, -0.0000000778155122, -0.0000001662094644, -0.0000002492368312, -0.0000002997167038, -0.0000002897980466, -0.0000001997209366, -0.0000000274637791,  0.0000002039720839,  0.0000004451242165,  0.0000006269587465,  0.0000006763902700,  0.0000005378712630,  0.0000001957714728, -0.0000003093632820, -0.0000008773612579, -0.0000013620864798, -0.0000016022820798, -0.0000014645292017, -0.0000008885907510,  0.0000000773272779,  0.0000012635545280,  0.0000023965685910,  0.0000031489264604,  0.0000032149473973,  0.0000023977823373,  0.0000006882856840, -0.0000016848564778, -0.0000042502476166, -0.0000063420892134, -0.0000071981911727, -0.0000060924560276, -0.0000024773579685,  0.0000038924254975,  0.0000128821929009,  0.0000239641304830,  0.0000362752273531,  0.0000487379178498,  0.0000602219734341,  0.0000697173177978,  0.0000764849870806,  0.0000801579847246,  0.0000807742635210,  0.0000787381217140,  0.0000747207571573,  0.0000695223902635,  0.0000639247774690,  0.0000585629138886,  0.0000538386074995,  0.0000498881138995,  0.0000466037716403,  0.0000436984310005,  0.0000407938264160,  0.0000375113106981,  0.0000335456930496,  0.0000287092504269,  0.0000229414166242,  0.0000162879906241,  0.0000088599999709,  0.0000007853742541, -0.0000078339584940, -0.0000169504162366, -0.0000265805440805, -0.0000367974897180, -0.0000477114737674, -0.0000594455396798, -0.0000721136169989, -0.0000858058920765, -0.0001005835125544, -0.0001164817342911, -0.0001335185554149, -0.0001517050958602, -0.0001710544493938, -0.0001915870634821, -0.0002133322997456, -0.0002363271228805, -0.0002606134880016, -0.0002862358692339, -0.0003132925469919, -0.0003417773579588, -0.0003717235570448, -0.0004031630319051, -0.0004361262265917, -0.0004706420667875, -0.0005067378867585, -0.0005444393581615, -0.0005837704208381, -0.0006247532157268, -0.0006674080200203, -0.0007117531846911, -0.0007578050745073, -0.0008055780106565, -0.0008550842160887, -0.0009063337636910, -0.0009593345273968, -0.0010140921363318, -0.0010706099320921, -0.0011288889292471, -0.0011889277791527, -0.0012507227371566, -0.0013142676332720, -0.0013795538463910, -0.0014465702821011, -0.0015153033541666, -0.0015857369697273, -0.0016578525182622, -0.0017316288643604, -0.0018070423443349, -0.0018840667667084, -0.0019626734165943, -0.0020428310639898, -0.0021245059759918, -0.0022076619329392, -0.0022922602484795, -0.0023782597935501, -0.0024656170242604, -0.0025542860136513, -0.0026442184873047, -0.0027353638627677, -0.0028276692927517, -0.0029210797120565, -0.0030155378881689, -0.0031109844754727, -0.0032073580730066, -0.0033045952856963, -0.0034026307889833, -0.0035013973967671, -0.0036008261325704, -0.0037008463038333, -0.0038013855792339, -0.0039023700689333, -0.0040037244076297, -0.0041053718403095, -0.0042072343105730, -0.0043092325514096, -0.0044112861782943, -0.0045133137844707, -0.0046152330382834, -0.0047169607824183, -0.0048184131349073, -0.0049195055917467, -0.0050201531309815, -0.0051202703180990, -0.0052197714125768, -0.0053185704754266, -0.0054165814775716, -0.0055137184088972, -0.0051592715821388, -0.0055119281336323, -0.0059391621887012, -0.0063983147738999, -0.0068215885083256, -0.0071154534736251, -0.0071761015132298, -0.0069217917917386, -0.0063345766258185, -0.0054966775790169, -0.0046039345399364, -0.0039423550190442, -0.0038238402631405, -0.0044912644821208, -0.0060169488074872, -0.0082272393637669, -0.0106853247942787, -0.0127529840853119, -0.0137313226227415, -0.0130556636030003, -0.0104976866442474, -0.0063159469914293, -0.0012993792402467,  0.0033312589367558,  0.0061651461385891,  0.0059477705472733,  0.0019581489765689, -0.0056771246154247, -0.0158248918220140, -0.0264067602388562, -0.0346991363077483, -0.0378333296738435, -0.0334036346731996, -0.0200553190553098,  0.0020835155785264,  0.0312380601583490,  0.0641501661666408,  0.0965582238238187,  0.1239113726992964,  0.1421799512827066,  0.1485975446518902,  0.1421799512827065,  0.1239113726992964,  0.0965582238238186,  0.0641501661666407,  0.0312380601583490,  0.0020835155785264, -0.0200553190553098, -0.0334036346731996, -0.0378333296738435, -0.0346991363077483, -0.0264067602388562, -0.0158248918220140, -0.0056771246154247,  0.0019581489765689,  0.0059477705472733,  0.0061651461385891,  0.0033312589367559, -0.0012993792402467, -0.0063159469914293, -0.0104976866442474, -0.0130556636030003, -0.0137313226227415, -0.0127529840853119, -0.0106853247942787, -0.0082272393637669, -0.0060169488074872, -0.0044912644821208, -0.0038238402631405, -0.0039423550190442, -0.0046039345399364, -0.0054966775790169, -0.0063345766258185, -0.0069217917917386, -0.0071761015132298, -0.0071154534736251, -0.0068215885083256, -0.0063983147738999, -0.0059391621887012, -0.0055119281336323, -0.0051592715821388, -0.0055137184088972, -0.0054165814775716, -0.0053185704754266, -0.0052197714125768, -0.0051202703180990, -0.0050201531309815, -0.0049195055917467, -0.0048184131349073, -0.0047169607824183, -0.0046152330382834, -0.0045133137844707, -0.0044112861782943, -0.0043092325514096, -0.0042072343105730, -0.0041053718403095, -0.0040037244076297, -0.0039023700689333, -0.0038013855792339, -0.0037008463038333, -0.0036008261325704, -0.0035013973967671, -0.0034026307889833, -0.0033045952856963, -0.0032073580730066, -0.0031109844754727, -0.0030155378881689, -0.0029210797120565, -0.0028276692927517, -0.0027353638627677, -0.0026442184873047, -0.0025542860136513, -0.0024656170242604, -0.0023782597935501, -0.0022922602484795, -0.0022076619329392, -0.0021245059759918, -0.0020428310639898, -0.0019626734165943, -0.0018840667667084, -0.0018070423443349, -0.0017316288643604, -0.0016578525182622, -0.0015857369697273, -0.0015153033541666, -0.0014465702821011, -0.0013795538463910, -0.0013142676332720, -0.0012507227371566, -0.0011889277791527, -0.0011288889292471, -0.0010706099320921, -0.0010140921363317, -0.0009593345273968, -0.0009063337636910, -0.0008550842160887, -0.0008055780106565, -0.0007578050745073, -0.0007117531846911, -0.0006674080200203, -0.0006247532157268, -0.0005837704208381, -0.0005444393581615, -0.0005067378867585, -0.0004706420667875, -0.0004361262265917, -0.0004031630319051, -0.0003717235570448, -0.0003417773579588, -0.0003132925469919, -0.0002862358692339, -0.0002606134880016, -0.0002363271228805, -0.0002133322997456, -0.0001915870634821, -0.0001710544493938, -0.0001517050958602, -0.0001335185554149, -0.0001164817342911, -0.0001005835125544, -0.0000858058920765, -0.0000721136169989, -0.0000594455396798, -0.0000477114737674, -0.0000367974897180, -0.0000265805440805, -0.0000169504162366, -0.0000078339584940,  0.0000007853742541,  0.0000088599999709,  0.0000162879906241,  0.0000229414166242,  0.0000287092504269,  0.0000335456930496,  0.0000375113106981,  0.0000407938264160,  0.0000436984310005,  0.0000466037716403,  0.0000498881138995,  0.0000538386074995,  0.0000585629138886,  0.0000639247774690,  0.0000695223902635,  0.0000747207571573,  0.0000787381217140,  0.0000807742635210,  0.0000801579847246,  0.0000764849870806,  0.0000697173177978,  0.0000602219734341,  0.0000487379178498,  0.0000362752273531,  0.0000239641304830,  0.0000128821929009,  0.0000038924254975, -0.0000024773579685, -0.0000060924560276, -0.0000071981911727, -0.0000063420892134, -0.0000042502476166, -0.0000016848564778,  0.0000006882856840,  0.0000023977823373,  0.0000032149473973,  0.0000031489264604,  0.0000023965685910,  0.0000012635545280,  0.0000000773272779, -0.0000008885907510, -0.0000014645292017, -0.0000016022820798, -0.0000013620864798, -0.0000008773612579, -0.0000003093632820,  0.0000001957714728,  0.0000005378712630,  0.0000006763902700,  0.0000006269587465,  0.0000004451242165,  0.0000002039720839, -0.0000000274637791, -0.0000001997209366, -0.0000002897980466, -0.0000002997167038, -0.0000002492368312, -0.0000001662094644, -0.0000000778155122, -0.0000000047891431,  0.0000000407899905,  0.0000000548608123,  0.0000000393290004};

@synthesize backgroundColor;
@synthesize lineColor;
@synthesize cursorColor;
@synthesize cursorEnabled;
@synthesize addTo;
@synthesize tagert;
@synthesize scaler;
@synthesize xAxisMax;
@synthesize bandOnRightWrist;

float numberOfBigBlocks;
float numberOfSmallBlocks;
float bigBlockSize;
float smallBlockSize;
float lineOffset;
float gridScale;


- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }    
    return self;
}

- (void)initialize {
//  //NSLog(@"bandpass.length  ==== %d" ,bandpass.length);
    
    
    xAxisMin = 0;    //seconds
    xAxisMax = 6;    //seconds
    yAxisMin = -2048;
    yAxisMax = 2048;
    dataRate = 128; // display rate, 128 shows 256Hz samples at half speed

    decimateCount = 0;
    averageCount = 0;
    offsetRemovalEnabled = NO;
    lineOffset = 1;
    
    invertSignal = bandOnRightWrist;
    
    if (bandOnRightWrist)
    {
        //NSLog(@"LineGraphView: band is on RIGHT Wrist");
    }
    else
    {
        //NSLog(@"LineGraphView: band is on LEFT Wrist");
    }
    
    data = [[NSMutableArray alloc] initWithCapacity:(dataRate * xAxisMax)];
    
    index = 0;
    //scaler = 0.3;
    scaler = CARDIO_SCALER;
    
    dataLock = [[NSLock alloc] init];
       
    redraw = [[NSThread alloc] initWithTarget:self selector:@selector(redrawThread) object:nil];
    [redraw start];
    
    if(backgroundColor == nil) {
        backgroundColor = [UIColor clearColor];
        self.backgroundColor = backgroundColor;
    }
    
    //self.backgroundColor = [UIColor clearColor];
    lineColor = [UIColor blackColor];
    cursorColor = [UIColor redColor];
    
    cursorEnabled = YES;
    gridEnabled = YES;
    touchEnabled = NO;
    
    if(touchEnabled) {
        pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
        [self addGestureRecognizer:pinch];
        taptap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
        taptap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:taptap];
    }
    
    //set up bandpass
    hpcoeffLength = sizeof(bandpass) / sizeof(bandpass[0]);
    ECGBufferLength = hpcoeffLength;
    ECGbuffer = (float *)malloc(ECGBufferLength * sizeof(float));
    filteredPoint = (float *)malloc(sizeof(float));
    
    ECGBufferCounter = 0;
    
    NSURL * url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/BeepLow.aiff", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                   error:&error];
}

- (void)dealloc {
    free(ECGbuffer);
    free(filteredPoint);
}

- (void)drawRect:(CGRect)clientRect {

    if(data.count > 1) {
        
        if(gridEnabled) {
            
            numberOfBigBlocks = (xAxisMax / 0.2);
            numberOfSmallBlocks = numberOfBigBlocks * 5;
            bigBlockSize = (self.frame.size.width / numberOfBigBlocks);
            smallBlockSize = bigBlockSize / 5;
            gridScale = scaler - CARDIO_SCALER;
            
            // Small Blocks
            smallGrid = [UIBezierPath bezierPath];
            [smallGrid removeAllPoints];
            [smallGrid setLineWidth:0.2];
            
            // Vertical lines
            [smallGrid moveToPoint:[self point2PixelsWithXValue:0.0 yValue:yAxisMax]];
            for (int i = 0; i < numberOfSmallBlocks; i++) {
                [smallGrid addLineToPoint:CGPointMake((i * smallBlockSize), yAxisMin)];
                [smallGrid moveToPoint:CGPointMake((i + 1) * smallBlockSize, yAxisMax)];
            }
            
            // Horizontal lines
            [smallGrid moveToPoint:[self point2PixelsWithXValue:0.0 yValue:yAxisMax + lineOffset]];
            for (int i = 0; i < numberOfSmallBlocks; i++) {
                
                [smallGrid addLineToPoint:CGPointMake(xAxisMin, (i * smallBlockSize) + lineOffset)];                
                [smallGrid moveToPoint:CGPointMake(self.frame.size.width, ((i + 1) * smallBlockSize) + lineOffset)];
            }
            
            [[UIColor redColor] set];
            [smallGrid stroke];
            
            // Large blocks
            
            grid = [UIBezierPath bezierPath];
            [grid removeAllPoints];
            [grid setLineWidth:0.3];
            
            // Vertical lines
            [grid moveToPoint:[self point2PixelsWithXValue:0.0 yValue:yAxisMax]];
            for (int i = 0; i < numberOfBigBlocks; i++) {
                [grid addLineToPoint:CGPointMake((i * bigBlockSize), yAxisMin)];
                [grid moveToPoint:CGPointMake((i + 1) * bigBlockSize, yAxisMax)];
            }
            
            // Horizontal lines
            [grid moveToPoint:[self point2PixelsWithXValue:0.0 yValue:yAxisMax + lineOffset]];
            for (int i = 0; i < numberOfBigBlocks; i++) {

                [grid addLineToPoint:CGPointMake(xAxisMin, (i * bigBlockSize) + lineOffset)];
                
                [grid moveToPoint:CGPointMake(self.frame.size.width, ((i + 1) * bigBlockSize) + lineOffset)];
            }
            
            [[UIColor redColor] set];
            [grid stroke];
        }
        
        path = [UIBezierPath bezierPath];
        [path removeAllPoints];

        [path setLineWidth:LINE_WIDTH];
        [path moveToPoint:CGPointMake(0, clientRect.size.height/2)];
        
        for(int i = 0; i < data.count; i++) {
     
            NSNumber *tempValue = (NSNumber *)[data objectAtIndex:i]; 
            
            CGPoint tempPixel = [self point2PixelsWithXValue:i
                                                      yValue:([tempValue doubleValue] * scaler)];
            [path addLineToPoint:tempPixel];
        }
        
        [lineColor set];
        [path stroke];
        if(cursorEnabled) {
            cursor = [UIBezierPath bezierPath];
            [cursor removeAllPoints];
            //            [cursor setLineWidth:0.8];
            [cursor setLineWidth:2];
            [cursor moveToPoint:[self point2PixelsWithXValue:index yValue:yAxisMax]];
            [cursor addLineToPoint:[self point2PixelsWithXValue:index yValue:yAxisMin]];
            [cursorColor set];
            [cursor stroke];
        }
        newData = NO;
    }    
}

- (CGPoint)point2PixelsWithXValue:(double) xValue yValue:(double) yValue {
    CGPoint temp = {0, 0};
    
    temp.x = xValue * self.frame.size.width / (dataRate / DECIMATE * xAxisMax);
    temp.y = ((yValue - yAxisMin) / (yAxisMax - yAxisMin) * self.frame.size.height);
    
    if(!invertSignal) temp.y = self.bounds.size.height - temp.y;
    
    return temp;
}

- (void)addPoint {
    int f = 10;
    double x = index++ / dataRate;
    double y = sin(2 * M_PI * x * f);
    NSValue *temp = [NSValue valueWithCGPoint:CGPointMake(x,y)];
    
    [dataLock lock];
    [data addObject:temp];
    if(data.count > xAxisMax * dataRate) {
        [data removeObjectAtIndex:0];
    }
    [dataLock unlock];
}

- (double)addValue:(double) value {
    
    double newValue = value;
    if (!bandOnRightWrist) {
        newValue = -value; // invert the data
    }
    if(BANDPASS_ENABLED) {
        
        // shift in new sample to buffer
        for (int i = 0; i < ECGBufferLength - 1; i++) {
            ECGbuffer[i] = ECGbuffer[i + 1];
        }
        ECGbuffer[ECGBufferLength - 1] = (float)newValue;
        
        if(ECGBufferCounter < ECGBufferLength)
            ECGBufferCounter++;
        
        if(ECGBufferCounter == ECGBufferLength) {
            vDSP_conv(ECGbuffer, 1, bandpass, 1, filteredPoint, 1, 1, hpcoeffLength);
        }
        newValue = (double)filteredPoint[0];
    }
    
    /*
    int rrint = [hrv addData:(int)value];
    if(rrint > 0) {
        //[audio play];
        [NSThread detachNewThreadSelector:@selector(playBeep) toTarget:self withObject:nil];
        //NSLog(@"%s HR: %d", __func__,  60000/rrint);
    }
    */
    
    decimateCount++;
    if (decimateCount < DECIMATE) {
        return newValue;
    } else {
        decimateCount = 0;
    }
    if (index > dataRate / DECIMATE * xAxisMax - 1) {
        
        
//        [self.tagert performSelector:addTo withObject:nil];
        index = 0;
    }  
    
    if(offsetRemovalEnabled){
        if(averageCount < AVERAGE_COUNT) averageCount++;
//        [self.tagert performSelector:addTo withObject:nil];

        average = (average*(averageCount - 1) + newValue)/averageCount;
    }else {
        average = 0;
    }
    
    [dataLock lock];
    
    if(data.count < dataRate / DECIMATE * xAxisMax) {
        [data insertObject:[NSNumber numberWithDouble:newValue - average] atIndex:index];
    }else {
        [data replaceObjectAtIndex:index withObject:[NSNumber numberWithDouble:newValue - average] ];
    }

    

    index++;
    [dataLock unlock];
    newData = YES;
    
    return newValue;
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer {
    scaler += recognizer.scale - 1;
    if(scaler < 0.4)
        scaler = 0.4;
    else if (scaler > 5)
        scaler = 5;
    
}

- (void)doubleTap {
    scaler = 1;
}

- (void)redrawThread {
    while (true) {
        if (newData) {
            [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
        }
        [NSThread sleepForTimeInterval:0.033];
    }
    
}

-(void)cleardata{
    
  //  newData = NO;
    [dataLock lock];
    [data removeAllObjects];
    decimateCount = 0;
    averageCount = 0;
    index = 0;
    [dataLock unlock];    
}

- (void)playBeep {
    [audio play];    
}



@end
