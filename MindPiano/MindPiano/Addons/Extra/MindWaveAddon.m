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

#import "MWMDevice.h"

#import "lua.h"
#import "lauxlib.h"

#pragma mark - Lua Functions

static int attention(struct lua_State* L);

static int is_blink(struct lua_State* L);
