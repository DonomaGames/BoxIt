//
//  GameSingleton.h
//  BoxIt
//
//  Created by Wally Chang on 9/13/15.
//  Copyright (c) 2015 Donoma Games. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSingleton : NSObject

@property (readwrite) int currentScore;
@property (readonly) int highScore;

+ (GameSingleton*) sharedInstance;


@end
