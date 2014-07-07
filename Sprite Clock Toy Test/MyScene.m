//
//  MyScene.m
//  Sprite Clock Toy Test
//
//  Created by YANAGIDA on 2014/06/19.
//  Copyright (c) 2014年 YANAGIDA. All rights reserved.
//

#import "MyScene.h"

#import "YHToy.h"
#import "YHToyQueue.h"
#import "YHLondonbus.h"
#import "YHToyDown.h"

#define TOY_WALKING_POSITION self.frame.size.height/3 //toyが出てくるy軸の位置
#define TOY_WALKING_POSITION_W self.frame.size.width/2

@interface MyScene()

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
//最後にtoyが産み出された時からの時間を把握する為にlastSpawnTimeIntervalを使います。
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
//最後にアップデートされた時からの時間の把握にはlastUpdateTimeIntervalを使います。

@end



@implementation MyScene
{
    YHLondonbus *london_bus;
    YHToyQueue *toyQueue;
    
    SKSpriteNode *_tanshin;
    SKSpriteNode *_choushin;
    
    YHToy *toy;
    YHToyDown *toyDown;
    CGPoint _touchPoint;
    NSInteger animationHour;
    NSInteger animateMin;
    NSInteger animateSec;
    //    NSTimer *timerAnimation;
    int count;
}



-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.anchorPoint = CGPointMake(0.5, 0.5);
        //TODO: タイマーの作成（動作開始）
        [NSTimer scheduledTimerWithTimeInterval:1.0      // 時間間隔（秒）
                                         target:self          // 呼び出すオブジェクト
                                       selector:@selector(driveClock:) //呼び出すメソッド
                                       userInfo:nil         // ユーザ利用の情報オブジェクト
                                        repeats:YES];        // 繰り返し
    }
    
    [self addClockImages];
    [self createGround];
//    [self createLondonbus];
//    [self createToy];
    
    return self;
}


-(void)addClockImages
{
    /**
     *  時計のデザインをbackgroundとしてsceneにのせる
     */
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Group"];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    //background.position = CGPointZero;
    //background.anchorPoint = CGPointZero;
    [self addChild:background];
    
    //長針のイメージ
    _choushin = [SKSpriteNode spriteNodeWithImageNamed:@"LandscapeChoushin.png"];
    _choushin.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:_choushin];
    
    //短針のイメージ
    _tanshin = [SKSpriteNode spriteNodeWithImageNamed:@"LandscapeTanshin.png"];
    _tanshin.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:_tanshin];
    
    //センターポイントのイメージ
    SKSpriteNode *center = [SKSpriteNode spriteNodeWithImageNamed:@"LandscapeCenter.png"];
    center.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:center];
    
}

//TODO:タイマーから呼び出されるメソッド
-(void)driveClock:(NSTimer*)timer
{
    //タイマー動作時の処理
    //現在時刻を取得
    NSDate *today = [NSDate date];
    
    //現在時刻の時、分、秒を取得
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents * todayComponents = [calendar components:flags fromDate:today];
    
    NSInteger hour = [todayComponents hour];
    NSInteger min = [todayComponents minute];
    NSInteger sec = [todayComponents second];
    
    animationHour = hour % 12;
    animateMin = min;
    animateSec = sec;
    NSLog(@"%d", animationHour);
    NSLog(@"時間は%d", hour);
    NSLog(@"分は%d", min);
    //    NSLog(@"秒は%d", second);
    
    float fineHour = (hour % 12) + min / 60.0;
    NSLog(@"fineHourは%f", fineHour);
    
    //時針、分針、秒針の回転アクション
    SKAction *rotateTanshin = [SKAction rotateToAngle:M_PI * -2 * fineHour / 12.0 duration:0.1 shortestUnitArc:NO];
    [_tanshin runAction:rotateTanshin];
    
    SKAction *rotateChoushin = [SKAction rotateToAngle:M_PI * -2 * min / 60.0 duration:0.1 shortestUnitArc:YES];
    [_choushin runAction:rotateChoushin];
    
    [self setUpAnimation];
    
}

//時間によってアニメーションを使い分ける。タイマーから呼び出されるメソッド-(void)driveClock:(NSTimer*)timer
-(void)setUpAnimation
{
    NSLog(@"アニメーションです");
    switch (animationHour) {
        case 1:
        case 4:
        case 7:
        case 10:
            if (animateMin == 00) {
                [self createLondonbus];
            }
            break;
        case 2:
        case 5:
        case 8:
        case 11:
            if (animateMin == 00) {
                [self createToy];
            }
            break;
    }
}



//ロンドンバスをのせる
-(void)createLondonbus
{
    if (!london_bus) {
        london_bus = [YHLondonbus london_bus];
        london_bus.position = CGPointMake(self.frame.size.width/2 + london_bus.size.width/2, -TOY_WALKING_POSITION);
        london_bus.zPosition = 10;
        [self addChild:london_bus];
        
        [london_bus driveLondonbus];

    }
}

//連続の騎兵隊の行進 ,12,3,6,9時丁度に動作する。
-(void)createToyQueue
{
//    if (!toyQueue) {
//    }

    if (animationHour == 0 && animateMin == 00) {
        count+=1;
        NSLog(@"12時の回数は%d", count);
        if (count < 13 ) {
            toyQueue = [YHToyQueue toyQueue];
            //右端のチョットスクリーンから外れたところかにToyを設定
            toyQueue.position = CGPointMake(self.frame.size.width/2 + toyQueue.size.width/2, -TOY_WALKING_POSITION);
            
            [self addChild:toyQueue];
            [toyQueue walkingToy];
        }
    }else if (animationHour == 3 && animateMin == 00){
        count+=1;
        NSLog(@"3時の回数は%d", count);
        if (count < 4 ) {
            toyQueue = [YHToyQueue toyQueue];
            //右端のチョットスクリーンから外れたところかにToyを設定
            toyQueue.position = CGPointMake(self.frame.size.width/2 + toyQueue.size.width/2, -TOY_WALKING_POSITION);
            
            [self addChild:toyQueue];
            [toyQueue walkingToy];
        }
    }else if (animationHour == 6 && animateMin == 00){
        count+=1;
        NSLog(@"6時の回数は%d", count);
        if (count < 7 ) {
            toyQueue = [YHToyQueue toyQueue];
            //右端のチョットスクリーンから外れたところかにToyを設定
            toyQueue.position = CGPointMake(self.frame.size.width/2 + toyQueue.size.width/2, -TOY_WALKING_POSITION);
            
            [self addChild:toyQueue];
            [toyQueue walkingToy];
        }
    }else if (animationHour == 9 && animateMin == 00){
        count+=1;
        NSLog(@"9時の回数は%d", count);
        if (count < 10 ) {
            toyQueue = [YHToyQueue toyQueue];
            //右端のチョットスクリーンから外れたところかにToyを設定
            toyQueue.position = CGPointMake(self.frame.size.width/2 + toyQueue.size.width/2, -TOY_WALKING_POSITION);
            
            [self addChild:toyQueue];
            [toyQueue walkingToy];
        }
    }
}


//ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

//次に最後のアップデートからの時間毎のフレームをコールするメソッドを追加します。このメソッドはデフォルトではコールされないので、このメソッドをコールする為の別のメソッドを用意します。
/**
 *  ここではlastSpawnTimeIntervalに最後のアップデートが実行されてからの時間が追加されています。3秒を越えるとtoyQueueを生成して時間をリセットします。
 */

- (void) updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSiceLast
{
    self.lastSpawnTimeInterval += timeSiceLast;
    if (self.lastSpawnTimeInterval > 3 ) {
        self.lastSpawnTimeInterval = 0;

        [self createToyQueue];
    }
}
//

//
////以下のメソッドを追加して上記のメソッドをコールします:
-(void)update:(CFTimeInterval)currentTime
{
   
    //もし60fpsに落ちても常に同じディスタンスで動くようにする
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) {
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    [self updateWithTimeSinceLastUpdate:timeSinceLast];

}


// ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
//一人の騎兵隊

-(void)createToy
{
    if (!toy) {
        toy = [YHToy toy];
        toy.position = CGPointMake(TOY_WALKING_POSITION_W, -self.frame.size.height/3 );
        [self addChild:toy];
        
        [toy walkingToy];

    }
}

-(void)createGround
{
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(self.frame.size.width+60, 5)];
    ground.position = CGPointMake(0, -self.frame.size.height/3 - 70 );
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
    ground.physicsBody.dynamic = NO;
    
    [self addChild:ground];
}
// ーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
//一人の騎兵隊で6にぶつかってこける。
-(void)createToyDown
{
    if (!toyDown) {
        toyDown = [YHToyDown toyDown];
        toyDown.position = CGPointMake(TOY_WALKING_POSITION_W, -self.frame.size.height/3);
        [self addChild:toyDown];
        
        [toyDown walkingToy];
    }
}


// ーーーーーーーーーーーーーーーーーーーーーーーーーーーーー


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //画面をタップして操作
    UITouch *touch = [touches anyObject];
    _touchPoint = [touch locationInNode:self];
    NSInteger tapNum = [touch tapCount];
    
    if (tapNum == 1) {
        [toy jump];
    }
    
}

@end
