//
//  BlockData.h
//  Tetromino Drop
//
//  Created by Markus Feng on 1/8/16.
//  Copyright © 2016 assisstion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coordinate.h"

@interface BlockData : NSObject

@property NSArray <Coordinate *> * coordinates;

+(BlockData *)defaultDataFromType:(int) type;
+(BlockData *)getDataFromType:(int)type fromOrientation:(int)orientation withX:(int)x withY:(int)y;

@end
