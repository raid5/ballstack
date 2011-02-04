//
//  BallStackAppDelegate.m
//  BallStack
//
//  Created by Adam McDonald on 11/9/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "BallStackAppDelegate.h"
#import "GENetworkManager.h"
#import "NetworkConstants.h"

@implementation BallStackAppDelegate

@synthesize window, navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
	
	[window addSubview:navigationController.view];
    [window makeKeyAndVisible];
	
	// Setup Network Manager
	[[GENetworkManager sharedSingleton] initSocketWithIP:SERVER_IP onPort:SERVER_PORT];
	
	sleep(1); // sleep 2s to display splash screen
}

- (void)dealloc {
	[navigationController release];
    [window release];
    [super dealloc];
}

@end
