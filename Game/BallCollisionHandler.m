//
//  BallCollisionHandler.m
//  BallStack
//
//  Created by Jason on 11/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BallCollisionHandler.h"

@interface BallCollisionHandler () 

- (NSMutableArray*)searchForColorClusters:(Ball*)actor;
- (void)setChildParentRelationships:(Ball*)actor;
- (void)popColorCluster:(NSMutableArray*)balls;

@end

@implementation BallCollisionHandler

- (BOOL)collide:(Ball *)obj {
	if (![obj active]) return NO;
	//The -3 is to make the balls seem slightly smaller thn they really are so that
	//	they can slide into tight spots
	double r1 = [self.gameObject radius];
	double r2 = [obj radius];
	double r = r1 + r2;
	CGPoint r1center = [(Ball*)self.gameObject centerPosition];
	CGPoint r2center = [(Ball*)obj centerPosition];

	double dx = r1center.x - r2center.x;
	double dy = r1center.y - r2center.y;
	double dist2 = dx * dx + dy * dy;
	return (dist2 > r*r) ? NO : YES;
}


- (void)rewind:(Ball*)b {
	while ([self collide:b]) {
		double x = [self.gameObject position].x;
		double y = [self.gameObject position].y;
		double dx = [self.gameObject direction].x;
		double dy = [self.gameObject direction].y;
		[self.gameObject setPosition:CGPointMake(x-dx, y-dy)];
	}	
}

- (void)findAndReconcileCollisions {
	double radius = [[self gameObject] radius];
	NSMutableArray *contents = [self.layer gameObjects];
	if (![self.gameObject moving]) return;
	for (id obj in contents) {
		if ([obj identifier] != [self.gameObject identifier]) {
			if ( [obj active] ) {
				
				[[self gameObject] setRadius:radius - 4];
				if ([self collide:(Ball*)obj]) {
					[self.gameObject setMoving:NO];
					[[self gameObject] setRadius:radius];
					
					// rewind it a bit
					[self rewind:(Ball*)obj];
					// snap to grid, set child/parent relationships, pop color clusters
					
					[self handlePostCollisionEvents:(Ball*)[self gameObject]];
				}
				[[self gameObject] setRadius:radius];
			}
		}
	}
	[(Ball*)[self gameObject] draw];
}


- (void) handlePostCollisionEvents:(Ball*)actor {
	// snap to grid
	[[[BallStackViewController sharedSingleton] ballGrid] snapToGrid:actor]; 	
	
	//Assign children/parent/sibling ball relationships where necesary
	[self setChildParentRelationships:actor];

	//Performs breadth first search and returns list of >= 3 balls with matching color of actor
	NSMutableArray* balls = [self searchForColorClusters:actor];
	if (balls != nil) {
		//NSLog(@"Balls to pop = %d\n", [balls count]);
		[self popColorCluster:balls];
		[balls removeAllObjects];
		[balls release];
	} else {
		//NSLog(@"Not enough balls to pop\n");
	}
	
}

- (void)setChildParentRelationships:(Ball*)actor {
	BallGrid *bg = [[BallStackViewController sharedSingleton] ballGrid];
	CGPoint center = [actor centerPosition];
	CGPoint adjustedCenter = CGPointMake(center.x, center.y/* - [[BallStackViewController sharedSingleton] stackHeight]*/);
	int col = [bg calculateCol:adjustedCenter];
	int row = [bg calculateRow:adjustedCenter];
	
	//NSLog(@"[bch cell] %d x %d", row, col);
	
	BallCell *actorCell = [bg getCellAtRow:row andCol:col];
	BallCell *c;
	
	
	//If there is cell up and left and it is not empty
	if (( c = [actorCell getUpLeft]) && ![c empty]) {
		[actor addParent:[c cellBall]];
		[[c cellBall] addChild:actor];
		//NSLog(@"Parent in row %i col %i\n", [c row], [c col]);
	}
	
	if (( c = [actorCell getUpRight]) && ![c empty]) {
		[actor addParent:[c cellBall]];
		[[c cellBall] addChild:actor];
		//NSLog(@"Parent in row %i col %i\n", [c row], [c col]);
	}
	
	if (( c = [actorCell getRight]) && ![c empty]) {
		[actor addSibling:[c cellBall]];
		[[c cellBall] addSibling:actor];
		//NSLog(@"Sibilng in row %i col %i\n", [c row], [c col]);
	}

	if (( c = [actorCell getLeft]) && ![c empty]) {
		[actor addSibling:[c cellBall]];
		[[c cellBall] addSibling:actor];
		//NSLog(@"Sibilng in row %i col %i\n", [c row], [c col]);
	}
	
	
	if (( c = [actorCell getDownLeft]) && ![c empty]) {
		[actor addChild:[c cellBall]];
		[[c cellBall] addParent:actor];
		//NSLog(@"Child in row %i col %i\n", [c row], [c col]);
	}
	
	if (( c = [actorCell getDownRight]) && ![c empty]) {
		[actor addChild:[c cellBall]];
		[[c cellBall] addParent:actor];
		//NSLog(@"Child in row %i col %i\n", [c row], [c col]);
	}
	
	//NSLog(@"Done setting child parent relationships\n");
}




//Does a breadth-first style search to locate neighboring balls
//	of the same color as the actor.
//If there are less than 3 touching balls with the same color, nil is returned
- (NSMutableArray*)searchForColorClusters:(Ball*)actor; {
	NSMutableArray* balls = [[NSMutableArray alloc] initWithCapacity:6];
	NSMutableArray* queue = [[NSMutableArray alloc] initWithCapacity:6];
	BallGrid *bg = [[BallStackViewController sharedSingleton] ballGrid];
	CGPoint center;
	int col;
	int row;
	Ball *b;
	Color c = [actor color];
	
	[queue addObject:actor];
	[balls addObject:actor];
	
	//NSLog(@"Looping neighbors looking for matche\n");
	while ([queue count] > 0) {
		
		//Get next ball
		b = [queue objectAtIndex:0];
		[queue removeObjectAtIndex:0];

		center = [b centerPosition];
		CGPoint adjustedCenter = CGPointMake(center.x, center.y/* - [[BallStackViewController sharedSingleton] stackHeight]*/);
		col = [bg calculateCol:adjustedCenter];
		row = [bg calculateRow:adjustedCenter];

		for (Ball* parent in [b parents]) {
			if ([parent color] == c && ![balls containsObject:parent]) {
				[queue addObject:parent];
				[balls addObject:parent];
			}
		}
		
		for (Ball* child in [b children]) {
			if ([child color] == c && ![balls containsObject:child]) {
				[queue addObject:child];
				[balls addObject:child];
			}
		}
		
		for (Ball* sibling in [b siblings]) {
			if ([sibling color] == c && ![balls containsObject:sibling]) {
				[queue addObject:sibling];
				[balls addObject:sibling];
			}
		}
 
	}
	
	//NSLog(@"Done looping\n");
	if ([balls count] < 3) {
		[balls removeAllObjects];
		[balls release];
		balls = nil;
	}
	[queue release];
	return balls;
}

- (void)popColorCluster:(NSMutableArray*)balls {
	//NSLog(@"Popping balls\n");
	NSMutableArray *neighbors = [[NSMutableArray alloc] initWithCapacity:20];
	
	//Gather all neighbors of all balls
	//After all the primary clustered balls are popped, the
	//	neighbors will be itereated to determine if they rooted to the
	//	ceiling or not.  If they are not rooted they will be popped.
	for (Ball *b in balls) {
		
		for (Ball* parent in [b parents]) {
			if (![neighbors containsObject:parent] && ![balls containsObject:parent]) 
				[neighbors addObject:parent];
		}
		for (Ball* child in [b children]) {
			if (![neighbors containsObject:child] && ![balls containsObject:child]) 
				[neighbors addObject:child];
		}
		for (Ball* sibling in [b siblings]) {
			if (![neighbors containsObject:sibling] && ![balls containsObject:sibling]) 
				[neighbors addObject:sibling];
		}
		
		[b pop];
		
	}
	
	Ball *b;
	NSMutableArray *danglers;
	//Pop all clusters of balls that are not rooted to the ceiling
	while ([neighbors count] > 0) {
		b = [neighbors objectAtIndex:0];
		[neighbors removeObjectAtIndex:0];
		
		if ( (danglers = [b isRooted] ) == nil ) {
			//Ball is rooted to the ceiling
			//At this point, nothing to do
		} 
		
		else {
			//Ball is not connected to the ceiling
			//danglers contains a cluster of balls not connected
			//	to the ceiling.
			//If any of those balls in the 'dangling' cluster are in
			//	the neighbors list, they need to be removed so they
			//	are not unnecesary iterated over in the future.
			[neighbors removeObjectsInArray:danglers];
			while ([danglers count] > 0) {
				[[danglers objectAtIndex:0] pop];
				[danglers removeObjectAtIndex:0];
			}
			[danglers release];
		}
	}

	[neighbors release];
	
	//NSLog(@"Finished popping balls\n");
}

@end
