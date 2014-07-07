//
//  YHToyDown.h
//  Sprite Clock Toy Test
//
//  Created by HIROKI on 2014/07/03.
//  Copyright (c) 2014年 YANAGIDA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface YHToyDown : SKSpriteNode

+(id)toyDown;
-(void)walkingToy;
-(void)jump;
-(void)start;

@end
NSArray *_toyWalkingFrames;