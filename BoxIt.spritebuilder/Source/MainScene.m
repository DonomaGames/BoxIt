//
//  MainScene.h
//  BoxIt
//
//  Created by Wally Chang on 9/13/15.
//  Copyright (c) 2015 Donoma Games. All rights reserved.
//


#import "MainScene.h"
#import "GameOverScene.h"
#import "GameSingleton.h"

//------------------------CONSTANT----------------
#define ARC4RANDOM_MAX              0x100000000
//------------------------------------------------


@implementation MainScene
{
    CCPhysicsNode *_physicsNode;
    CCNodeColor *_circle;
    CCNodeColor *_bottomBar;
    CCLabelTTF *_counterLabel;
    
    CCNode *_endGameSensor;
    CCNode *_scoreSensor;
    
    
    int score;
    int scoreSensorCounter;
}

-(void) didLoadFromCCB
{
//    _physicsNode.debugDraw = YES;
    score = 0;
    
    _bottomBar.visible = NO;
    _bottomBar.physicsBody.sensor = YES;
    _bottomBar.physicsBody.collisionType = @"bar";
    
    _circle.physicsBody.collisionType = @"circle";
    
    self.userInteractionEnabled = YES;
    _physicsNode.collisionDelegate = self;
    
    _endGameSensor.physicsBody.sensor = YES;
    _endGameSensor.physicsBody.collisionType = @"endgame";
    
    _scoreSensor.physicsBody.sensor = YES;
    _scoreSensor.physicsBody.collisionType = @"scoreSensor";
    
    scoreSensorCounter = 0;
    
}

-(void) onEnter
{
    [super onEnter];
    
    int randomValue = [self getRandomIntFrom:-300 maxValue:300];
    
    while (randomValue > -50 && randomValue < 50)
        randomValue = [self getRandomIntFrom:-300 maxValue:300];
    
    [_circle.physicsBody applyImpulse:ccp(randomValue, 250)];
}


-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    _bottomBar.visible = YES;
    _bottomBar.physicsBody.sensor = NO;
    
    CCActionCallBlock *block = [CCActionCallBlock actionWithBlock:^{
        _bottomBar.physicsBody.sensor = YES;
        _bottomBar.visible = NO;
    }];
    
    //start timer
    [self stopAllActions];
    [self runAction:[CCActionSequence actions:
                     [CCActionDelay actionWithDuration:.2],
                     block,
                     nil]];
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair circle:(CCNode *)circle bar:(CCNode *)bar
{
    [circle.physicsBody applyImpulse:ccp(0, -100)];
    
    return YES;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair circle:(CCNode *)circle wall:(CCNode *)wall
{

    [_circle runAction:[CCActionSequence actions:
                        [CCActionScaleTo actionWithDuration:.2 scale:1.1],
                        [CCActionScaleTo actionWithDuration:.2 scale:1],
                        nil]];

    
    return YES;
}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair circle:(CCNode *)circle scoreSensor:(CCNode *)scoreSensor
{
    scoreSensorCounter++;
    
    if (scoreSensorCounter % 2 == 1 && scoreSensorCounter != 1) {
        score++;
        [_counterLabel setString:[NSString stringWithFormat:@"%d", score]];
        
        [_counterLabel runAction:[CCActionSequence actions:
                                  [CCActionScaleTo actionWithDuration:.2 scale:1.1],
                                  [CCActionScaleTo actionWithDuration:.2 scale:1],
                                  nil]];
    }
    
    return YES;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair circle:(CCNode *)circle endgame:(CCNode *)endgame
{
    [GameSingleton sharedInstance].currentScore = score;
    
    CCScene *scene = [CCBReader loadAsScene:@"GameOverScene"];
    
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionFadeWithDuration:.5]];
    
    return YES;
}

-(int) getRandomIntFrom:(int)minValue maxValue:(int)maxValue
{
    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
    int range = maxValue - minValue;
    int randomInt = (random * range) + minValue;
    
    return randomInt;
}

@end
