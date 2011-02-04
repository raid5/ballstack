//
//  GELayer.m
//  BallStack
//
//  Created by Adam McDonald on 11/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GELayer.h"

#define INITIAL_OBJECTS 100

@implementation GELayer

@synthesize gameObjects;

- (id)init {
    if (self = [super init]) {
        // Initialization code
		gameObjects = [[NSMutableArray alloc] initWithCapacity:INITIAL_OBJECTS];
    }
    return self;
}

- (void)addGameObject:(GEGameObject *)obj {
	[gameObjects addObject:obj];
}

- (void)removeGameObject:(GEGameObject *)obj {
	[gameObjects removeObject:obj];
}

- (void)removeAllGameObjects {
	[gameObjects removeAllObjects];
}

- (void)dealloc {
	[gameObjects release];
    [super dealloc];
}

@end