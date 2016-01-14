//
//  BlockData.m
//  Tetromino Drop
//
//  Created by Markus Feng on 1/8/16.
//  Copyright © 2016 assisstion. All rights reserved.
//

#import "BlockData.h"
#import "Block.h"

@implementation BlockData


-(instancetype)init{
    self = [super init];
    if(self){
        Coordinate * c1 = [[Coordinate alloc] init];
        Coordinate * c2 = [[Coordinate alloc] init];
        Coordinate * c3 = [[Coordinate alloc] init];
        Coordinate * c4 = [[Coordinate alloc] init];
        self.coordinates = @[c1, c2, c3, c4];
    }
    return self;
}

/*
 * 0:O
 * 1:I
 * 2:J
 * 3:T
 * 4:S
 * 5:Z
 * 6:L
 */
+(BlockData *)defaultDataFromType:(int)type{
    BlockData * data = [[BlockData alloc] init];
    switch (type) {
        case 0:
            [[data.coordinates objectAtIndex:0] setX:0 andY:0];
            [[data.coordinates objectAtIndex:1] setX:1 andY:0];
            [[data.coordinates objectAtIndex:2] setX:0 andY:1];
            [[data.coordinates objectAtIndex:3] setX:1 andY:1];
            break;
        case 1:
            [[data.coordinates objectAtIndex:0] setX:0 andY:-1];
            [[data.coordinates objectAtIndex:1] setX:0 andY:0];
            [[data.coordinates objectAtIndex:2] setX:0 andY:1];
            [[data.coordinates objectAtIndex:3] setX:0 andY:2];
            break;
        case 2:
            [[data.coordinates objectAtIndex:0] setX:-1 andY:0];
            [[data.coordinates objectAtIndex:1] setX:0 andY:0];
            [[data.coordinates objectAtIndex:2] setX:0 andY:-1];
            [[data.coordinates objectAtIndex:3] setX:0 andY:-2];
            break;
        case 3:
            [[data.coordinates objectAtIndex:0] setX:-1 andY:0];
            [[data.coordinates objectAtIndex:1] setX:0 andY:0];
            [[data.coordinates objectAtIndex:2] setX:1 andY:0];
            [[data.coordinates objectAtIndex:3] setX:0 andY:-1];
            break;
        case 4:
            [[data.coordinates objectAtIndex:0] setX:-1 andY:0];
            [[data.coordinates objectAtIndex:1] setX:0 andY:0];
            [[data.coordinates objectAtIndex:2] setX:0 andY:-1];
            [[data.coordinates objectAtIndex:3] setX:1 andY:-1];
            break;
        case 5:
            [[data.coordinates objectAtIndex:0] setX:1 andY:0];
            [[data.coordinates objectAtIndex:1] setX:0 andY:0];
            [[data.coordinates objectAtIndex:2] setX:0 andY:-1];
            [[data.coordinates objectAtIndex:3] setX:-1 andY:-1];
            break;
        case 6:
            [[data.coordinates objectAtIndex:0] setX:1 andY:-0];
            [[data.coordinates objectAtIndex:1] setX:0 andY:0];
            [[data.coordinates objectAtIndex:2] setX:0 andY:-1];
            [[data.coordinates objectAtIndex:3] setX:0 andY:-2];
            break;
        default:
            break;
    }
    return data;
}


+(BlockData *)getDataFromType:(int)type fromOrientation:(int)orientation withX:(int)x withY:(int)y{
    BlockData * data = [BlockData defaultDataFromType:type];
    //Never rotate the square
    if(type != 0){
        switch (orientation) {
            case 0:
                break;
            case 1:
                for(Coordinate * coord in data.coordinates){
                    [coord flipXY];
                    [coord invertX];
                }
                break;
            case 2:
                for(Coordinate * coord in data.coordinates){
                    [coord invertX];
                    [coord invertY];
                }
                break;
            case 3:
                for(Coordinate * coord in data.coordinates){
                    [coord flipXY];
                    [coord invertY];
                }
                break;
            default:
                break;
        }
    }
    //Add x and y
    for(Coordinate * coord in data.coordinates){
        [coord setX:coord.x + x andY:coord.y + y];
    }
    return data;
}

+(BlockData *)getDataFromBlock:(Block *)block
{
  return  [BlockData getDataFromType:block.type fromOrientation:block.orientation
                         withX:block.x withY: block.y];

}
@end
