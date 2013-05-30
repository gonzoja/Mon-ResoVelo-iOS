//
//  TSTMultiLineOverlay.h
//  overlayTests
//
//  Created by Colin Rothfels on 2013-05-28.
//  Copyright (c) 2013 cmyr. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface TSTMultiLineOverlay : NSObject <MKOverlay>
//@property (nonatomic, readonly) MKMapRect boundingMapRect;
-(id)initWithPlist:(NSString*)path;

@property (readonly) MKMapPoint *points;
@property (readonly) NSInteger segmentCount;
@property (readonly) NSInteger *segmentLengths;

@property (nonatomic, readonly) MKMapRect boundingMapRect;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
