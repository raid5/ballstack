//
//  CreateGameViewController.h
//  BallStack
//
//  Created by Adam McDonald on 11/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GEViewController.h"
#import "GENetworkProtocol.h"

@interface CreateGameViewController : GEViewController <UITextFieldDelegate, UIAlertViewDelegate> {

@private
	UITextField *nameField;
	UISegmentedControl *playerSegment;
}

@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UISegmentedControl *playerSegment;

//- (IBAction)createGame:(id)sender;

@end
