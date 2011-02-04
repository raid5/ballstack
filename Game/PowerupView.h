//
//  PowerupView.h
//  BallStack
//
//  Created by Adam McDonald on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PowerupView : UIImageView {

@private
	int pType;
	
}

@property (nonatomic, assign) int pType;

- (id)initWithFrame:(CGRect)frame withPowerupType:(int)powerType;

@end
