//
//  GameScene.h
//  Tetromino Drop
//

//  Copyright (c) 2016 assisstion. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Game.h"

@interface GameScene : SKScene

@property Game * game;
@property NSMutableArray <NSMutableArray <SKSpriteNode *> *> * sprites;

@end