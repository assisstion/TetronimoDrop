//
//  Block.h
//  Tetromino Drop
//
//  Created by ajha17 on 1/7/16.
//  Copyright © 2016 assisstion. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Gameboard;

@interface Block : NSObject

@property int x;
@property int y;
@property int type;
@property int orientation;
@property Gameboard* gameboard;
-(void)rotateLeft;
-(void)rotateRight;
-(void)instantDrop;//(replace Ghost)
-(void)moveLeft;
-(void)moveRight;
+(Block *)randomBlock: (Gameboard*) gameboard;
-(instancetype)initFromBlock: (Block*) otherBlock;
-(void)blockChanged;
@end
