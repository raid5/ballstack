//
//  IntroViewController.h
//  BallStack
//
//  Created by Adam McDonald on 11/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GEViewController.h"

@class JoinGameViewController, CreateGameViewController;

@interface IntroViewController : GEViewController {

@private
	IBOutlet UIButton *quickButton;
	IBOutlet UIButton *joinButton;
	IBOutlet UIButton *createButton;
	
	JoinGameViewController *jgvc;
	CreateGameViewController *cgvc;
	
}

@property (nonatomic, retain) IBOutlet UIButton *quickButton;
@property (nonatomic, retain) IBOutlet UIButton *joinButton;
@property (nonatomic, retain) IBOutlet UIButton *createButton;
@property (nonatomic, retain) JoinGameViewController *jgvc;
@property (nonatomic, retain) CreateGameViewController *cgvc;

- (IBAction)quickPlay:(id)sender;
- (IBAction)joinGame:(id)sender;
- (IBAction)createGame:(id)sender;

@end
