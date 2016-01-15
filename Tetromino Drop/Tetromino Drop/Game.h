//
//  Game.h
//  Tetromino Drop
//
//  Created by ajha17 on 1/7/16.
//  Copyright © 2016 assisstion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gameboard.h"

@interface Game : NSObject
@property int score;
@property bool paused;
@property Gameboard * board;
-(void)start;
-(void)pauseOrResume;
-(void)update:(CFTimeInterval)timeInterval;
@end
