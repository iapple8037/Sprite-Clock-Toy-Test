//
//  YHToyQueue.h
//  Toy Test2
//
//  Created by YANAGIDA on 2014/06/16.
//  Copyright (c) 2014年 YANAGIDA. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface YHToyQueue : SKSpriteNode

+(id)toyQueue;
-(void)walkingToy;
-(void)jump;

@end
NSArray *_toyWalkingFrames;