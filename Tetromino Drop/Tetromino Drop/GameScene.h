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
@property Game * game;
@property NSMutableArray <NSMutableArray <SKShapeNode *> *> * sprites;

@end
