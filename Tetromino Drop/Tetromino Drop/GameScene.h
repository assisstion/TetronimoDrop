//
//  GameScene.h
//  Tetromino Drop
//

//  Copyright (c) 2016 assisstion. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Game.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface GameScene : SKScene <UIGestureRecognizerDelegate>
@property UIRotationGestureRecognizer* rotationGR;
@property SKSpriteNode *gameOverBox;
@property SKSpriteNode *gamePausedBox;
@property SKLabelNode *scoreLabel;
@property SKLabelNode *blocksPlacedLabel;
@property SKLabelNode *holdLabel;
@property SKLabelNode *queueLabel;
@property Game * game;
@property NSMutableArray <NSMutableArray <SKShapeNode *> *> * sprites;
@property (nonatomic, strong) AVAudioPlayer * player;
@property AVAudioPlayer * backgroundMusic;
@property NSArray <SKShapeNode *> * hold;
@property NSArray <NSArray<SKShapeNode *> *> * queue;

@end
