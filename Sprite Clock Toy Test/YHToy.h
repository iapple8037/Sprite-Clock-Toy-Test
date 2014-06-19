//
//  YHToy.h
//  Toy Test2
//
//  Created by YANAGIDA on 2014/06/14.
//  Copyright (c) 2014年 YANAGIDA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface YHToy : SKSpriteNode

+(id)toy;
-(void)walkingToy;
-(void)stopWalkingToy;
-(void)jump;
-(void)start;


@end
NSArray *_toyWalkingFrames;