//
//  YHToy.m
//  Toy Test2
//
//  Created by YANAGIDA on 2014/06/14.
//  Copyright (c) 2014年 YANAGIDA. All rights reserved.
//

#import "YHToy.h"

@implementation YHToy

+(id)toy
{
    NSMutableArray *walkingFrames = [NSMutableArray array];
    SKTextureAtlas *toyAnimatedAtlas = [SKTextureAtlas atlasNamed:@"ToyImages"];
    int numImages = toyAnimatedAtlas.textureNames.count;
    for (int i = 1; i <= numImages/2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"toy_%d", i];
        SKTexture *temp = [toyAnimatedAtlas  textureNamed:textureName];
        [walkingFrames addObject:temp];
    }
    _toyWalkingFrames = walkingFrames;
    
    SKTexture *temp = _toyWalkingFrames[0];
    YHToy *toy = [YHToy spriteNodeWithTexture:temp];
    toy.name = @"toy";
    [toy runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_toyWalkingFrames
                                                                  timePerFrame:0.2f
                                                                        resize:NO
                                                                       restore:YES]]withKey:@"walkingInPlaceToy"];
    toy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:toy.size];
    return toy;
}

-(void)walkingToy
{
    SKAction *actionMove = [SKAction moveToX:-350 duration:20];
    [self runAction:actionMove withKey:@"walkingToy"];
}

-(void)stopWalkingToy
{
    [self removeActionForKey:@"walkingToy"];//walkingToyのsctionMoveアクションを止める。
}

-(void)jump
{
    [self.physicsBody applyImpulse:CGVectorMake(0, 800)];
}

-(void)start
{
    SKAction *incrementLeft = [SKAction moveByX:-1.0 y:0 duration:0.03];
    SKAction *moveLeft = [SKAction repeatActionForever:incrementLeft];
    [self runAction:moveLeft];
}



@end
