//
//  Block.m
//   Drop
//
//  Created by ajha17 on 1/7/16.
//  Copyright © 2016 assisstion. All rights reserved.

// Create the methods for generating a random block and rotating, moving and instantly dropping a block. Also has a method when hold is called to reset the orientation of the ghost. 

#import "Block.h"
#import "Gameboard.h"

@implementation Block
-(instancetype) init
{
    self = [super init];
    if (self)
    {
        self.x =(int) [[self.gameboard.array objectAtIndex:0] count]/2;
        self.y = 0;
        self.type = 0;
        self.orientation = 0;
    }
    return self;
}
-(instancetype) initFromBlock: (Block*) otherBlock
{
    self = [super init];
    if (self)
    {
        self.x = otherBlock.x;
        self.y = otherBlock.y;
        self.type = otherBlock.type;
        self.orientation = otherBlock.orientation;
    }
    return self;
}
+(Block *)randomBlock: (Gameboard*) gameboard
{
    Block* newBlock = [[Block alloc] init];
    newBlock.type = arc4random_uniform(7);
    newBlock.gameboard = gameboard;
    return newBlock;

}

-(void)rotateLeft
{
    self.orientation --;
    if (self.orientation < 0)
    {
        self.orientation = 3;
    }
    if (![self.gameboard checkBlock:self])
    {
        self.orientation ++;
        if (self.orientation > 3)
        {
            self.orientation = 0;
        }
    }
    [self blockChanged];
}
-(void)rotateRight
{    self.orientation ++;
    
    if (self.orientation > 3)
    {
        self.orientation = 0;
    }
    if (![self.gameboard checkBlock:self])
    {
        self.orientation --;
        if (self.orientation < 0)
        {
            self.orientation = 3;
        }
    }
    [self blockChanged];
}
-(void)moveLeft
{
    self.x--;
    if (![self.gameboard checkBlock:self])
    {
        self.x ++;
    }
    
    [self blockChanged];
}
-(void)moveRight
{
    self.x++;
    if (![self.gameboard checkBlock:self])
    {
        self.x--;
    }
    [self blockChanged];
}
-(void)instantDrop
{
    self.y = self.gameboard.ghost.y;
    [self blockChanged];
    [self.gameboard update];
}


-(void)blockChanged{
    self.gameboard.ghost = [[Block alloc] initFromBlock:self];
    self.gameboard.ghost.y = [self.gameboard findGhost];
}

@end
