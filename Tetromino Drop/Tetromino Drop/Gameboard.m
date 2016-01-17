//
//  Gameboard.m
//  Tetromino Drop
//
//  Created by ajha17 on 1/7/16.
//  Copyright © 2016 assisstion. All rights reserved.

// Set up methods to check whether the block is on the board, whether the block is touching another block, initialize the gameboard, and be able to delete and create rows on the gameboard.

#import "Gameboard.h"
#import "Block.h"
#import "BlockData.h"

@implementation Gameboard{
    bool justUpdated;
}
static const int rows = 20;
static const int columns = 10;
-(instancetype) init
{
    self = [super init];
    if (self)
    {
        self.queueLength = 3;
        self.holdUsed = false;
        self.currentBlock = [Block randomBlock:self];
        [self resetBlockPosition];
        self.ghost = [[Block alloc] initFromBlock:self.currentBlock];
        self.ghost.y = [self findGhost];
        self.hold = nil;
        self.queue = [[NSMutableArray alloc] init];
        for (int i =0; i<self.queueLength; i++)
        {
            [self.queue addObject:[Block randomBlock:self]];
        }
        self.array = [[NSMutableArray alloc] init];
        for (int i =0; i<rows; i++)
        {
            [self.array addObject:[Gameboard emptyRow]];
        }
        self.rowsCleared = 0;
        self.blocksPlaced = 0;
    }
    return self;
    
}

+(NSMutableArray *) emptyRow
{
    NSMutableArray * row = [[NSMutableArray alloc] init];
    for (int i =0;i <columns; i++)
    {
        [row addObject:[[NSNumber alloc] initWithBool:false]];
    }
    return row;
}
-(void)deleteRows
{
    for (int i = 0; i< [self.array count]; i++)
    {
        if([Gameboard isEmpty:[self.array objectAtIndex:i]])
        {
            [self.array removeObjectAtIndex:i];
            [self.array insertObject:[Gameboard emptyRow] atIndex:0];
            i--;
            self.rowsCleared++;
        }
    }

    
}

+(bool) isEmpty:(NSArray *) row
{
    for (int i = 0; i< [row count]; i++)
    {
        if (![[row objectAtIndex:i] boolValue]){
            return false;
        }
    }
    return true;
}

-(void)holdBlock
{
    
    if (self.holdUsed)
    {
        return;
    }
    if (self.hold == nil)
    {
        self.blocksPlaced -= 4;
        self.hold = self.currentBlock;
        [self getBlockFromQueue];
    }
    else if(self.hold.type == self.currentBlock.type){
        return;
    }
    else {
        Block* repeatCurrentBlock = self.currentBlock;
        self.currentBlock = self.hold;
        [self resetBlockPosition];
        self.hold = repeatCurrentBlock;
    }
    self.holdUsed = true;
}
-(void) getBlockFromQueue
{
    self.currentBlock = [self.queue objectAtIndex:0];
    [self.queue removeObjectAtIndex:0];
    [self.queue addObject:[Block randomBlock:self]];
    self.blocksPlaced += 4;
    [self resetBlockPosition];
}
-(void)resetBlockPosition{
    self.currentBlock.x = columns / 2;
    self.currentBlock.y = 0;
    self.currentBlock.orientation = 0;
    while (![self onScreen:self.currentBlock])
    {
        self.currentBlock.y++;
    }
    [self.currentBlock blockChanged];
    if(![self checkBlock:self.currentBlock]){
        self.gameOver = true;
        self.ghost = nil;
        self.currentBlock = nil;
        return;
    }
}

- (int) findGhost
{
    Block * ghost = [[Block alloc] initFromBlock:self.currentBlock];
    ghost.y = self.currentBlock.y;
    while([self checkBlock:ghost]){
        ghost.y++;
    }
    ghost.y--;
    return ghost.y;
}

-(BOOL) checkBlock: (Block*) block
{
    BlockData * data = [BlockData getDataFromBlock:block];
    for(Coordinate * coord in data.coordinates){
        if (coord.y < 0 || coord.y >= rows || coord.x < 0 || coord.x >= columns)
        {
            return false;
        }
        if([[[self.array objectAtIndex:coord.y] objectAtIndex:coord.x] boolValue] == true){
            return false;
        }
    }
    return true;
}

-(BOOL) onScreen: (Block *) block
{
    BlockData * data = [BlockData getDataFromBlock:block];
    for(Coordinate * coord in data.coordinates){
        if (coord.y < 0 || coord.y >= rows || coord.x < 0 || coord.x >= columns)
        {
            return false;
        }
    }
    return true;
}

-(void)update
{
    if(self.gameOver){
        return;
    }
    self.ghost.y = [self findGhost];
    if(self.currentBlock.y == self.ghost.y){
        [self permanent];
        [self getBlockFromQueue];
        self.holdUsed = false;
    }
    else{
        self.currentBlock.y++;
    }
    [self deleteRows];
    justUpdated = true;
}

-(bool)justUpdated{
    bool just = justUpdated;
    justUpdated = false;
    return just;
}
-(void)permanent{
    BlockData * data = [BlockData getDataFromBlock:self.currentBlock];
    for(Coordinate * coord in data.coordinates){
        [[self.array objectAtIndex:coord.y] replaceObjectAtIndex:coord.x withObject:[[NSNumber alloc] initWithBool:true]];
    }
}

@end
