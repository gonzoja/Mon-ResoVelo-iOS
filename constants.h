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
//  constants.h
//  CycleTracks
//
//  Copyright 2009-2010 SFCTA. All rights reserved.
//  Written by Matt Paul <mattpaul@mopimp.com> on 8/25/09.
//	For more information on the project, 
//	e-mail Billy Charlton at the SFCTA <billy.charlton@sfcta.org>


#define kActionSheetButtonConfirm	0
#define kActionSheetButtonChange	1
#define kActionSheetButtonDiscard	2
#define kActionSheetButtonCancel	3

#define kActivityIndicatorSize	20.0

#define kCounterTimeInterval	0.5

#define kCustomButtonWidth		136.0
#define kCustomButtonHeight		48.0

#define kCounterFontSize		26.0
#define kMinimumFontSize		16.0

#define kStdButtonWidth			106.0
#define kStdButtonHeight		40.0

#define kJpegQuality        0.9

// error messages
#define kConnectionError	NSLocalizedString(@"Server unreachable, \n try again later.", nil)
#define kServerError		NSLocalizedString(@"Upload failed, \n try again later.", nil)

// alert titles
#define kBatteryTitle		NSLocalizedString(@"Battery Low", nil)
#define kRetryTitle			NSLocalizedString(@"Retry Upload?", nil)
#define	kSavingTitle		NSLocalizedString(@"Uploading your trip", nil)
#define kSavingNoteTitle    NSLocalizedString(@"Uploading your note", nil)
#define kSuccessTitle		NSLocalizedString(@"Upload complete", nil)
#define kTripNotesTitle		NSLocalizedString(@"Enter Comments Below", nil)
#define kConsentFor18Title  NSLocalizedString(@"In order to send route data to Mon RésoVélo you must be at least 18.", nil)


#define kInterruptedTitle		NSLocalizedString(@"Recording Interrupted", nil)
#define kInterruptedMessage		NSLocalizedString(@"Oops! Looks like a previous trip recording has been interrupted.", nil)
#define kUnsyncedTitle			NSLocalizedString(@"Found Unsynced Trip(s)", nil)
#define kUnsyncedMessage		NSLocalizedString(@"You have at least one saved trip that has not yet been uploaded.", nil)
#define kZeroDistanceTitle		NSLocalizedString(@"Recalculate Trip Distance?", nil)
#define kZeroDistanceMessage	NSLocalizedString(@"Your trip distance estimates may need to be recalculated...", nil)

// alert messages
#define kConsentFor18Message NSLocalizedString(@"Are you at least 18 years old?", nil)
#define kBatteryMessage		NSLocalizedString(@"Recording of your trip has been halted to preserve battery life.", nil)
#define kConnecting			NSLocalizedString(@"Contacting server...", nil)
#define kPreparingData		NSLocalizedString(@"Preparing your trip data for transfer.", nil)
#define kRetryMessage		NSLocalizedString(@"This trip has not yet been uploaded successfully. Try again?", nil)
#define kSaveSuccess		NSLocalizedString(@"Your trip has been uploaded successfully. Thank you.", nil)
#define kSaveAccepted		NSLocalizedString(@"Your trip has already been uploaded. Thank you.", nil)
#define kSaveError			NSLocalizedString(@"Your trip has been saved. Please try uploading again later.", nil)

#define kInfoURL			NSLocalizedString(@"http://ville.montreal.qc.ca/resovelo", nil)
#define kInstructionsURL	NSLocalizedString(@"http://ville.montreal.qc.ca/resovelo/aide", nil)

#define kSaveURL			NSLocalizedString(@"http://donnees.monresovelo.ca/post/index.php", nil)
//#define kSaveURL			NSLocalizedString(@""

#define kTripNotesPlaceholder	NSLocalizedString(@"Comments", nil)

#define kGHGMessage         NSLocalizedString(@"Emisssions saved: ", nil)
#define kCaloriesMessage    NSLocalizedString(@"Calories burned: ", nil)

// CustomView metrics used by UIPickerViewDataSource, UIPickerViewDelegate
#define MAIN_FONT_SIZE		18
#define MIN_MAIN_FONT_SIZE	16

