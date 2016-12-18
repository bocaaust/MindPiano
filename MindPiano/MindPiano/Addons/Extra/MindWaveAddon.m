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

static int mindwave_enabled(struct lua_State* L);

static int mindwave_attention(struct lua_State* L);

static int mindwave_isBlink(struct lua_State* L);

#pragma mark - Lua Function Mappings

static const luaL_Reg mindwaveLibs[] =
{
    {"enabled", mindwave_enabled},
    {"getAttention", mindwave_attention},
    {"isBlink", mindwave_isBlink},
    {NULL, NULL}
};

static int luaopen_mindwave(lua_State *L)
{
    //Register Mindwave functions with Lua
    lua_newtable(L);
    luaL_setfuncs(L, mindwaveLibs, 0);
    
    return 1;
}

#pragma mark - Game Center Addon

@interface MindWaveAddon ()<MWMDelegate>

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

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialise our Instance Variables
        _mindwaveEnabled = NO;
        _isBlinking = NO;
        _attention = 0;
        
        // Initialize Device
        
        mwDevice = [MWMDevice sharedInstance];
        [mwDevice setDelegate:self];
        
    }
    return self;
}


#pragma mark - Mind Wave Helper Methods




@end

