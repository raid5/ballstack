//
//  BallGrid.h
//  BallStack
//
//  Created by Jason on 12/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ball.h"
#import "BallCell.h"

//#define NUM_ROWS	10
#define NUM_ROWS	14
#define NUM_COLS    10
//#define NUM_COLS     8
#define POWERUP_INCREMENT 20
#define VERTICAL_ADJUSTMENT  0  // adjustment to mesh the balls of the rows together

@interface BallGrid : NSObject {
	
@private
	NSMutableArray *rows;
	
}

@property (nonatomic, retain) NSMutableArray *rows;

- (int)calculateCol:(CGPoint) p;
- (int)calculateRow:(CGPoint) p;
- (void)snapToGrid:(Ball*) b;
- (BallCell*)getCellForX:(float)x andY:(float)y;
- (BallCell*)getCellForPoint:(CGPoint)p;
- (BallCell*)getCellAtRow:(int)row andCol:(int)col;

@end
