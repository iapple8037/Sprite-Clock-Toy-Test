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
    CGPoint _touchPoint;
    NSInteger animationHour;
    //    NSTimer *timerAnimation;
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
        //------------------------------------------------------------------------
        
        
        
        [self addClockImages];
        [self createLondonbus];
        [self createToyQueue];
        [self createToy];
        [self createGround];
    }
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
    //    NSInteger second = [todayComponents second];
    
    animationHour = min;
    NSLog(@"時間は%d", hour);
    NSLog(@"分は%d", min);
    //    NSLog(@"秒は%d", second);
    
    float fineHour = (hour % 12) + min / 60.0;
    NSLog(@"fineHourは%f", fineHour);
    
    //時針、分針、秒針の回転アクション
    SKAction *rotateTanshin = [SKAction rotateToAngle:M_PI * -2 * fineHour / 12.0 duration:0.1 shortestUnitArc:NO];
    [_tanshin runAction:rotateTanshin];
    
    SKAction *rotateChoushin = [SKAction rotateToAngle:M_PI * -2 * min / 60.0 duration:0.1 shortestUnitArc:NO];
    [_choushin runAction:rotateChoushin];
    
}



//ロンドンバスをのせる
-(void)createLondonbus
{
    london_bus = [YHLondonbus london_bus];
    london_bus.position = CGPointMake(self.frame.size.width/2 + london_bus.size.width/2, -TOY_WALKING_POSITION);
    london_bus.zPosition = 10;
    [self addChild:london_bus];
    
    [london_bus driveLondonbus];
}

//連続の騎兵隊の行進
-(void)createToyQueue
{
    toyQueue = [YHToyQueue toyQueue];
    //右端のチョットスクリーンから外れたところかにToyを設定
    toyQueue.position = CGPointMake(self.frame.size.width/2 + toyQueue.size.width/2, -TOY_WALKING_POSITION);
    
    [self addChild:toyQueue];
    
    [toyQueue walkingToy];
    
}


//ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

//次に最後のアップデートからの時間毎のフレームをコールするメソッドを追加します。このメソッドはデフォルトではコールされないので、このメソッドをコールする為の別のメソッドを用意します。
/**
 *  ここではlastSpawnTimeIntervalに最後のアップデートが実行されてからの時間が追加されています。１秒を越えるとtoyを生成して時間をリセットします。
 */

- (void) updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSiceLast
{
    self.lastSpawnTimeInterval += timeSiceLast;
    if (self.lastSpawnTimeInterval > 4) {
        self.lastSpawnTimeInterval = 0;
        //        if (animationHour == 12) {
        //            [self createToyQueue];
        //        }
        [self createToyQueue];
    }
}


//以下のメソッドを追加して上記のメソッドをコールします:
//- (void)update:(NSTimeInterval)currentTime
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


// ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー　一人の騎兵隊
-(void)createToy
{
    toy = [YHToy toy];
    toy.position = CGPointMake(self.frame.size.width/2, -TOY_WALKING_POSITION);
    [self addChild:toy];
    
    [toy walkingToy];
}

-(void)createGround
{
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(self.frame.size.width, 5)];
    //    ground.position = CGPointMake(self.frame.size.width/2, TOY_WALKING_POSITION - toy.size.height/2);
    ground.position = CGPointMake(0, -TOY_WALKING_POSITION - toy.size.height/2);
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
    ground.physicsBody.dynamic = NO;
    
    [self addChild:ground];
}

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
