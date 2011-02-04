//
//  GEGameObject.m
//  BallStack
//
//  Created by Adam McDonald on 11/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GEGameObject.h"

@implementation GEGameObject

@synthesize active, moving, visible, radius, width, height, identifier, direction, position;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code (default)
		self.active = YES;
		self.moving = NO;
		self.visible = YES;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

/*
 * Override this method in subclass (if needed).
 */
- (void)draw {
	[self.image drawAtPoint:self.frame.origin];
}

/*
 * Override this method in subclass.
 */
- (void)update {
}

@end
