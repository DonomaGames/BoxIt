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

    //the collision type set here will determine which callback is called
    _bottomBar.physicsBody.collisionType = @"bar";
    
    _circle.physicsBody.collisionType = @"circle";
    
    self.userInteractionEnabled = YES;
    
    //must set the delegate so when there is physics collision, this class is called.
    _physicsNode.collisionDelegate = self;
    
    //setting sensor to YES means only detect collision but do not cause bounces
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
    
    //Do not want the ball to go straight and updown
    while (randomValue > -50 && randomValue < 50)
        randomValue = [self getRandomIntFrom:-300 maxValue:300];
    
    //Give the ball an initial push
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
    
    //start timer - after .2 seconds, the bar will disappear and allow ball to go through
    [self stopAllActions];
    [self runAction:[CCActionSequence actions:
                     [CCActionDelay actionWithDuration:.2],
                     block,
                     nil]];
}

//detect bounce off the the bottom bar
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
