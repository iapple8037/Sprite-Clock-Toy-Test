//
//  YHLondonbus.m
//  Toy Test2
//
//  Created by YANAGIDA on 2014/06/18.
//  Copyright (c) 2014年 YANAGIDA. All rights reserved.
//

#import "YHLondonbus.h"

@implementation YHLondonbus

+(id)london_bus
{
    YHLondonbus *london_bus = [YHLondonbus spriteNodeWithImageNamed:@"london_bus"];
    london_bus.name = @"londonbus";
    
    return london_bus;
}

-(void)driveLondonbus
{
    SKAction *actionDelay = [SKAction waitForDuration:4.0];
    SKAction *actionMove = [SKAction moveToX:-350 duration:6];
    [self runAction:[SKAction sequence:@[actionDelay , actionMove]]];
}

@end
