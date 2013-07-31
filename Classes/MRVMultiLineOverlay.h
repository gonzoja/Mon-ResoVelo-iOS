//
//  TSTMultiLineOverlay.h
//  overlayTests
//
//  Created by Colin Rothfels on 2013-05-28.
//  Copyright (c) 2013 cmyr. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MRVMultiLineOverlay : NSObject <MKOverlay>
//@property (nonatomic, readonly) MKMapRect boundingMapRect;
-(id)initWithPlist:(NSString*)path;

@property (readonly) MKMapPoint *points;
@property (readonly) NSInteger segmentCount;
@property (readonly) NSInteger *segmentLengths;

@property (nonatomic, readonly) MKMapRect boundingMapRect;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


// properties related to drawing:
@property (nonatomic, readonly) BOOL drawDashed;
@property (strong, nonatomic) UIColor* strokeColor;
@property (nonatomic) CGFloat strokeWidthModifier;
@property (nonatomic, readonly) CGFloat dashPhase;
@property (nonatomic, readonly) size_t dashLengthsCount;
@property (nonatomic, readonly) CGFloat* dashLengths;

//-(void)setLineDashPhase:(CGFloat)phase lengths:(CGFloat*)lengths count:(size_t)count;

@end

