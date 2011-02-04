//
//  BallCell.h
//  BallStack
//
//  Created by Jason on 12/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ball.h"

@class BallGrid;

@interface BallCell : NSObject {
	Ball *cellBall;
	CGPoint pos;
	BallGrid *ballgrid;
	int col;
	int row;
}

@property (nonatomic, retain) Ball *cellBall;
@property (nonatomic, assign) CGPoint pos;
@property (nonatomic, assign, readonly) int col;
@property (nonatomic, assign, readonly) int row;

- (id)initAtPos:(CGPoint)p withGrid:(BallGrid*)g atRow:(int)r andCol:(int)c;
- (BOOL)empty;
- (BallCell*)getUpLeft;
- (BallCell*)getUpRight;
- (BallCell*)getRight;
- (BallCell*)getDownRight;
- (BallCell*)getDownLeft;
- (BallCell*)getLeft;
- (BOOL)isEvenRow;
@end
