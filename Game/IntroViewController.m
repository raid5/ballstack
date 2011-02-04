//
//  IntroViewController.m
//  BallStack
//
//  Created by Adam McDonald on 11/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "IntroViewController.h"
#import "BallStackViewController.h"
#import "JoinGameViewController.h"
#import "CreateGameViewController.h"
#import "DevViewController.h"
#import "Game.h"
#import "Player.h"
#import "PlayerFactory.h"
#import "GENetworkManager.h"
#import "NetworkConstants.h"

// A class extension to declare private methods
@interface IntroViewController ()
- (void)handleRandomGameResponse:(NSArray *)response;
- (void)alertJoinError;
@end


@implementation IntroViewController

@synthesize quickButton, joinButton, createButton, jgvc, cgvc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		jgvc = nil;
		cgvc = nil;
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	// Add labels to hidden buttons
	UILabel *quickLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, 60.0, 60.0)];
	[quickLabel setBackgroundColor:[UIColor clearColor]];
	[quickLabel setNumberOfLines:2];
	[quickLabel setLineBreakMode:UILineBreakModeWordWrap];
	[quickLabel setTextAlignment:UITextAlignmentCenter];
	[quickLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
	[quickLabel setTextColor:[UIColor whiteColor]];
	[quickLabel setText:@"Quick Play"];
	[quickButton addSubview:quickLabel];
	[quickLabel release];
	
	UILabel *joinLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 10.0, 60.0, 60.0)];
	[joinLabel setBackgroundColor:[UIColor clearColor]];
	[joinLabel setNumberOfLines:2];
	[joinLabel setLineBreakMode:UILineBreakModeWordWrap];
	[joinLabel setTextAlignment:UITextAlignmentCenter];
	[joinLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
	[joinLabel setTextColor:[UIColor whiteColor]];
	[joinLabel setText:@"Join Game"];
	[joinButton addSubview:joinLabel];
	[joinLabel release];
	
	UILabel *createLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 10.0, 60.0, 60.0)];
	[createLabel setBackgroundColor:[UIColor clearColor]];
	[createLabel setNumberOfLines:2];
	[createLabel setLineBreakMode:UILineBreakModeWordWrap];
	[createLabel setTextAlignment:UITextAlignmentCenter];
	[createLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
	[createLabel setTextColor:[UIColor whiteColor]];
	[createLabel setText:@"Create Game"];
	[createButton addSubview:createLabel];
	[createLabel release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[self view] setFrame:CGRectMake(0,0,320,480)];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
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
	if ( jgvc != nil ) [jgvc release];
	if ( cgvc != nil ) [cgvc release];
    [super dealloc];
}

- (IBAction)quickPlay:(id)sender {
	NSString *msg = [NSString stringWithFormat:@"%d", BSMessageRandomGame];
	[[GENetworkManager sharedSingleton] sendMessage:msg];
}

- (IBAction)joinGame:(id)sender {
	// Add JoinGame view to window
	if ( jgvc == nil ) jgvc = [[JoinGameViewController alloc] initWithNibName:@"Join" bundle:nil];
	[self.navigationController pushViewController:jgvc animated:YES];
}

- (IBAction)createGame:(id)sender {
	// Add CreateGame view to window
	if ( cgvc == nil ) cgvc = [[CreateGameViewController alloc] initWithNibName:@"Create" bundle:nil];
	[self.navigationController pushViewController:cgvc animated:YES];
}

//- - - Networking - - -
- (void)parseServerMessage:(NSString *)msg {
	//NSLog(@"[debug] msg => %@", msg);
	
	NSArray *msgData = [msg componentsSeparatedByString:@";"];
	
	BSMessage bsm = [[msgData objectAtIndex:BSMESSAGE_TYPE_INDEX] intValue];
	
	switch (bsm) {
		case BSMessageUnknown:
			NSLog(@"[BSMessageUnknown]");
			break;
		case BSMessageJoinGame:
			NSLog(@"[BSMessageJoinGame]");
			[self handleRandomGameResponse:msgData];
			break;
		default:
			break;
	}
}

- (void)handleRandomGameResponse:(NSArray *)response {
	int status = [[response objectAtIndex:BSMESSAGE_JOINGAME_GAMEID_INDEX] intValue];
	if ( status == BSMESSAGE_FAILURE ) {
		NSLog(@"Failed to join game.");
		[self alertJoinError];
	} else {
		NSLog(@"Successfully joined game %d", status);
		
		// Query for data
		NSString *title = [response objectAtIndex:BSMESSAGE_JOINGAME_TITLE_INDEX];
		int startingIn = [[response objectAtIndex:BSMESSAGE_JOINGAME_SECONDSUNTILSTART_INDEX] intValue];
		int maxPlayers = [[response objectAtIndex:BSMESSAGE_JOINGAME_MAXPLAYERS_INDEX] intValue];
		int joinedPlayers = [[response objectAtIndex:BSMESSAGE_JOINGAME_JOINEDPLAYERS_INDEX] intValue];
		
		// Initialize Game
		Game *g = [[Game alloc] initWithGameId:status
										titled:title
								withMaxPlayers:maxPlayers
							 withJoinedPlayers:joinedPlayers
								   gStartingIn:startingIn];
		
		// Initialize self
		Player *p = [[PlayerFactory sharedSingleton] createPlayerWithPlayerId:SELF_PLAYERID];
		[g addPlayer:p];
		
		// Initialize players (if any exist)
		if ( joinedPlayers > 0 ) {
			for ( int i = BSMESSAGE_JOINGAME_PLAYERS_INDEX; i < (BSMESSAGE_JOINGAME_PLAYERS_INDEX + joinedPlayers); i++ ) {
				Player *p = [[PlayerFactory sharedSingleton] createPlayerWithPlayerId:[[response objectAtIndex:i] intValue]];
				[g addPlayer:p];
			}
		}
		
		// Load game view
		[[BallStackViewController sharedSingleton] setGame:g];
		[self.navigationController pushViewController:[BallStackViewController sharedSingleton] animated:YES];
	}
}

//- - - Alerts - - -
- (void)alertJoinError {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail"
													message:@"Failed to join game."
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
}

@end
