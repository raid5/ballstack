//
//  DevViewController.m
//  BallStack
//
//  Created by Adam McDonald on 11/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "DevViewController.h"
#import "BallStackViewController.h"
#import "GENetworkManager.h"
#import "NetworkConstants.h"
#import "Game.h"
#import "Player.h"
#import "PlayerFactory.h"

@implementation DevViewController

@synthesize msgField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
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

- (IBAction)send:(id)sender {
	NSString *msg = [msgField text];
	if ( [msg length] > 0 ) [[GENetworkManager sharedSingleton] sendMessage:msg];
}

- (void)parseServerMessage:(NSString *)msg {
	NSArray *msgData = [msg componentsSeparatedByString:@";"];
	
	BSMessage bsm = [[msgData objectAtIndex:BSMESSAGE_TYPE_INDEX] intValue];
	
	switch (bsm) {
		case BSMessageUnknown:
			NSLog(@"[BSMessageUnknown]");
			break;
		case BSMessageJoinGame:
			NSLog(@"[BSMessageJoinGame]");
			break;
		case BSMessageLeaveGame:
			NSLog(@"[BSMessageLeaveGame]");
			break;
		case BSMessageListGames:
			NSLog(@"[BSMessageListGames]");
			break;
		case BSMessageCreateGame:
			NSLog(@"[BSMessageCreateGame]");
			break;
		case BSMessageStatusUpdate:
			NSLog(@"[BSMessageStatusUpdate]");
			break;
		case BSMessagePowerupUsage:
			NSLog(@"[BSMessagePowerupUsage]");
			break;
		case BSMessagePlayerJoin:
			NSLog(@"[BSMessagePlayerJoin]");
			break;
		case BSMessagePlayerLeft:
			NSLog(@"[BSMessagePlayerLeft]");
			break;
		case BSMessageStartGame:
			NSLog(@"[BSMessageStartGame]");
			break;
		case BSMessageAddTime:
			NSLog(@"[BSMessageAddTime]");
			break;
		case BSMessageRandomGame:
			NSLog(@"[BSMessageRandomGame]");
			break;
		default:
			break;
	}
}

- (IBAction)startTestGame:(id)sender {
	Game *g = [[Game alloc] initWithGameId:TEST_GAMEID
									titled:@"test game"
							withMaxPlayers:2
						 withJoinedPlayers:1
							   gStartingIn:1];
	
	// Initialize self
	Player *p = [[PlayerFactory sharedSingleton] createPlayerWithPlayerId:SELF_PLAYERID];
	[g addPlayer:p];
	
	[[BallStackViewController sharedSingleton] setGame:g];
	[self.navigationController pushViewController:[BallStackViewController sharedSingleton] animated:YES];
	[[BallStackViewController sharedSingleton] startGame]; // FORCE GAME LOOP TO START
}

//-- TextField Delegate Methods --
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[msgField resignFirstResponder];
	return YES;
}

@end
