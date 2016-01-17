//
//  Coordinate.m
//  Tetromino Drop
//
//  Created by Markus Feng on 1/8/16.
//  Copyright © 2016 assisstion. All rights reserved.

// Set up the coordinate system and logic for rotating pieces using invertion

#import "Coordinate.h"

@implementation Coordinate

-(instancetype)initWithX:(int)x andY:(int)y{
    self = [super init];
    if(self){
        self.x = x;
        self.y = y;
    }
    return self;
}

-(void)setX:(int)x andY:(int)y{
    self.x = x;
    self.y = y;
}

-(void)flipXY{
    int z = self.x;
    self.x = self.y;
    self.y = z;
}

-(void)invertX{
    self.x = -self.x;
}

-(void)invertY{
    self.y = -self.y;
}

@end
