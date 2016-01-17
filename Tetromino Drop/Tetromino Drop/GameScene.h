//
//  GameScene.h
//  Tetromino Drop
//

//  Copyright (c) 2016 assisstion. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Game.h"

@interface GameScene : SKScene <UIGestureRecognizerDelegate>
@property UIRotationGestureRecognizer* rotationGR;
@property SKSpriteNode *gameOverBox;
@property SKSpriteNode *gamePausedBox;
@property SKLabelNode *scoreLabel;
@property SKLabelNode *blocksPlacedLabel;
@property Game * game;
@property NSMutableArray <NSMutableArray <SKShapeNode *> *> * sprites;

@end
