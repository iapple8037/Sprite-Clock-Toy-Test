//
//  YHToyQueue.m
//  Toy Test2
//
//  Created by YANAGIDA on 2014/06/16.
//  Copyright (c) 2014年 YANAGIDA. All rights reserved.
//

#import "YHToyQueue.h"

#define TOY_WALKING_POSITION self.frame.size.height/3 //toyが出てくるy軸の位置
#define TOY_WALKING_POSITION_W self.frame.size.width/2


@implementation YHToyQueue

+(id)toyQueue
{
 
    //TODO
    /**
     *  1)アニメーションの歩く(walking)フレームを格納する為のArrayの設定
     */
    NSMutableArray *walkFrames = [NSMutableArray array];
    
    /**
     *  2)テクスチャアトラスの読み込みと設定 application bundleのデータからアトラスを作成。Sprite Kitは実機の解像度を基準に自動的に最適なファイルを設定してくれます。例えばRetinaのiPadならBearImages@2x~ipad.pngが自動的に設定されます。
     */
    SKTextureAtlas *toyAnimatedAtlas = [SKTextureAtlas atlasNamed:@"ToyImages"];
    
    /**
     *  3)フレームのリストをまとめる。 イメージ名をループさせる事でフレームのリストを作成し、テクスチャアトラス内のそれぞれのイメージ名から適切なスプライトを探し出します。ここでnumImages変数が２で割られていますね、何故でしょうか？ テクスチャアトラスには全ての解像度(Retina用とNon-Retina用)のイメージが入っているからです。この場合ならファイルに入っている全てのテクスチャの数は16。２種類の解像度用それぞれに8枚づつとなります。Sprite Kitは自動的に最適な解像度を選択してくれるので、どちらか一方だけを選択すれば良い事になります。その上で８枚のイメージの中からイメージ名とカウンターで付けられた番号をもとに適切なイメージを引き出し使用します。
     */
    int numImages = toyAnimatedAtlas.textureNames.count;
    for (int i = 1; i <= numImages/2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"toy_%d", i];
        SKTexture *temp = [toyAnimatedAtlas  textureNamed:textureName];
        [walkFrames addObject:temp];
        }
    _toyWalkingFrames = walkFrames;
    
    
    /**
    *  4)スプライトを作成し、ポジションをスクリーンに設定し、シーンに追加します
    */
    SKTexture *temp = _toyWalkingFrames[0];
    YHToyQueue *toyQueue = [YHToyQueue spriteNodeWithTexture:temp];
    toyQueue.name = @"toyQueue";
    
    
    /**
     *  5 Toyを歩かせる為の新しいメソッドをinitWithSizeメソッドの下に追加。このアクションはフレームとフレームの間隔を0.1秒に設定してアニメーションさせます。”walkingInPlaceToy”キーは、アニメーションを再起動する為に再度このメソッドを呼び出す必要がある場合はアニメーションが強制的に削除されるようにします。これは互いにアニメーションが干渉しないようにする為に後ほど必要となります。withKey引数は、アニメーションが名前によって実行されているかどうかを確認する事が出来ます。
     repeatアクションは設定された何らかのアクションを繰り返し実行する為のもので、animateWithTexturesに設定した配列内の順序でテクスチャアトラスのテクスチャを通してインナーアクションのアニメーションを実行します。
     */
    [toyQueue runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_toyWalkingFrames
                                                                       timePerFrame:0.1f
                                                                             resize:NO
                                                                            restore:YES]]withKey:@"walkingInplaceToy"];
    
    
    
    return toyQueue;
}

-(void)walkingToy
{
    /**
     *  toyの前進して行く動きのメソッド
     */
    SKAction *actionDelay = [SKAction waitForDuration:2.0];//まずアクションを起こすタイミングを計る
    SKAction *actionMove = [SKAction moveTo:CGPointMake(-350, self.position.y) duration:25];

    SKAction * actiomMoveDone = [SKAction removeFromParent];

    [self runAction:[SKAction sequence:@[actionDelay , actionMove , actiomMoveDone]]];
}



-(void)stopWalkingToy//walkingToyのsctionMoveアクションを止める。
{
    [self removeActionForKey:@"walkingToy"];
}

-(void)jump
{
    [self.physicsBody applyImpulse:CGVectorMake(0, 40)];
}


@end
