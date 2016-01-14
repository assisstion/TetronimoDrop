//
//  Game.m
//  Tetromino Drop
//
//  Created by ajha17 on 1/7/16.
//  Copyright © 2016 assisstion. All rights reserved.
//

#import "Game.h"

@implementation Game{
    double previousTime;
    double ticks;
}

-(instancetype)init{
    self = [super init];
    return self;
}

-(void)start{
    self.board = [[Gameboard alloc] init];
    ticks = 0;
    previousTime = 0;
}
-(void)pauseOrResume{
    
}

-(void)update:(CFTimeInterval)currentTime{
    ticks += currentTime - previousTime;
    previousTime = currentTime;
    if(ticks > [self getTickInterval]){
        [self.board update];
    }
    if([self.board justUpdated]){
        ticks = 0;
    }
}

-(double)getTickInterval{
    return 1/log(0.1*self.board.rowsCleared+M_E);
}
@end
