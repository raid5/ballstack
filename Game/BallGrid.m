//
//  BallGrid.m
//  BallStack
//
//  Created by Jason on 12/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BallGrid.h"
#import "BallStackViewController.h"


@implementation BallGrid

@synthesize rows;

- (id)init {
	int col, row;
	CGPoint p;
	if (self = [super init]) {		
		rows = [[NSMutableArray alloc] initWithCapacity:NUM_ROWS];
		
		for (row = 0; row < NUM_ROWS; row ++) {
			
			[rows addObject:[[NSMutableArray alloc] initWithCapacity:NUM_COLS]];
			if (row % 2 > 0) {
				
				//short row (odd numbered rows)
				for (col = 0; col < NUM_COLS; col++) {
					p = CGPointMake((col * BALL_WIDTH) + (BALL_WIDTH/2), row * (BALL_HEIGHT-VERTICAL_ADJUSTMENT));
					[[rows objectAtIndex:row] addObject:[[BallCell alloc] initAtPos:p withGrid:self atRow:row andCol:col]];
					[[[rows objectAtIndex:row] objectAtIndex:col] setCellBall:nil];
					[[[rows objectAtIndex:row] objectAtIndex:col] setCellBall:nil];						
				}
				
			} else {
				for (col = 0; col < NUM_COLS; col++) {
					p = CGPointMake(col * BALL_WIDTH, row * (BALL_HEIGHT - VERTICAL_ADJUSTMENT));
					[[rows objectAtIndex:row] addObject:[[BallCell alloc] initAtPos:p withGrid:self atRow:row andCol:col]];
					[[[rows objectAtIndex:row] objectAtIndex:col] setCellBall:nil];
					[[[rows objectAtIndex:row] objectAtIndex:col] setCellBall:nil];
				}
			}
		}
	}
	
	return self;
}

- (int)calculateCol:(CGPoint) p {
	int row = [self calculateRow:p];
	if (row % 2 > 0) {   // odd row, horizontal offset 1/2 width of ball
		return abs((int)((p.x - (BALL_WIDTH/2)) / BALL_WIDTH) % NUM_COLS);
	}
    // otherwise it's an even row, no offset
	return abs((int)(p.x/ BALL_WIDTH) % NUM_COLS);
}

- (int)calculateRow:(CGPoint) p {
	int y = floor((p.y - [[BallStackViewController sharedSingleton] stackHeight])/(BALL_HEIGHT - VERTICAL_ADJUSTMENT));
	return abs((int)(y % NUM_ROWS));
}

- (void)snapToGrid:(Ball*) ball {
	int stackOffset = [[BallStackViewController sharedSingleton] stackHeight];
	CGPoint center = [ball centerPosition];
	center.x = (center.x < BALL_WIDTH/2 ) ? BALL_WIDTH/2 : center.x;
	center.x = (center.x > SCREEN_WIDTH - (BALL_WIDTH/2) - 1) ? SCREEN_WIDTH - (BALL_WIDTH/2) - 1: center.x;
	//center.y -= stackOffset;
	int col = [self calculateCol:center];
	int row = [self calculateRow:center];
	//NSLog(@"SnapToGrid: x:%g  y:%g\n", [ball position].x, [ball position].y);
	//NSLog(@"SnapToGrid: center: x:%g  y:%g\n", center.x, center.y);
	BallCell* cell = [[rows objectAtIndex:row] objectAtIndex:col];
	[cell setCellBall:ball]; 
	CGPoint p = [cell pos];
	if (row == 0) [ball setIsRoot:YES];
	[ball setPosition:CGPointMake(p.x, p.y + stackOffset)];
}

- (void)dealloc {
	[rows release];
    [super dealloc];
}

//Gets the cell that the point x,y falls into
- (BallCell*)getCellForX:(float)x andY:(float)y {
	return [self getCellForPoint:CGPointMake(x, y)];
}

//Gets the cell that the point x,y falls into
- (BallCell*)getCellForPoint:(CGPoint)p {
	int row = [self calculateRow:p];
	int col = [self calculateCol:p];
	//row or col is -1
	if (row < 0 || col < 0 || row > NUM_ROWS - 1) return nil;
	//row is odd and is outside last column index
	else if (row % 2 > 0 && col > NUM_COLS - 2) return nil;
	//row is even and outside last column index
	else if ( col > NUM_COLS - 1 ) return nil;
	return [[rows objectAtIndex:row] objectAtIndex:col];
}


- (BallCell*)getCellAtRow:(int)row andCol:(int)col {
	if (row < 0 || col < 0 || row > NUM_ROWS - 1) return nil;
	//row is odd and is outside last column index
	else if (row % 2 > 0 && col > NUM_COLS - 2) return nil;
	//row is even and outside last column index
	else if ( col > NUM_COLS - 1 ) return nil;
	return [[rows objectAtIndex:row] objectAtIndex:col];	
}

@end
