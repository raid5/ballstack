//
//  GameTableViewCell.h
//  BallStack
//
//  Created by Adam McDonald on 12/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GameCell : UITableViewCell {

	UILabel *title;
	UILabel *status;
	UILabel *seconds;
	
}

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *status;
@property (nonatomic, retain) UILabel *seconds;

@end
