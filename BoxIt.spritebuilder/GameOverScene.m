//
//  GameOverScene.m
//  BoxIt
//
//  Created by Wally Chang on 9/13/15.
//  Copyright (c) 2015 Donoma Games. All rights reserved.
//

#import "GameOverScene.h"
#import "GameSingleton.h"

@implementation GameOverScene
{
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_bestScoreLabel;
}

-(void) didLoadFromCCB
{
    [_scoreLabel setString:[NSString stringWithFormat:@"%d", [GameSingleton sharedInstance].currentScore]];
    [_bestScoreLabel setString:[NSString stringWithFormat:@"%d", [GameSingleton sharedInstance].highScore]];
}

-(void) replayButtonPressed
{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
