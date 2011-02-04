//
//  JoinGameViewController.m
//  BallStack
//
//  Created by Adam McDonald on 11/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "JoinGameViewController.h"
#import "BallStackViewController.h"
#import "Game.h"
#import "GameCell.h"
#import "Player.h"
#import "PlayerFactory.h"
#import "GENetworkManager.h"
#import "NetworkConstants.h"

#define INITIAL_GAMES_CAPACITY 10
#define REFRESH_INTERVAL 2

// A class extension to declare private methods
@interface JoinGameViewController ()

- (void)loadGames;
- (void)stopRefreshTimer;
- (void)joinGame:(int)gameId;
- (void)handleJoinGameResponse:(NSArray *)response;
- (void)handleListGamesResponse:(NSArray *)response;
- (void)alertJoinError;
- (void)home;

@end

@implementation JoinGameViewController

//@synthesize gameListLoaded;
@synthesize gameField, gameTable, games, refreshTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.title = @"Games";
		
		//gameListLoaded = NO;

		/*
		Game *fakeGame = [[Game alloc] initWithGameId:TEST_GAMEID
										titled:@"No active games"
								withMaxPlayers:-1
							 withJoinedPlayers:-1
								   gStartingIn:-1];
		 
		games = [[NSMutableArray alloc] initWithObjects:fakeGame, nil];
		*/
		
		games = [[NSMutableArray alloc] initWithCapacity:INITIAL_GAMES_CAPACITY];
		
		// Home button
		UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[homeButton setFrame:CGRectMake(5.0, 423.0, 52.0, 52.0)];
		[homeButton setBackgroundImage:[UIImage imageNamed:@"homebutton.png"] forState:UIControlStateNormal];
		[homeButton addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
		[[self view] addSubview:homeButton];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	/*
	// Game list refresh button
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshGames)];
	self.navigationItem.rightBarButtonItem = refresh;
	[refresh release];
	*/
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	// Load active games ( if not already done )
	//if ( !gameListLoaded ) [self loadGames];
	[self loadGames];
	
	// Setup refresh timer (after first load)
	refreshTimer = [NSTimer scheduledTimerWithTimeInterval:REFRESH_INTERVAL target:self selector:@selector(loadGames) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self stopRefreshTimer];
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
	[games release];
    [super dealloc];
}

- (void)home {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)loadGames {
	NSLog(@"Loading game listing ...");
	
	//#- TODO Display spinner here?
	
	// Clear list
	[games removeAllObjects];
	
	// Add placeholder
	Game *fakeGame = [[Game alloc] initWithGameId:TEST_GAMEID
										   titled:@"No active games"
								   withMaxPlayers:-1
								withJoinedPlayers:-1
									  gStartingIn:-1];
	
	[games addObject:fakeGame];
	[fakeGame release];
	
	// Send server game list message
	NSString *msg = [NSString stringWithFormat:@"%d", BSMessageListGames];
	[[GENetworkManager sharedSingleton] sendMessage:msg];
}

- (void)stopRefreshTimer {
	// Stop game refresh timer
	if ( refreshTimer != nil ) {
		[refreshTimer invalidate];
		refreshTimer = nil;
	}
}

/*
- (void)refreshGames {
	// Display spinner ?
	
	// Clear list
	[games removeAllObjects];
	
	// Re-add placeholder
	Game *fakeGame = [[Game alloc] initWithGameId:TEST_GAMEID
										   titled:@"No active games"
								   withMaxPlayers:-1
								withJoinedPlayers:-1
									  gStartingIn:-1];
	
	[games addObject:fakeGame];
	
	// Reload
	[self loadGames];
}

- (IBAction)join:(id)sender {
	NSString *gameStr = [gameField text];
	if ( gameStr && [gameStr length] > 0 ) [self joinGame:[gameStr intValue]];
}
*/

- (void)joinGame:(int)gameId {
	NSLog(@"Join Game: %d", gameId);
	
	NSString *msg = [NSString stringWithFormat:@"%d;%d", BSMessageJoinGame, gameId];
	[[GENetworkManager sharedSingleton] sendMessage:msg];
}

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
			[self handleJoinGameResponse:msgData];
			break;
		case BSMessageListGames:
			NSLog(@"[BSMessageListGames]");
			[self handleListGamesResponse:msgData];
			break;
		default:
			break;
	}
}

- (void)handleJoinGameResponse:(NSArray *)response {
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

- (void)handleListGamesResponse:(NSArray *)response {
	int rCount = [response count];
	if ( rCount > 1 ) {
		//gameListLoaded = YES;
		gameTable.scrollEnabled = YES;
		
		// Clear data arrays
		[games removeAllObjects];
		
		// Fill data arrays
		// gameid ; max_players ; joined_players ; seconds_till_starts
		for ( int i = 1; i < rCount; (i += BSMESSAGE_LISTGAMES_TUPLE_SIZE) ) {
			Game *g = [[Game alloc] initWithGameId:[[response objectAtIndex:i] intValue]
											titled:[response objectAtIndex:(i+1)]
								   withMaxPlayers:[[response objectAtIndex:(i+2)] intValue]
								withJoinedPlayers:[[response objectAtIndex:(i+3)] intValue]
									  gStartingIn:[[response objectAtIndex:(i+4)] intValue]];
			
			[games addObject:g];
			[g release];
		}
	} else {
		NSLog(@"No active games to list.");
		gameTable.scrollEnabled = NO;
	}
	
	// Reload TableView
	[gameTable reloadData];
}

//-- Table Delegate and Data Source Methods --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	int index = indexPath.row;
	Game *g = [games objectAtIndex:index];
	NSString *displayText = [g title];
	
	GameCell *cell;
	if ( [displayText isEqualToString:@"No active games"] ) {
		// No games, use standard TableViewCell
		NSLog(@"NO GAMES");
		
		cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
		cell.textLabel.text = displayText;
		cell.textLabel.textColor = [UIColor colorWithRed:0.68 green:0.14 blue:0.18 alpha:1.0];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
	} else {
		// Games exist, use custom game cell
		NSLog(@"GAMES");
		
		cell = [[GameCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
		
		if ( [g isFull] || [g secondsUntilStart] == 0 ) {
			cell.imageView.image = [UIImage imageNamed:@"red.png"];
		} else {
			cell.imageView.image = [UIImage imageNamed:@"green.png"];
		}
		
		[[cell title] setText:displayText];
		
		NSString *statusText = [NSString stringWithFormat:@"%d / %d", [g joinedPlayers], [g maxPlayers]];
		[[cell status] setText:statusText];
		
		NSString *secondsText = [NSString stringWithFormat:@"%ds", [g secondsUntilStart]];
		[[cell seconds] setText:secondsText];		
	}
	
	return [cell autorelease];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil];
	
	int index = indexPath.row;
	NSString *displayText = [[games objectAtIndex:index] title];
	cell.text = displayText;
	
	if ( [displayText isEqualToString:@"No active games"] ) {
		// no games
		cell.textColor = [UIColor colorWithRed:0.68 green:0.14 blue:0.18 alpha:1.0];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return [cell autorelease];
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	int index = indexPath.row;
	
	if ( ![[[games objectAtIndex:index] title] isEqualToString:@"No active games"] ) {
		NSLog(@"Selected: %d", [[games objectAtIndex:index] gameId]);
		[self joinGame:[[games objectAtIndex:index] gameId]];		
		[tableView deselectRowAtIndexPath:indexPath	animated:YES];
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

//- - - TextField Delegate Methods - - -
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	//#- [gameField resignFirstResponder];
	[textField resignFirstResponder];
	return YES;
}

@end
