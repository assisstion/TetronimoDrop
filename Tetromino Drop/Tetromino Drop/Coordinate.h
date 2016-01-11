//
//  Coordinate.h
//  Tetromino Drop
//
//  Created by Markus Feng on 1/8/16.
//  Copyright © 2016 assisstion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coordinate : NSObject

@property int x;
@property int y;

-(instancetype)initWithX:(int)x andY:(int)y;
-(void)setX:(int)x andY:(int)y;
-(void)flipXY;
-(void)invert;

@end
