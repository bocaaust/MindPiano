//
//  AlgoContext.h
//  Algo SDK Sample
//
//  Created by Donald on 29/12/15.
//  Copyright © 2015 NeuroSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

typedef struct _ALGO_SETTING {
    float xRange;
    float plotMinY;
    float plotMaxY;
    
    int interval;
    
    int minInterval;
    int maxInterval;
} ALGO_SETTING;

@interface AlgoContext : NSObject {

}

@property (atomic) BOOL plotAvailable;

@property (atomic, strong) NSString *graphTitle;

@property float xRange;
@property float plotMinY;
@property float plotMaxY;

@property int interval;

@property int minInterval;
@property int maxInterval;

- (void) setSetting:(ALGO_SETTING)setting;
- (int) getPlotCount;
- (void) setPlot:(CPTPlot*)pt idx:(int)idx;
- (CPTPlot*) getPlot: (int)idx;
- (void) setIndex:(int)idx;
- (NSMutableArray*) getIndex: (int)idx;
- (void) setPlotName: (NSString*)name idx:(int)idx;
- (NSString*) getPlotName: (int)idx;
- (CPTColor*) getPlotColor:(int)idx;

@end
