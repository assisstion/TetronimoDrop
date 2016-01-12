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

@implementation GameScene{
    int ticks;
}

const int spriteWidth = 32;
const int spriteHeight = 32;

-(void)didMoveToView:(SKView *)view {
    
    ticks = 0;
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 45;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
    
    self.sprites = [[NSMutableArray alloc] init];
    self.game = [[Game alloc] init];
    [self setupBoard];
}


-(void)setupBoard{
    int w = (int)[self.game.board.array count];
    for(int i = 0; i < w; i++){
        NSArray * row = [self.game.board.array objectAtIndex:i];
        NSMutableArray * mut = [[NSMutableArray alloc] init];
        [self.sprites addObject:mut];
        int h = (int)[row count];
        for(int j = 0; j < h; j++){
            SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"block32"];
            sprite.xScale = 1;
            sprite.yScale = 1;
            sprite.position = CGPointMake(CGRectGetMidX(self.frame) + (j - h/2) * (spriteWidth + 1), CGRectGetMidY(self.frame) - (i - w/2) * (spriteHeight + 1));
            [self addChild:sprite];
            [mut addObject:sprite];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    /*for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"block32"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }*/
    
}

-(void)renderBoard{
    for(int i = 0; i < [self.game.board.array count]; i++){
        NSArray * row = [self.game.board.array objectAtIndex:i];
        for(int j = 0; j < [row count]; j++){
            if([[row objectAtIndex:j] boolValue] == true){
                [[self.sprites objectAtIndex:i] objectAtIndex:j].hidden = false;
            }
            else{
                [[self.sprites objectAtIndex:i] objectAtIndex:j].hidden = true;
            }
        }
    }
    for(Coordinate * coord in [BlockData getDataFromBlock:self.game.board.currentBlock].coordinates){
        [[self.sprites objectAtIndex:coord.y] objectAtIndex:coord.x].hidden = false;
    }

}

-(void)update:(CFTimeInterval)currentTime {
    [self renderBoard];
    ticks ++;
    if(ticks > 20){
        [self.game.board update];
        ticks = 0;
    }
}

@end
