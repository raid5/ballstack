//
//  GECollisionHandler.m
//  BallStack
//
//  Created by Jason on 11/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GECollisionHandler.h"

@implementation GECollisionHandler

@synthesize gameObject, layer;

- (id)initWithGELayer:(GELayer *)l {
	if (self = [super init]) {
		[self setGameObject:nil];
		[self setLayer:l];
    }
    return self;
}
 
- (BOOL)collide {
	return NO;
}

- (void)findAndReconcileCollisions {	
}

- (void)dealloc {
    [super dealloc];
}

@end
