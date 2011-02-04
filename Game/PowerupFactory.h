//
//  PowerupFactory.h
//  BallStack
//
//  Created by Adam McDonald on 12/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Powerup;

@interface PowerupFactory : NSObject {

}

+ (PowerupFactory *)sharedSingleton;
- (Powerup *)createPowerup;
- (Powerup *)createPowerupOfType:(int)pType;

@end