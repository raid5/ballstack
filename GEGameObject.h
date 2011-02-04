//
//  GEGameObject.h
//  BallStack
//
//  Created by Adam McDonald on 11/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GEGameObject : UIImageView {

@protected
	BOOL active;
	BOOL moving;
	BOOL visible;
	double radius;
	double width;
	double height;
	CGPoint direction;	
	CGPoint position;
	int identifier;
	
}

@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL moving;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) double radius;
@property (nonatomic, assign) double width;
@property (nonatomic, assign) double height;
@property (nonatomic, assign) CGPoint direction;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) int identifier;

- (id)initWithFrame:(CGRect)frame;
- (void)draw;
- (void)update;

@end
