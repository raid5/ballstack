//
//  GameTableViewCell.m
//  BallStack
//
//  Created by Adam McDonald on 12/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GameCell.h"


@implementation GameCell

@synthesize title, status, seconds;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		//title = [[UILabel alloc] initWithFrame:CGRectZero];
		title = [[UILabel alloc] initWithFrame:CGRectMake(44.0, 5.0, 320.0, 20.0)];
		[title setBackgroundColor:[UIColor whiteColor]];
		[title setTextColor:[UIColor blackColor]];
		[title setFont:[UIFont boldSystemFontOfSize:18.0]];
		[title setOpaque:YES];
		[self addSubview:title];
		
		status = [[UILabel alloc] initWithFrame:CGRectMake(54.0, 25.0, 100.0, 16.0)];
		[status setBackgroundColor:[UIColor whiteColor]];
		[status setTextColor:[UIColor darkGrayColor]];
		[status setFont:[UIFont systemFontOfSize:14.0]];
		[status setOpaque:YES];
		[self addSubview:status];
		
		seconds = [[UILabel alloc] initWithFrame:CGRectMake(220.0, 25.0, 80.0, 10.0)];
		[seconds setBackgroundColor:[UIColor whiteColor]];
		[seconds setTextColor:[UIColor darkGrayColor]];
		[seconds setTextAlignment:UITextAlignmentRight];
		[seconds setFont:[UIFont systemFontOfSize:14.0]];
		[seconds setOpaque:YES];
		[self addSubview:seconds];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[title release];
	[status release];
	[seconds release];
    [super dealloc];
}


@end
