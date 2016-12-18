//
//  MindWaveAddon.h
//  MindPiano
//
//  Created by Austin Lubetkin on 12/17/16.
//  Copyright © 2016 MyCompany. All rights reserved.
//



#import <Foundation/Foundation.h>

#import "CodeaAddon.h"

@interface MindWaveAddon : CodeaAddon

+ (instancetype) sharedInstance;

@property (nonatomic, assign) BOOL mindwaveEnabled;
@property (nonatomic, assign) BOOL isBlinking;
@property (nonatomic, assign) int attention;

@end

