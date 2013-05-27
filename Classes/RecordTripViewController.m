/** Cycle Atlanta, Copyright 2012, 2013 Georgia Institute of Technology
 *                                    Atlanta, GA. USA
 *
 *   @author Christopher Le Dantec <ledantec@gatech.edu>
 *   @author Anhong Guo <guoanhong@gatech.edu>
 *
 *   Updated/Modified for Atlanta's app deployment. Based on the
 *   CycleTracks codebase for SFCTA.
 *
 ** CycleTracks, Copyright 2009,2010 San Francisco County Transportation Authority
 *                                    San Francisco, CA, USA
 *
 *   @author Matt Paul <mattpaul@mopimp.com>
 *
 *   This file is part of CycleTracks.
 *
 *   CycleTracks is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   CycleTracks is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with CycleTracks.  If not, see <http://www.gnu.org/licenses/>.
 */

//
//  RecordTripViewController.m
//  CycleTracks
//
//  Copyright 2009-2010 SFCTA. All rights reserved.
//  Written by Matt Paul <mattpaul@mopimp.com> on 8/10/09.
//	For more information on the project, 
//	e-mail Billy Charlton at the SFCTA <billy.charlton@sfcta.org>


#import "constants.h"
#import "MapViewController.h"
#import "NoteViewController.h"
#import "PersonalInfoViewController.h"
#import "PickerViewController.h"
#import "RecordTripViewController.h"
#import "ReminderManager.h"
#import "TripManager.h"
#import "NoteManager.h"
#import "Trip.h"
#import "User.h"

//TODO: Fix incomplete implementation
@interface RecordTripViewController ()
@property (nonatomic, retain) UIButton* startStopButton; // our current actual start/stop button

@end
@implementation RecordTripViewController



@synthesize tripManager;// reminderManager;
@synthesize noteManager;
@synthesize infoButton, saveButton, startButton, noteButton, parentView;
@synthesize timer, timeCounter, distCounter;
@synthesize _isRecording, shouldUpdateCounter, userInfoSaved;
@synthesize appDelegate;
@synthesize saveActionSheet;


NSNumberFormatter *nf;

//NSString *kmUnit = @"km";
NSString *km = @"";
//NSString *kmhUnit = @"km/h";
NSString *kmh = @"";

#pragma mark - init and setup methods

- (void)viewDidLoad
{
	NSLog(@"RecordTripViewController viewDidLoad");
    NSLog(@"Bundle ID: %@", [[NSBundle mainBundle] bundleIdentifier]);
    [super viewDidLoad];
    [map setDelegate:self];
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBarHidden = YES;
    
    nf = [[NSNumberFormatter alloc] init];
    
    [nf setLocale:[NSLocale currentLocale]];
    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    [nf setRoundingMode:NSNumberFormatterRoundHalfUp];
    [nf setMaximumFractionDigits:1];
    [nf setMinimumFractionDigits:1];
	
    
    
    //mapview overlays
    
    //    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"mapdata" ofType:@"plist"];
    //    NSArray *arrayArray = [NSArray arrayWithContentsOfFile:thePath];
    //    NSArray *pointsArray = arrayArray[0];
    //    //    NSArray *routesArray = [NSArray alloc
    //
    //     for (int i = 0; i < arrayArray.count; i++) {
    //
    //        pointsArray = arrayArray[i];
    //        NSInteger pointsCount = pointsArray.count;
    //        CLLocationCoordinate2D pointsToUse[pointsCount];
    //        for (int j = 0; j < pointsCount ; j++){
    //            CGPoint p = CGPointFromString(pointsArray[j]);
    //            pointsToUse[j] = CLLocationCoordinate2DMake(p.x, p.y);
    //            //            NSLog(@"pointsToUse=%f,%f", pointsToUse[j].latitude, pointsToUse[j].longitude);
    //            //            NSLog(@"Coordinates (lat:%f, lon:%f)", p.x, p.y);
    //        }
    //         //        NSLog(@"PointsToUseOutOfLoop=%f,%f", pointsToUse[pointsArray.count -1].latitude, pointsToUse[pointsArray.count -1].longitude);
    //        MKPolyline *routePolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
    //         //        NSLog("routePolyLine Length: %@")
    //
    //
    //        //TODO: Implement an array of all polylines and change addOverlay to addOverlays to make this more efficient. Also make bounding box based on routes.
    //        [map addOverlay:routePolyline];
    //        map.visibleMapRect = MKMapRectWorld;
    //         //        map.visibleMapRect = ([routePolyline boundingMapRect]);
    //         //        NSLog(@"overlay added");
    //
    //         //         free(pointsArray);
    //    }
    //    //    free(thePath);
    //    //    free(arrayArray);
    
    //    // init map region to Montreal
	MKCoordinateRegion region = { { 45.553968,-73.664017 }, { 0.0178, 0.0168 } };
	[map setRegion:region animated:NO];
    
	// setup info button used when showing recorded trips
	infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	infoButton.showsTouchWhenHighlighted = YES;
	
	// Set up the buttons.
    [self setupStartButton];
//	[self.view addSubview:[self createStartButton]];
//    [self.view addSubview:[self createNoteButton]];
	
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.isRecording = NO;
	self._isRecording = NO;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey: @"recording"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	self.shouldUpdateCounter = NO;
	
	// Start the location manager.
	[[self getLocationManager] startUpdatingLocation];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // setup the noteManager
    [self initNoteManager:[[[NoteManager alloc] initWithManagedObjectContext:context]autorelease]];
    
	// check if any user data has already been saved and pre-select personal info cell accordingly
	if ( [self hasUserInfoBeenSaved] )
		[self setSaved:YES];
	
	// check for any unsaved trips / interrupted recordings
	[self hasRecordingBeenInterrupted];
    
	NSLog(@"save");
}

- (void)initTripManager:(TripManager*)manager
{
	manager.dirty			= YES;
	self.tripManager		= manager;
    manager.parent          = self;
}


- (void)initNoteManager:(NoteManager*)manager
{
	self.noteManager = manager;
    manager.parent = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // listen for keyboard hide/show notifications so we can properly adjust the table's height
	[super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - CLLocationManagerDelegate methods

- (CLLocationManager *)getLocationManager {
	appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.locationManager != nil) {
        return appDelegate.locationManager;
    }
	
    appDelegate.locationManager = [[[CLLocationManager alloc] init] autorelease];
    appDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    appDelegate.locationManager.delegate = self;
    
    return appDelegate.locationManager;
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
	CLLocationDistance deltaDistance = [newLocation distanceFromLocation:oldLocation];
    
    if (!myLocation) {
        myLocation = [newLocation retain];
    }
    else if ([myLocation distanceFromLocation:newLocation]) {
        [myLocation release];
        myLocation = [newLocation retain];
    }
    
	if ( !didUpdateUserLocation )
	{
		NSLog(@"zooming to current user location");
		MKCoordinateRegion region = { newLocation.coordinate, { 0.0078, 0.0068 } };
		[map setRegion:region animated:YES];

		didUpdateUserLocation = YES;
	}
	
	// only update map if deltaDistance is at least some epsilon
	else if ( deltaDistance > 1.0 )
	{
		//NSLog(@"center map to current user location");
		[map setCenterCoordinate:newLocation.coordinate animated:YES];
	}

	if ( _isRecording )
	{
		// add to CoreData store
		CLLocationDistance distance = [tripManager addCoord:newLocation];
//		self.distCounter.text = [NSString stringWithFormat:@"%.1f km", ];
        double kmDouble = distance/1000;
        
        km = [nf stringFromNumber:[NSNumber numberWithDouble:kmDouble]];
        
//        self.distCounter.text = [[NSArray arrayWithObjects:km, kmUnit, nil] componentsJoinedByString:@" "];
        self.distCounter.text = km;
	}
	
	// 	double mph = ( [trip.distance doubleValue] / 1609.344 ) / ( [trip.duration doubleValue] / 3600. );
    
    if ( newLocation.speed >= 0. ){
        kmh = [nf stringFromNumber:[NSNumber numberWithDouble:newLocation.speed*3.6]];
//		speedCounter.text = [NSString stringWithFormat:@"%.1f km/h", newLocation.speed * 3600 / 1000];
//        speedCounter.text =[[NSArray arrayWithObjects:kmh, kmhUnit, nil] componentsJoinedByString:@" "];
	}
    else{
        kmh = [nf stringFromNumber:[NSNumber numberWithInt:0]];
       
    }
//    speedCounter.text = [[NSArray arrayWithObjects:kmh, kmhUnit, nil] componentsJoinedByString:@" "];
    speedCounter.text = kmh;

}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	NSLog(@"locationManager didFailWithError: %@", error );
}


#pragma mark MKMapViewDelegate methods

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    NSLog(@"MKOverlayView is being called");
    if ([overlay isKindOfClass:MKPolyline.class]) {
        MKPolylineView *lineView = [[MKPolylineView alloc] initWithOverlay:overlay];
        lineView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.9];
        
        return [lineView autorelease];
    }
    
    return nil;
}

- (BOOL)hasUserInfoBeenSaved
{
	BOOL					response = NO;
	NSManagedObjectContext	*context = tripManager.managedObjectContext;
	NSFetchRequest			*request = [[NSFetchRequest alloc] init];
	NSEntityDescription		*entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
	[request setEntity:entity];
	
	NSError *error;
	NSInteger count = [context countForFetchRequest:request error:&error];
	//NSLog(@"saved user count  = %d", count);
	if ( count )
	{	
		NSArray *fetchResults = [context executeFetchRequest:request error:&error];
		if ( fetchResults != nil )
		{
			User *user = (User*)[fetchResults objectAtIndex:0];
			if (user			!= nil &&
				(user.age		!= nil ||
				 user.gender	!= nil ||
				 user.email		!= nil ||
				 user.homeZIP	!= nil ||
				 user.workZIP	!= nil ||
				 user.schoolZIP	!= nil ||
				 ([user.cyclingFreq intValue] < 4 )))
			{
				NSLog(@"found saved user info");
				self.userInfoSaved = YES;
				response = YES;
			}
			else
				NSLog(@"no saved user info");
		}
		else
		{
			// Handle the error.
			NSLog(@"no saved user");
			if ( error != nil )
				NSLog(@"PersonalInfo viewDidLoad fetch error %@, %@", error, [error localizedDescription]);
		}
	}
	else
		NSLog(@"no saved user");
	
	[request release];
	return response;
}


- (void)hasRecordingBeenInterrupted
{
	if ( [tripManager countUnSavedTrips] )
	{        
        [self resetRecordingInProgress];
	}
	else
		NSLog(@"no unsaved trips found");
}


- (void)infoAction:(id)sender
{
	if ( !_isRecording )
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: kInfoURL]];
}

#pragma mark - setting up UI elements


-(void)setupStartButton{
//    the button set up in interface builder is now being used as a placeholder.
//    It should eventually be removed.
    
#define BUTTON_SIZE 100.0 // height and width;
#define BUTTON_PADDING_BOTTOM 64.0
    // to conform with preexisting layout, button should be 46px from bottom of parent view
    
    self.startStopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startStopButton.frame = CGRectMake((self.view.bounds.size.width/2) - (BUTTON_SIZE/2),
                                   (self.view.bounds.size.height - BUTTON_SIZE - BUTTON_PADDING_BOTTOM),
                                   BUTTON_SIZE,
                                   BUTTON_SIZE);
    [self setToStartMode];
    [self.view addSubview:self.startStopButton];

}

-(void)setToStartMode{
    // a really nasty way of doing this but will work for now
    // this should really just be stored in a property, to save us from having to pass it around
//    this is going to animate a quick fade out before switching images and animating a quick fade in
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.startStopButton.alpha = 0.2;
                     } completion:^(BOOL finished) {
                         [self.startStopButton setBackgroundImage:[UIImage imageNamed:@"startbutton.png"]
                                           forState:UIControlStateNormal];
                         [self.startStopButton setBackgroundImage:[UIImage imageNamed:@"startbuttonpressed.png"]
                                           forState:UIControlStateHighlighted];
                         [self.startStopButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
                         [self.startStopButton addTarget:self
                                    action:@selector(startButtonPressed:)
                          forControlEvents:UIControlEventTouchUpInside];
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.startStopButton.alpha = 1.0;
                                          }];
                     }];
    }

-(void)setToStopMode{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.startStopButton.alpha = 0.2;
                     } completion:^(BOOL finished) {
                         [self.startStopButton setBackgroundImage:[UIImage imageNamed:@"stopbutton"]
                                           forState:UIControlStateNormal];
                         [self.startStopButton setBackgroundImage:[UIImage imageNamed:@"stopbuttonpressed"]
                                           forState:UIControlStateHighlighted];
                         [self.startStopButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
                         [self.startStopButton addTarget:self
                                    action:@selector(stopButtonPressed:)
                          forControlEvents:UIControlEventTouchUpInside];
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.startStopButton.alpha = 1.0;
                                          }];
                     }];

}

//these two methods appear to be unnecessary, as buttons were already added in IB.
//- (UIButton *)createNoteButton
//{
//    UIImage *buttonImage = [[UIImage imageNamed:@"whiteButton.png"]
//                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
//    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"whiteButtonHighlight.png"]
//                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
//    
//    [noteButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [noteButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
//    [noteButton setTitleColor:[[[UIColor alloc] initWithRed:185.0 / 255 green:91.0 / 255 blue:47.0 / 255 alpha:1.0 ] autorelease] forState:UIControlStateHighlighted];
//    
////    noteButton.backgroundColor = [UIColor clearColor];
//    noteButton.enabled = NO;
//    
//    [noteButton setTitle:@"Note this..." forState:UIControlStateNormal];
//
////    noteButton.titleLabel.font = [UIFont boldSystemFontOfSize: 24];
//    [noteButton addTarget:self action:@selector(notethis:) forControlEvents:UIControlEventTouchUpInside];
//    
//	return noteButton;
//    
//}


#pragma mark - handling user actions
// handle start button action
- (IBAction)startButtonPressed:(UIButton *)sender
{
//    this is going to have to do a couple things: change the buttons appearance,
//    remove the old and add a new target/action, and starting recording.
    assert(_isRecording == NO);
    [self startRecording];
    [self setToStopMode];
}

-(void)stopButtonPressed:(UIButton*)sender{
        assert(_isRecording == YES);
    NSLog(@"User Press Save Button");
    saveActionSheet = [[UIActionSheet alloc]
                       initWithTitle:@""
                       delegate:self
                       cancelButtonTitle:NSLocalizedString(@"Continue", @"Continue")
                       destructiveButtonTitle:NSLocalizedString(@"Discard", @"Discard")
                       otherButtonTitles:NSLocalizedString(@"Save", @"Save"),nil];
    //[saveActionSheet showInView:self.view];
    [saveActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}
-(void)startRecording{
//    handle starting a new recording

    NSLog(@"starting recording");
    if ( timer == nil )
    {
        [self resetCounter];
        timer = [NSTimer scheduledTimerWithTimeInterval:kCounterTimeInterval
                                                 target:self selector:@selector(updateCounter:)
                                               userInfo:[self newTripTimerUserInfo] repeats:YES];
    }
    // set recording flag so future location updates will be added as coords
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.isRecording = YES;
    _isRecording = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey: @"recording"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // set flag to update counter
    shouldUpdateCounter = YES;

    
}
- (void)saveAction
{
	[[NSUserDefaults standardUserDefaults] setInteger:0 forKey: @"pickerCategory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	// go directly to TripPurpose, user can cancel from there
	if ( YES ) //WHAT THE F   IS THIS
	{
		// Trip Purpose
		NSLog(@"INIT + PUSH");
		PickerViewController *tripPurposePickerView = [[PickerViewController alloc]
                                                       //initWithPurpose:[tripManager getPurposeIndex]];
                                                       initWithNibName:@"TripPurposePicker" bundle:nil];
		[tripPurposePickerView setDelegate:self];
		//[[self navigationController] pushViewController:pickerViewController animated:YES];
		[self.navigationController presentModalViewController:tripPurposePickerView animated:YES];
		[tripPurposePickerView release];
	}

	// prompt to confirm first
	else
	{
		// pause updating the counter
		shouldUpdateCounter = NO;
		
		// construct purpose confirmation string
		NSString *purpose = nil;
		if ( tripManager != nil )
			purpose = [self getPurposeString:[tripManager getPurposeIndex]];
		
		NSString *confirm = [NSString stringWithFormat:NSLocalizedString(@"Stop recording & save this trip?", nil)];
		
		// present action sheet
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:confirm
																 delegate:self
														cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
												   destructiveButtonTitle:nil
														otherButtonTitles:NSLocalizedString(@"Save", @"Save"), nil];
		
		actionSheet.actionSheetStyle		= UIActionSheetStyleBlackTranslucent;
		UIViewController *pvc = self.parentViewController;
		UITabBarController *tbc = (UITabBarController *)pvc.parentViewController;
		
		[actionSheet showFromTabBar:tbc.tabBar];
		[actionSheet release];
	}
    
}

//TODO: where does this go?
-(IBAction)notethis:(id)sender{
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey: @"pickerCategory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"Note This");
    
    [noteManager createNote];
    
    if (myLocation){
        [noteManager addLocation:myLocation];
    }
	
	// go directly to TripPurpose, user can cancel from there
	if ( YES )
	{
		// Trip Purpose
		NSLog(@"INIT + PUSH");
        
        
		PickerViewController *notePickerView = [[PickerViewController alloc]
                                                //initWithPurpose:[tripManager getPurposeIndex]];
                                                initWithNibName:@"TripPurposePicker" bundle:nil];
		[notePickerView setDelegate:self];
		//[[self navigationController] pushViewController:pickerViewController animated:YES];
		[self.navigationController presentModalViewController:notePickerView animated:YES];
        
        //add location information
        
		[notePickerView release];
	}
	
	// prompt to confirm first
	else
	{
		// pause updating the counter
		shouldUpdateCounter = NO;
		
		// construct purpose confirmation string
		NSString *purpose = nil;
		if ( tripManager != nil )
			purpose = [self getPurposeString:[tripManager getPurposeIndex]];
		
		NSString *confirm = [NSString stringWithFormat:NSLocalizedString(@"Stop recording & save this trip?", nil)];
		
		// present action sheet
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:confirm
																 delegate:self
														cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
												   destructiveButtonTitle:nil
														otherButtonTitles:NSLocalizedString(@"Save", @"Save"), nil];
		
		actionSheet.actionSheetStyle		= UIActionSheetStyleBlackTranslucent;
		UIViewController *pvc = self.parentViewController;
		UITabBarController *tbc = (UITabBarController *)pvc.parentViewController;
		
		[actionSheet showFromTabBar:tbc.tabBar];
		[actionSheet release];
	}
}

#pragma mark - recording and timer handling
- (void)resetTimer
{
	// invalidate timer
	if ( timer )
	{
		[timer invalidate];
		//[timer release];
		timer = nil;
	}
}

- (void)resetRecordingInProgress
{
	// reset button states
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.isRecording = NO;
	_isRecording = NO;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey: @"recording"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setToStartMode];
	
	// reset trip, reminder managers
	NSManagedObjectContext *context = tripManager.managedObjectContext;
	[self initTripManager:[[[TripManager alloc] initWithManagedObjectContext:context] autorelease]];
	tripManager.dirty = YES;

	[self resetCounter];
	[self resetTimer];
}

- (NSDictionary *)newTripTimerUserInfo
{
    return [[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], @"StartDate",
             tripManager, @"TripManager", nil ] retain ];
}


//- (NSDictionary *)continueTripTimerUserInfo
//{
//	if ( tripManager.trip && tripManager.trip.start )
//		return [NSDictionary dictionaryWithObjectsAndKeys:tripManager.trip.start, @"StartDate",
//				tripManager, @"TripManager", nil ];
//	else {
//		NSLog(@"WARNING: tried to continue trip timer but failed to get trip.start date");
//		return [self newTripTimerUserInfo];
//	}
//	
//}




#pragma mark - counter handling methods
- (void)resetCounter
{
	if ( timeCounter != nil )
		timeCounter.text = @"00:00:00";
	
	if ( distCounter != nil ){
        
        km = [nf stringFromNumber:[NSNumber numberWithInt:0]];
        //		distCounter.text = [[NSArray arrayWithObjects:km, kmUnit, nil] componentsJoinedByString:@" "];
        distCounter.text = km;
    }
}


- (void)setCounterTimeSince:(NSDate *)startDate distance:(CLLocationDistance)distance
{
 	if ( timeCounter != nil )
	{
		NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startDate];
		
		static NSDateFormatter *inputFormatter = nil;
		if ( inputFormatter == nil )
			inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
		
		[inputFormatter setDateFormat:@"HH:mm:ss"];
		NSDate *fauxDate = [inputFormatter dateFromString:@"00:00:00"];
		[inputFormatter setDateFormat:@"HH:mm:ss"];
		NSDate *outputDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:fauxDate] autorelease];
		
		timeCounter.text = [inputFormatter stringFromDate:outputDate];
	}
	
	if ( distCounter != nil ){
        km = [nf stringFromNumber:[NSNumber numberWithInt:0]];
        //		distCounter.text = [[NSArray arrayWithObjects:kmh, kmhUnit, nil] componentsJoinedByString:@" "];
        distCounter.text = km;
    }
}


// handle start button action
- (void)updateCounter:(NSTimer *)theTimer
{
	//NSLog(@"updateCounter");
	if ( shouldUpdateCounter )
	{
		NSDate *startDate = [[theTimer userInfo] objectForKey:@"StartDate"];
		NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startDate];
        
		static NSDateFormatter *inputFormatter = nil;
		if ( inputFormatter == nil )
			inputFormatter = [[NSDateFormatter alloc] init];
		
		[inputFormatter setDateFormat:@"HH:mm:ss"];
		NSDate *fauxDate = [inputFormatter dateFromString:@"00:00:00"];
		[inputFormatter setDateFormat:@"HH:mm:ss"];
		NSDate *outputDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:fauxDate] autorelease];
		
		//NSLog(@"Timer started on %@", startDate);
		//NSLog(@"Timer started %f seconds ago", interval);
		//NSLog(@"elapsed time: %@", [inputFormatter stringFromDate:outputDate] );
		
		//self.timeCounter.text = [NSString stringWithFormat:@"%.1f sec", interval];
		self.timeCounter.text = [inputFormatter stringFromDate:outputDate];
	}
    
}


#pragma mark UIActionSheet delegate methods


// NOTE: implement didDismissWithButtonIndex to process after sheet has been dismissed
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSLog(@"actionSheet clickedButtonAtIndex %d", buttonIndex);
	switch ( buttonIndex )
	{			
           case 0:
           {
               NSLog(@"Discard!!!!");
               [self resetRecordingInProgress];
               //discard that trip
               break;
           }
        case 1:{
            [self saveAction];
            break;
        }
		default:{
			NSLog(@"Cancel");
			// re-enable counter updates
			shouldUpdateCounter = YES;
			break;
        }
	}
}

// called if the system cancels the action sheet (e.g. homescreen button has been pressed)
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	NSLog(@"actionSheetCancel");
}


#pragma mark UIAlertViewDelegate methods

// NOTE: method called upon closing save error / success alert
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	switch (alertView.tag) {
		case 101:
		{
			NSLog(@"recording interrupted didDismissWithButtonIndex: %d", buttonIndex);
			switch (buttonIndex) {
				case 0:
					// new trip => do nothing
					break;
				case 1:
				default:
					// continue => load most recent unsaved trip
					[tripManager loadMostRecetUnSavedTrip];
					
					// update UI to reflect trip once loading has completed
					[self setCounterTimeSince:tripManager.trip.start
									 distance:[tripManager getDistanceEstimate]];

					startButton.enabled = YES;

                    [startButton setTitle:NSLocalizedString(@"Continue", @"Continue") forState:UIControlStateNormal];
					break;
			}
		}
			break;
		default:
		{
			NSLog(@"saving didDismissWithButtonIndex: %d", buttonIndex);
			
			// keep a pointer to our trip to pass to map view below
			Trip *trip = tripManager.trip;
			[self resetRecordingInProgress];
			
			// load map view of saved trip
			MapViewController *mvc = [[MapViewController alloc] initWithTrip:trip];
			[[self navigationController] pushViewController:mvc animated:YES];
			[mvc release];
		}
			break;
	}
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
	NSLog(@"keyboardWillShow");
}


- (void)keyboardWillHide:(NSNotification *)aNotification
{
	NSLog(@"keyboardWillHide");
}



#pragma mark UINavigationController


- (void)navigationController:(UINavigationController *)navigationController 
	   willShowViewController:(UIViewController *)viewController 
					animated:(BOOL)animated
{
	if ( viewController == self )
	{
		//NSLog(@"willShowViewController:self");
		self.title = NSLocalizedString(@"Record New Trip", nil);
	}
	else
	{
		//NSLog(@"willShowViewController:else");
		self.title = NSLocalizedString(@"Back", @"Back");
		self.tabBarItem.title = NSLocalizedString(@"Record New Trip", nil); // important to maintain the same tab item title
	}
}


#pragma mark UITabBarControllerDelegate


- (BOOL)tabBarController:(UITabBarController *)tabBarController 
shouldSelectViewController:(UIViewController *)viewController
{
		return YES;		
}


#pragma mark PersonalInfoDelegate methods


- (void)setSaved:(BOOL)value
{
	NSLog(@"setSaved");
	// no-op

}

#pragma mark - report finalizing methods

- (void)displayUploadedTripMap
{
    Trip *trip = tripManager.trip;
    [self resetRecordingInProgress];
    
    // load map view of saved trip
    MapViewController *mvc = [[MapViewController alloc] initWithTrip:trip];
    [[self navigationController] pushViewController:mvc animated:YES];
    NSLog(@"displayUploadedTripMap");
    [mvc release];
}


- (void)displayUploadedNote
{
    Note *note = noteManager.note;
    
    // load map view of note
    NoteViewController *mvc = [[NoteViewController alloc] initWithNote:note];
    [[self navigationController] pushViewController:mvc animated:YES];
    NSLog(@"displayUploadedNote");
    [mvc release];
}

//TODO: should this just be part of setPurpose: (below)
- (NSString *)updatePurposeWithString:(NSString *)purpose
{
	// only enable start button if we don't already have a pending trip
	if ( timer == nil )
		startButton.enabled = YES;
	
	startButton.hidden = NO;
	
	return purpose;
}


- (NSString *)updatePurposeWithIndex:(unsigned int)index
{
	return [self updatePurposeWithString:[tripManager getPurposeString:index]];
}

#pragma mark TripPurposeDelegate methods


- (NSString *)setPurpose:(unsigned int)index
{
	NSString *purpose = [tripManager setPurpose:index];
	NSLog(@"setPurpose: %@", purpose);

	//[self.navigationController popViewControllerAnimated:YES];
	
	return [self updatePurposeWithString:purpose];
}


- (NSString *)getPurposeString:(unsigned int)index
{
	return [tripManager getPurposeString:index];
}


- (void)didCancelPurpose
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.isRecording = YES;
	_isRecording = YES;
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey: @"recording"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	shouldUpdateCounter = YES;
}


- (void)didCancelNote
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
    appDelegate = [[UIApplication sharedApplication] delegate];
}


- (void)didPickPurpose:(unsigned int)index
{
	//[self.navigationController dismissModalViewControllerAnimated:YES];
	// update UI
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.isRecording = NO;
	_isRecording = NO;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey: @"recording"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	startButton.enabled = YES;
	[self resetTimer];
	
	[tripManager setPurpose:index];
	//[tripManager promptForTripNotes];
    //do something here: may change to be the save as a separate view. Not prompt.
}

- (void)didEnterTripDetails:(NSString *)details{
    [tripManager saveNotes:details];
    NSLog(@"Trip Added details: %@",details);
}

- (void)saveTrip{
    [tripManager saveTrip];
    NSLog(@"Save trip");
}

- (void)didPickNoteType:(NSNumber *)index
{	
	[noteManager.note setNote_type:index];
    NSLog(@"Added note type: %d", [noteManager.note.note_type intValue]);
    //do something here: may change to be the save as a separate view. Not prompt.
}

- (void)didEnterNoteDetails:(NSString *)details{
    [noteManager.note setDetails:details];
    NSLog(@"Note Added details: %@", noteManager.note.details);
}

- (void)didSaveImage:(NSData *)imgData{
    [noteManager.note setImage_data:imgData];
    NSLog(@"Added image, Size of Image(bytes):%d", [imgData length]);
    [imgData release];
}

- (void)getTripThumbnail:(NSData *)imgData{
    [tripManager.trip setThumbnail:imgData];
    NSLog(@"Trip Thumbnail, Size of Image(bytes):%d", [imgData length]);
}

- (void)getNoteThumbnail:(NSData *)imgData{
    [noteManager.note setThumbnail:imgData];
    NSLog(@"Note Thumbnail, Size of Image(bytes):%d", [imgData length]);
}

- (void)saveNote{
    [noteManager saveNote];
    NSLog(@"Save note");
}


#pragma mark RecordingInProgressDelegate method


- (Trip *)getRecordingInProgress
{
	if ( _isRecording )
		return tripManager.trip;
	else
		return nil;
}


- (void)dealloc {
    
    appDelegate.locationManager = nil;
    self.startStopButton = nil;
    self.startButton = nil;
    self.infoButton = nil;
    self.saveButton = nil;
    self.noteButton = nil;
    self.timeCounter = nil;
    self.distCounter = nil;
    self.saveActionSheet = nil;
    self.timer = nil;
    self.parentView = nil;
    self._isRecording = nil;
    self.shouldUpdateCounter = nil;
    self.userInfoSaved = nil;
    self.tripManager = nil;
    self.noteManager = nil;
    self.appDelegate = nil;
    km = nil;
    kmh = nil;
//    kmhUnit=nil;
//    kmhUnit=nil;
    
//    [appDelegate.locationManager release];
    [appDelegate release];
    [infoButton release];
    [saveButton release];
    [startButton release];
    [_startStopButton release];
    [noteButton release];
    [timeCounter release];
    [distCounter release];
    [speedCounter release];
    [saveActionSheet release];
    [timer release];
    [opacityMask release];
    [parentView release];
    [tripManager release];
    [noteManager release];
    [myLocation release];
    
    [managedObjectContext release];
    [map release];
    
    [super dealloc];
}

@end