//
//  Block.m
//   Drop
//
//  Created by ajha17 on 1/7/16.
//  Copyright © 2016 assisstion. All rights reserved.
//

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
        self.x =otherBlock.x;
        self.y = otherBlock.y;
        self.type = otherBlock.type;
        self.orientation = otherBlock.orientation;
    }
    return self;
}
+(Block *)randomBlock: (Gameboard*) gameboard
{
    Block* newBlock = [[Block alloc] init];
    newBlock.type = 2;
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
}
-(void)rotateRight
{    self.orientation ++;
    
    if (self.orientation > 3)
    {
        self.orientation = 0;
    }

}
-(void)moveLeft
{
    self.x--;
    if (![self.gameboard checkBlock:self])
    {
        self.x ++;
    }
    
    
}
-(void)moveRight
{
    self.x++;
    if (![self.gameboard checkBlock:self])
    {
        self.x--;
    }
    
}
-(void)instantDrop
{
    self.y = self.gameboard.ghost.y;
    
}



@end
