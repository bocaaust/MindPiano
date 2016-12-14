//
//  AlgoContext.m
//  Algo SDK Sample
//
//  Created by Donald on 29/12/15.
//  Copyright © 2015 NeuroSky. All rights reserved.
//

#import "AlgoContext.h"

@implementation AlgoContext {
    NSString *plotName[5];
    CPTPlot *plot[5];
    NSMutableArray *index[5];
    CPTColor *color[5];
}

- (id)init {
    self = [super init];
    if (self != nil) {
        color[0] = [CPTColor redColor];
        color[1] = [CPTColor blueColor];
        color[2] = [CPTColor greenColor];
        color[3] = [CPTColor purpleColor];
        color[4] = [CPTColor blackColor];
    }
    return self;
}

- (void) setSetting:(ALGO_SETTING)setting {
    _interval = setting.interval;
    _xRange = setting.xRange;
    _plotMaxY = setting.plotMaxY;
    _plotMinY = setting.plotMinY;
    _minInterval = setting.minInterval;
    _maxInterval = setting.maxInterval;
}

- (void) setPlot:(CPTPlot*)pt idx:(int)idx {
    plot[idx] = pt;
}

- (CPTPlot*) getPlot: (int)idx {
    return plot[idx];
}

- (void) setIndex:(int)idx {
    index[idx] = [[NSMutableArray alloc] init];
}

- (NSMutableArray*) getIndex: (int)idx {
    return index[idx];
}

- (int)getPlotCount {
    return 5;
}

- (void)setPlotName:(NSString *)name idx:(int)idx {
    plotName[idx] = name;
}

- (NSString *)getPlotName:(int)idx {
    return plotName[idx];
}

- (CPTColor*)getPlotColor:(int)idx {
    return color[idx];
}

@end
