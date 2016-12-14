//
//  LineGraphView.h
//  MindView
//
//  Created by NeuroSky on 10/13/11.
//  Copyright 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>

//#import "TGLibEKG.h"
//#import "TGLibEKGdelegate.h"

#define AVERAGE_COUNT 50
#define DECIMATE 4
#define BANDPASS_ENABLED YES
//#define BANDPASS_ENABLED NO
#define CARDIO_SCALER 0.3
#define EEG_SCALER 1.0
#define GRID_ENABLED NO;
#define LINE_WIDTH 1.0

@interface LineGraphView : UIView {
    
    NSMutableArray *data;
    
    double xAxisMin;
    double xAxisMax;
    double yAxisMin;
    double yAxisMax;
    int dataRate;
    
    NSLock *dataLock;
    
    int startIndex;
    
    int index;
    double scaler;
    
    NSTimer *reDrawTimer;
    NSThread *redraw;
    
    UIColor * __weak backgroundColor;
    UIColor * __weak lineColor;
    UIColor * __weak cursorColor;
    BOOL cursorEnabled;
    BOOL gridEnabled;
    BOOL touchEnabled;
    BOOL invertSignal;

    BOOL bandOnRightWrist;
    
@private
    SEL addTo;
    id __weak tagert;
    
    //TGHrv * hrv;
    //int rrint;
    AVAudioPlayer * audio;
    
    UIPinchGestureRecognizer * pinch;
    UITapGestureRecognizer * taptap;
    BOOL newData;
    int decimateCount;
    
    /* DC offset removal */
    int averageCount;
    double average;
    BOOL offsetRemovalEnabled;
    
    // for bandpass filter
    float * ECGbuffer;
    float * filteredPoint;

    int ECGBufferCounter;
    int ECGBufferLength;
    int hpcoeffLength;
    
    UIBezierPath *smallGrid;
    UIBezierPath *grid;
    UIBezierPath *path;
    UIBezierPath *cursor;
    
}

- (CGPoint)point2PixelsWithXValue:(double) xValue yValue:(double) yValue;
- (void)addPoint;
- (double)addValue:(double) value;
- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer;
- (void)doubleTap;
- (void)cleardata;

@property (weak) UIColor * backgroundColor;
@property (weak) UIColor * lineColor;
@property (weak) UIColor * cursorColor;
@property BOOL cursorEnabled;

@property BOOL bandOnRightWrist;

@property (weak)id tagert;
@property SEL addTo;

@property double scaler;
@property double xAxisMax;

@end
