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
#define kConnectionError	@"Problème avec le serveur, \n essayez plus tard."
#define kServerError		@"Telechargement pas completé, \n essayez plus tard."

// alert titles
#define kBatteryTitle		@"Batterie faible"
#define kRetryTitle			@"Synchroniser maintenant?"
#define	kSavingTitle		@"Téléchargement en course"
#define kSavingNoteTitle    @"Téléchargement du note en course"
#define kSuccessTitle		@"Téléchargement complet"
#define kTripNotesTitle		@"Commentaires"
#define kConsentFor18Title  @"Il faut être 18 ans ou plus pour envoyer les trajets a Mon RésoVélo."


#define kInterruptedTitle		@"Enregistrement interrompu"
#define kInterruptedMessage		@""
#define kUnsyncedTitle			@"Trajets à envoyer"
#define kUnsyncedMessage		@"Il y a au moins un trajet prêt à télécharger"
#define kZeroDistanceTitle		@"Nouveau calcul de la distance parcourue"
#define kZeroDistanceMessage	@"Voulez-vous recalculer la distance parcourue pour chaque trajet?"

// alert messages
#define kConsentFor18Message @"Avez-vous au moins 18 ans?"
#define kBatteryMessage		@"Enregistrement de votre trajet interrompu pour éviter le déchargement de la batterie."
#define kConnecting			@"Connexion au serveur"
#define kPreparingData		@"Préparation des données"
#define kRetryMessage		@"Problème de téléchargement. Essayez à nouveau?"
#define kSaveSuccess		@"Téléchargement des trajets réussi"
#define kSaveAccepted		@"Ce trajet est déja synchronisé"
#define kSaveError			@"Téléchargement non effectué. Prochain essai lors de votre prochain trajet"

#define kInfoURL			@"http://cycleatlanta.org/CycleAtlantaInfo"
#define kInstructionsURL	@"http://cycleatlanta.org/instructions-v2/"

#define kSaveURL			@"http://ks3309217.kimsufi.com/monresovelo/post/"
//#define kSaveURL			@""

#define kTripNotesPlaceholder	@"Commentaires"

// CustomView metrics used by UIPickerViewDataSource, UIPickerViewDelegate
#define MAIN_FONT_SIZE		18
#define MIN_MAIN_FONT_SIZE	16

