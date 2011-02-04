//
//  BallFactory.h
//  BallStack
//
//  Created by Jason on 11/30/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//Enumeration for specifying ball color
typedef enum {
	Blue,
	Green,
	Orange,
	Red,
	Purple,
	Black
} Color;

@class Ball;

@interface BallFactory : NSObject {
	
@private
	int count;
	
}

@property (nonatomic, assign) int count;

- (id)init;
+ (BallFactory *)sharedSingleton;
- (Ball *)createBall;
- (Ball *)createBallWithColor:(Color)c;
- (Ball *)createSmallBall;
- (Ball *)enlargeBall:(Ball *)b;
- (void)resetCount;

@end


