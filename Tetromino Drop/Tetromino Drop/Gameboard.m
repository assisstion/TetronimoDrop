//
//  Gameboard.m
//  Tetromino Drop
//
//  Created by ajha17 on 1/7/16.
//  Copyright © 2016 assisstion. All rights reserved.
//

#import "Gameboard.h"
#import "Block.h"
#import "BlockData.h"

@implementation Gameboard{
    bool justUpdated;
}
static const int rows = 20;
static const int columns = 10;
static const int queuelength = 3;
-(instancetype) init
{
    self = [super init];
    if (self)
    {
        self.currentBlock = [self getNextBlock];
        self.ghost = [[Block alloc] initFromBlock:self.currentBlock];
        self.ghost.y = [self findGhost];
        self.hold = nil;
        self.queue = [[NSMutableArray alloc] init];
        for (int i =0; i<queuelength; i++)
        {
            [self.queue addObject:[self getNextBlock]];
        }
        self.array = [[NSMutableArray alloc] init];
        for (int i =0; i<rows; i++)
        {
            [self.array addObject:[Gameboard emptyRow]];
        }
        self.rowsCleared = 0;
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
        self.hold = self.currentBlock;
        [self nextBlock];
        
    }
    else
    {
        Block* repeatCurrentBlock = self.currentBlock;
        self.currentBlock = self.hold;
        self.hold = repeatCurrentBlock;
    }
    self.holdUsed = true;
}
-(void) nextBlock
{
    self.currentBlock = [self.queue objectAtIndex:0];
    [self.queue removeObjectAtIndex:0];
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
        self.currentBlock = [self.queue objectAtIndex:0];
        [self.currentBlock blockChanged];
        if(![self checkBlock:self.currentBlock]){
            self.gameOver = true;
            self.ghost = nil;
            self.currentBlock = nil;
            return;
        }
        [self.queue removeObjectAtIndex:0];
        [self.queue addObject:[self getNextBlock]];
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
-(Block *)getNextBlock{
    Block * newBlock= [Block randomBlock:self];
    newBlock.x = columns / 2;
    while (![self onScreen:newBlock])
    {
        newBlock.y++;
    }
    return newBlock;
}


@end
