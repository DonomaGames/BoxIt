//
//  GameSingleton.m
//  BoxIt
//
//  Created by Wally Chang on 9/13/15.
//  Copyright (c) 2015 Donoma Games. All rights reserved.
//

#import "GameSingleton.h"

@implementation GameSingleton
{
    int _currentScore;
    int _highScore;
}


GameSingleton *_sharedInstance = nil;

+ (GameSingleton *) sharedInstance {
    
    @synchronized([GameSingleton class])
    {
        if (!_sharedInstance)
            _sharedInstance = [[self alloc] init];
        
        return _sharedInstance;
    }
    // to avoid compiler warning
    return nil;
}

+(id)alloc
{
    @synchronized([GameSingleton class])
    {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    // to avoid compiler warning
    return nil;
}


-(id)init
{
    if( (self=[super init])) {
        [self loadDataFromDisk];
    }
    return self;
}


- (void) loadDataFromDisk {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _highScore = ((NSNumber *)[userDefaults objectForKey:@"highScore"]).intValue;
}

- (void) saveDataToDisk {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInt:_highScore] forKey:@"highScore"];
}

-(int)currentScore
{
    return _currentScore;
}

-(void) setCurrentScore:(int)currentScoreLocal
{
    _currentScore = currentScoreLocal;
    
    if (_currentScore > _highScore) {
        _highScore = _currentScore;
        
        [self saveDataToDisk];
    }
    
}

@end
