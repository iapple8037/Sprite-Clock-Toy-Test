//
//  YHToyDown.m
//  Sprite Clock Toy Test
//
//  Created by HIROKI on 2014/07/03.
//  Copyright (c) 2014年 YANAGIDA. All rights reserved.
//

#import "YHToyDown.h"

@implementation YHToyDown

+(id)toyDown
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
    YHToyDown *toyDown = [YHToyDown spriteNodeWithTexture:temp];
    toyDown.name = @"toyDown";
    [toyDown runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_toyWalkingFrames
                                                                  timePerFrame:0.2f
                                                                        resize:NO
                                                                       restore:YES]]withKey:@"walkingInPlaceToy"];
    toyDown.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:toyDown.size];//一人の騎兵隊に重力をつける
    return toyDown;

}

-(void)walkingToy
{
    SKAction *actionMove = [SKAction moveToX:-350 duration:20];
    SKAction * actiomMoveDone = [SKAction removeFromParent];
    [self runAction:[SKAction sequence:@[actionMove , actiomMoveDone]]];
    
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
