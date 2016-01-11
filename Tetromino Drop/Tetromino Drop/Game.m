//
//  Game.m
//  Tetromino Drop
//
//  Created by ajha17 on 1/7/16.
//  Copyright © 2016 assisstion. All rights reserved.
//

#import "Game.h"

@implementation Game

-(instancetype)init{
    self = [super init];
    if(self){
        self.board = [[Gameboard alloc] init];
    }
    return self;
}

-(void)start{
    
}
-(void)pauseOrResume{
    
}
@end
