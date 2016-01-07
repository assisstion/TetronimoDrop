//
//  Gameboard.h
//  Tetromino Drop
//
//  Created by ajha17 on 1/7/16.
//  Copyright © 2016 assisstion. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Block;
@interface Gameboard : NSObject

@property Block * currentBlock;
@property Block * ghost;
@property Block * hold;
@property bool holdUsed;
@property NSMutableArray <Block *> * queue;
@property NSMutableArray <NSMutableArray <NSNumber *> *> * array;
-(void)update; //makes block fall down one
-(void)deleteRows;
-(BOOL) checkBlock: (Block*) block;
-(void)holdBlock;
-(void) nextBlock;

@end
