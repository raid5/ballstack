//
//  JoinGameViewController.h
//  BallStack
//
//  Created by Adam McDonald on 11/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GEViewController.h"
#import "GENetworkProtocol.h"

@interface JoinGameViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource> {

@private
	//BOOL gameListLoaded;
	UITextField *gameField;
	UITableView *gameTable;
	NSMutableArray *games;
	NSTimer *refreshTimer;
}

//@property (nonatomic, assign) BOOL gameListLoaded;
@property (nonatomic, retain) IBOutlet UITextField *gameField;
@property (nonatomic, retain) IBOutlet UITableView *gameTable;
@property (nonatomic, retain) NSMutableArray *games;
@property (nonatomic, retain) NSTimer *refreshTimer;

//- (IBAction)join:(id)sender;

@end
