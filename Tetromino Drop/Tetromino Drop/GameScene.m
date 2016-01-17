//
//  GameScene.m
//  Tetromino Drop
//
//  Created by ajha17 on 1/5/16.
//  Copyright (c) 2016 assisstion. All rights reserved.
//

#import "Gameboard.h"
#import "GameScene.h"
#import "Coordinate.h"
#import "BlockData.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@implementation GameScene

const int spriteWidth = 32;
const int spriteHeight = 32;
const double offset = 1.5;

-(void)didMoveToView:(SKView *)view {
    
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    UISwipeGestureRecognizer* swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    UILongPressGestureRecognizer *longPressGesture= [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    UISwipeGestureRecognizer* swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:
                                                @selector(handleSwipeUp:)];
    longPressGesture.minimumPressDuration = 1.0; //seconds
    longPressGesture.delegate = self;
    [swipeRightGesture setDirection: UISwipeGestureRecognizerDirectionRight];
    [swipeLeftGesture setDirection: UISwipeGestureRecognizerDirectionLeft];
    [swipeDownGesture setDirection: UISwipeGestureRecognizerDirectionDown];
    [swipeUpGesture setDirection: UISwipeGestureRecognizerDirectionUp];
    [view addGestureRecognizer: swipeRightGesture];
    [view addGestureRecognizer: swipeLeftGesture];
    [view addGestureRecognizer: swipeDownGesture];
    [view addGestureRecognizer: swipeUpGesture];
    [view addGestureRecognizer: tapGesture];
    [view addGestureRecognizer:longPressGesture];
    
    
    SKLabelNode * myLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
    myLabel.text = @"Game Over! Tap to Restart.";
    myLabel.fontColor = [UIColor redColor];
    myLabel.fontSize = 32;
    myLabel.position = CGPointMake(0, -myLabel.frame.size.height/2);
    
    self.gameOverBox = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0 green:0 blue:0 alpha:1] size:CGSizeMake(myLabel.frame.size.width, myLabel.frame.size.height)];
    self.gameOverBox.colorBlendFactor = 1;
    self.gameOverBox.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame));
    
    SKLabelNode * myLabel2 = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
    myLabel2.text = @"Game Paused. Long Tap to Resume.";
    myLabel2.fontColor = [UIColor redColor];
    myLabel2.fontSize = 24;
    myLabel2.position = CGPointMake(0, -myLabel2.frame.size.height/2);
    
    self.gamePausedBox = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0 green:0 blue:0 alpha:1] size:CGSizeMake(myLabel2.frame.size.width, myLabel2.frame.size.height)];
    self.gamePausedBox.colorBlendFactor = 1;
    self.gamePausedBox.position = CGPointMake(CGRectGetMidX(self.frame),
                                            CGRectGetMidY(self.frame));
    
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
    self.scoreLabel.text = @"Rows Cleared:";
    self.scoreLabel.fontColor = [UIColor blueColor];
    self.scoreLabel.fontSize = 24;
    self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMidY(self.frame) - self.frame.size.height / 2 + 30);
    
    
    self.blocksPlacedLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
    self.blocksPlacedLabel.text = @"Blocks Placed:";
    self.blocksPlacedLabel.fontColor = [UIColor blueColor];
    self.blocksPlacedLabel.fontSize = 24;
    self.blocksPlacedLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMidY(self.frame) - self.frame.size.height / 2 + 50);
    
    self.holdLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
    self.holdLabel.text = @"Hold:";
    self.holdLabel.fontColor = [UIColor blueColor];
    self.holdLabel.fontSize = 24;
    self.holdLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 165,
                                                  CGRectGetMidY(self.frame) + 335);
    
    self.queueLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
    self.queueLabel.text = @"Queue:";
    self.queueLabel.fontColor = [UIColor blueColor];
    self.queueLabel.fontSize = 24;
    self.queueLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 165,
                                          CGRectGetMidY(self.frame)  + 200);
    self.sprites = [[NSMutableArray alloc] init];
    self.game = [[Game alloc] init];
    [self.game start];
    [self setupBoard];
    
    [self.gamePausedBox addChild:myLabel2];
    [self addChild:self.gamePausedBox];
    
    [self.gameOverBox addChild:myLabel];
    [self addChild:self.gameOverBox];
    
    [self addChild:self.scoreLabel];
    [self addChild:self.blocksPlacedLabel];
    [self addChild:self.holdLabel];
    [self addChild:self.queueLabel];
    
    NSURL *musicFile = [[NSBundle mainBundle] URLForResource:@"tetris"
                                               withExtension:@"mp3"];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile
                                                                  error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic play];
    
    self.hold = [GameScene newTetromino];
    
    for(SKShapeNode * shape in self.hold){
        shape.hidden = true;
        shape.fillColor = [SKColor blueColor];
        [self addChild:shape];
    }
    
    NSMutableArray * mut = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.game.board.queueLength; i++){
        [mut addObject:[GameScene newTetromino]];
    }
    self.queue = [[NSArray alloc] initWithArray:mut];
    for(NSArray<SKShapeNode *> * tetromino in self.queue){
        for(SKShapeNode * shape in tetromino){
            shape.hidden = true;
            shape.fillColor = [SKColor blueColor];
            [self addChild:shape];
        }
    }
}

+(SKShapeNode *)newShape{
    return [SKShapeNode shapeNodeWithRectOfSize: CGSizeMake(spriteWidth/offset, spriteHeight/offset)];
}

+(NSArray<SKShapeNode *> *)newTetromino{
    return @[[GameScene newShape], [GameScene newShape], [GameScene newShape], [GameScene newShape]];
}

-(void) handleSwipeRight:(UISwipeGestureRecognizer *) recognizer{
    if (self.game.paused){
        return;
    }
    [self.game.board.currentBlock moveRight];
}

-(void) handleSwipeLeft:(UISwipeGestureRecognizer *) recognizer{
    if (self.game.paused){
        return;
    }
    [self.game.board.currentBlock moveLeft];
}

-(void) handleSwipeDown:(UISwipeGestureRecognizer *) recognizer{
    if (self.game.paused){
        return;
    }
    [self.game.board.currentBlock instantDrop];
}
-(void) handleSwipeUp:(UISwipeGestureRecognizer *) recognizer{
    if (self.game.paused){
        return;
    }
    [self.game.board holdBlock];
}

-(void) handleTap:(UITapGestureRecognizer *) recognizer{
    if(self.game.board.gameOver)
    {
        self.backgroundMusic.currentTime = 0;
        [self.game start];
    }
    if (self.game.paused){
        return;
    }
    [self.game.board.currentBlock rotateRight];
}
-(void) handleLongPress:(UILongPressGestureRecognizer *) recognizer{
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
    [self.game pauseOrResume];
    }
}

-(void)setupBoard{
    int w = (int)[self.game.board.array count];
    for(int i = 0; i < w; i++){
        NSArray * row = [self.game.board.array objectAtIndex:i];
        NSMutableArray * mut = [[NSMutableArray alloc] init];
        [self.sprites addObject:mut];
        int h = (int)[row count];
        for(int j = 0; j < h; j++){
            SKShapeNode * shape = [SKShapeNode shapeNodeWithRectOfSize: CGSizeMake(spriteWidth, spriteHeight)];
            shape.fillColor = [SKColor blueColor];
            shape.position = CGPointMake(CGRectGetMidX(self.frame) - 25 + (j - h/2) * (spriteWidth + 1), CGRectGetMidY(self.frame) + 25 - (i - w/2) * (spriteHeight + 1));
            
            [self addChild:shape];
            [mut addObject:shape];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
}

-(void)renderBoard{
    self.scoreLabel.text = [@"Rows Cleared:" stringByAppendingString:[NSString stringWithFormat:@"%i", self.game.board.rowsCleared]];
    self.blocksPlacedLabel.text = [@" Blocks Placed:" stringByAppendingString:[NSString stringWithFormat:@"%i", self.game.board.blocksPlaced]];
    if(self.game.paused)
    {
        self.gamePausedBox.hidden = false;
    }
    else
    {
        self.gamePausedBox.hidden = true;
    }
    if(self.game.board.gameOver){
        self.gameOverBox.hidden = false;
        self.gamePausedBox.hidden = true;
    }
    else{
        self.gameOverBox.hidden = true;
    }
    for(int i = 0; i < [self.game.board.array count]; i++){
        NSArray * row = [self.game.board.array objectAtIndex:i];
        for(int j = 0; j < [row count]; j++){
            if([[row objectAtIndex:j] boolValue] == true){
                SKShapeNode * shape = [[self.sprites objectAtIndex:i] objectAtIndex:j];
                shape.fillColor = [SKColor colorWithRed:0 green:0 blue:1 alpha:1];
            }
            else{
                SKShapeNode * shape = [[self.sprites objectAtIndex:i] objectAtIndex:j];
                shape.fillColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
            }
        }
    }
    if(self.game.board.ghost != nil){
        for(Coordinate * coord in [BlockData getDataFromBlock:self.game.board.ghost].coordinates){
            SKShapeNode * shape = [[self.sprites objectAtIndex:coord.y] objectAtIndex:coord.x];
            shape.fillColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1];
        }
    }
    if(self.game.board.currentBlock != nil){
        for(Coordinate * coord in [BlockData getDataFromBlock:self.game.board.currentBlock].coordinates){
            SKShapeNode * shape = [[self.sprites objectAtIndex:coord.y] objectAtIndex:coord.x];
            shape.fillColor = [SKColor colorWithRed:0 green:0 blue:1 alpha:1];
        }
    }
    
    if(self.game.board.hold != nil){
        int counter = 0;
        for(Coordinate * coord in [BlockData defaultDataFromType:self.game.board.hold.type].coordinates){
            SKShapeNode * currentShape = [self.hold objectAtIndex:counter];
            currentShape.hidden = false;
            double x = CGRectGetMidX(self.frame) + 165 + ((coord.x) * (spriteWidth / offset + 1));
            double y = CGRectGetMidY(self.frame) + 275 - (coord.y) * (spriteWidth / offset + 1);
            currentShape.position = CGPointMake(x, y);
            counter++;
        }
    }
    else{
        for(SKShapeNode * shape in self.hold){
            shape.hidden = true;
        }
    }
    int queueCounter = 0;
    for(Block * block in self.game.board.queue){
        if(block == nil){
            break;
        }
        int counter = 0;
        for(Coordinate * coord in [BlockData defaultDataFromType:block.type].coordinates){
            SKShapeNode * currentShape = [[self.queue objectAtIndex:queueCounter] objectAtIndex:counter];
            currentShape.hidden = false;
            double x = CGRectGetMidX(self.frame) + 165 + ((coord.x) * (spriteWidth / offset + 1));
            double y = CGRectGetMidY(self.frame) + 125 - (queueCounter * 125) - (coord.y) * (spriteWidth / offset + 1);
            currentShape.position = CGPointMake(x, y);
            counter++;
        }
        queueCounter++;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    [self renderBoard];
    [self.game update:currentTime];
}

@end
