//
//  CreateGameViewController.m
//  BallStack
//
//  Created by Adam McDonald on 11/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CreateGameViewController.h"
#import "BallStackViewController.h"
#import "Game.h"
#import "Player.h"
#import "PlayerFactory.h"
#import "GENetworkManager.h"
#import "NetworkConstants.h"

#define INITIAL_JOINED_PLAYERS 1

// A class extension to declare private methods
@interface CreateGameViewController ()

- (void)createGame;
- (void)createGameWithName:(NSString *)name andNumPlayers:(int)num;
- (void)handleCreateGameResponse:(NSArray *)response;
- (void)hideKeyboard;
- (void)alertCreationError;
- (void)home;

@end


@implementation CreateGameViewController

@synthesize nameField, playerSegment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		
		// Home button
		UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[createButton setFrame:CGRectMake(20.0, 191.0, 280.0, 76.0)];
		[createButton setBackgroundImage:[UIImage imageNamed:@"createbutton.png"] forState:UIControlStateNormal];
		[createButton addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
		[[self view] addSubview:createButton];
		
		// Home button
		UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[homeButton setFrame:CGRectMake(5.0, 423.0, 52.0, 52.0)];
		[homeButton setBackgroundImage:[UIImage imageNamed:@"homebutton.png"] forState:UIControlStateNormal];
		[homeButton addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
		[[self view] addSubview:homeButton];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self hideKeyboard];
	[nameField setText:@""];
	[playerSegment setSelectedSegmentIndex:1];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

- (void)hideKeyboard {
	[nameField resignFirstResponder];
}

//- (IBAction)createGame:(id)sender {

- (void)createGame {
	[self hideKeyboard];
	
	NSString *name = [nameField text];
	
	NSInteger index = [playerSegment selectedSegmentIndex];
	int num = [[playerSegment titleForSegmentAtIndex:index] intValue];
	
	if ( name && [name length] > 0 ) [self createGameWithName:name andNumPlayers:num];
}

- (void)createGameWithName:(NSString *)name andNumPlayers:(int)num {
	//NSLog(@"Game Name: %@, Number of Players: %d", name, num);
	NSString *msg = [NSString stringWithFormat:@"%d;%@;%d", BSMessageCreateGame, name, num];
	[[GENetworkManager sharedSingleton] sendMessage:msg];
}

- (void)home {
	[self.navigationController popViewControllerAnimated:YES];
	//[[[BallStackViewController sharedSingleton] navigationController] popToRootViewControllerAnimated:YES];
}

//- - - Networking - - -
- (void)parseServerMessage:(NSString *)msg {
	NSArray *msgData = [msg componentsSeparatedByString:@";"];
	
	BSMessage bsm = [[msgData objectAtIndex:BSMESSAGE_TYPE_INDEX] intValue];
	
	switch (bsm) {
		case BSMessageUnknown:
			NSLog(@"[BSMessageUnknown]");
			break;
		case BSMessageCreateGame:
			NSLog(@"[BSMessageCreateGame]");
			[self handleCreateGameResponse:msgData];
			break;
		default:
			break;
	}
}

- (void)handleCreateGameResponse:(NSArray *)response {
	int status = [[response objectAtIndex:BSMESSAGE_CREATEGAME_GAMEID_INDEX] intValue];
	if ( status == BSMESSAGE_FAILURE ) {
		NSLog(@"Failed to create game.");
		[self alertCreationError];
	} else {
		NSLog(@"Successfully created game %d", status);
		
		NSString *name = [nameField text];
		NSInteger index = [playerSegment selectedSegmentIndex];
		int num = [[playerSegment titleForSegmentAtIndex:index] intValue];
		
		int secondsUntilStart = [[response objectAtIndex:BSMESSAGE_CREATEGAME_SECONDSUTILSTART_INDEX] intValue];
		
		Game *g = [[Game alloc] initWithGameId:status
										titled:name 
								withMaxPlayers:num 
							 withJoinedPlayers:INITIAL_JOINED_PLAYERS 
								   gStartingIn:secondsUntilStart];
		
		// Initialize self
		Player *p = [[PlayerFactory sharedSingleton] createPlayerWithPlayerId:SELF_PLAYERID];
		[g addPlayer:p];
		
		[[BallStackViewController sharedSingleton] setGame:g];
		[self.navigationController pushViewController:[BallStackViewController sharedSingleton] animated:YES];
	}
}

//- - - Alerts - - -
- (void)alertCreationError {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail"
													message:@"Failed to create new game."
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
}

//- - - TextField Delegate Methods - - -
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
