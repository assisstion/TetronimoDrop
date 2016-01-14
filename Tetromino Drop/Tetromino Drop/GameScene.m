//
//  GameScene.m
//  Tetromino Drop
//
//  Created by ajha17 on 1/5/16.
//  Copyright (c) 2016 assisstion. All rights reserved.
//

#import "GameScene.h"
#import "Coordinate.h"
#import "BlockData.h"

@implementation GameScene

const int spriteWidth = 32;
const int spriteHeight = 32;

-(void)didMoveToView:(SKView *)view {
    
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    UISwipeGestureRecognizer* swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [swipeRightGesture setDirection: UISwipeGestureRecognizerDirectionRight];
    [swipeLeftGesture setDirection: UISwipeGestureRecognizerDirectionLeft];
    [swipeDownGesture setDirection: UISwipeGestureRecognizerDirectionDown];
    [view addGestureRecognizer: swipeRightGesture];
    [view addGestureRecognizer: swipeLeftGesture];
    [view addGestureRecognizer: swipeDownGesture];
    [view addGestureRecognizer: tapGesture];
    
    self.sprites = [[NSMutableArray alloc] init];
    self.game = [[Game alloc] init];
    [self.game start];
    [self setupBoard];
    
}

-(void) handleSwipeRight:(UISwipeGestureRecognizer *) recognizer{
    [self.game.board.currentBlock moveRight];
}

-(void) handleSwipeLeft:(UISwipeGestureRecognizer *) recognizer{
    [self.game.board.currentBlock moveLeft];
}

-(void) handleSwipeDown:(UISwipeGestureRecognizer *) recognizer{
    [self.game.board.currentBlock instantDrop];
}

-(void) handleTap:(UISwipeGestureRecognizer *) recognizer{
    [self.game.board.currentBlock rotateRight];
}


-(void)setupBoard{
    int w = (int)[self.game.board.array count];
    for(int i = 0; i < w; i++){
        NSArray * row = [self.game.board.array objectAtIndex:i];
        NSMutableArray * mut = [[NSMutableArray alloc] init];
        [self.sprites addObject:mut];
        int h = (int)[row count];
        for(int j = 0; j < h; j++){
            SKShapeNode * shape = [SKShapeNode shapeNodeWithRectOfSize: CGSizeMake(32, 32)];
            shape.fillColor = [SKColor blueColor];
            shape.position = CGPointMake(CGRectGetMidX(self.frame) + (j - h/2) * (spriteWidth + 1), CGRectGetMidY(self.frame) - (i - w/2) * (spriteHeight + 1));
            
            [self addChild:shape];
            [mut addObject:shape];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    
}

-(void)renderBoard{
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
}

-(void)update:(CFTimeInterval)currentTime {
    [self renderBoard];
    [self.game update:currentTime];
}

@end
