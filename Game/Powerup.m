//
//  Powerup.m
//  BallStack
//
//  Created by Adam McDonald on 12/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Powerup.h"

@implementation Powerup

@synthesize pType, pView;

- (id)initWithType:(int)powerupType {
	if (self = [super init]) {
		self.pType = powerupType;
		self.pView = nil;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
