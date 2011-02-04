//
//  BallCell.m
//  BallStack
//
//  Created by Jason on 12/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BallCell.h"
#import "BallStackViewController.h"


@implementation BallCell

@synthesize cellBall, pos, row, col;

- (id)initAtPos:(CGPoint)p withGrid:(BallGrid*)g atRow:(int)r andCol:(int)c {
	if (self = [super init]) {
		cellBall = nil;
		pos = p;
		ballgrid = g;
		col = c;
		row = r;
	}
	return self;
}

- (BOOL)empty {
	return ( [self cellBall] == nil );
}

- (void)dealloc {
    [super dealloc];
}

- (BallCell*)getUpLeft {
	if([self isEvenRow])
		return [ballgrid getCellAtRow:[self row] - 1 andCol:[self col] - 1];
	else
		return [ballgrid getCellAtRow:[self row] - 1 andCol:[self col]];
}

- (BallCell*)getUpRight {
	if([self isEvenRow])
		return [ballgrid getCellAtRow:[self row] - 1 andCol:[self col]];
	else
		return [ballgrid getCellAtRow:[self row] - 1 andCol:[self col] + 1];
}

- (BallCell*)getRight {
	return [ballgrid getCellAtRow:[self row] andCol:[self col] + 1];
}

- (BallCell*)getDownRight {
	if([self isEvenRow])
		return [ballgrid getCellAtRow:[self row] + 1 andCol:[self col]];
	else
		return [ballgrid getCellAtRow:[self row] + 1 andCol:[self col] + 1];
}

- (BallCell*)getDownLeft {
	if([self isEvenRow])
		return [ballgrid getCellAtRow:[self row] + 1 andCol:[self col] - 1];
	else
		return [ballgrid getCellAtRow:[self row] + 1 andCol:[self col]];
		
}

- (BallCell*)getLeft {
	return [ballgrid getCellAtRow:[self row] andCol:[self col] - 1];
}

- (BOOL)isEvenRow {
	return ! (row % 2 > 0);
}

@end
