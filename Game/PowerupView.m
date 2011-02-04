//
//  PowerupView.m
//  BallStack
//
//  Created by Adam McDonald on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PowerupView.h"

@implementation PowerupView

@synthesize pType;

- (id)initWithFrame:(CGRect)frame withPowerupType:(int)powerType {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		self.pType = powerType;
		self.image = [UIImage imageNamed:[NSString stringWithFormat:@"powerupview-%d.png", self.pType]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
    [super dealloc];
}

@end
