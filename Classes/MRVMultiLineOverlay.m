//
//  TSTMultiLineOverlay.m
//  overlayTests
//
//  Created by Colin Rothfels on 2013-05-28.
//  Copyright (c) 2013 cmyr. All rights reserved.
//

#import "MRVMultiLineOverlay.h"
#import <CoreLocation/CoreLocation.h>


@interface MRVMultiLineOverlay()
@end

@implementation MRVMultiLineOverlay
{
    MKMapPoint* _allMapPoints;
    NSInteger _pointsCount;
    NSInteger _segmentsCount;
    NSInteger* _segmentLengths;

    //   properties for MKOverlayProtocol methods;
    MKMapRect _boundingMapRect;
    CLLocationCoordinate2D _coordinate;
    CGFloat _dashPhase;
    CGFloat *_dashLengths;
    size_t _dashLengthsCount;
}

-(id)initWithPlist:(NSString*)path{
    if (self = [super init]){
        [self setupFromPlist:path];
//        [self createSanitizedVersionOfPlist];
    }
    return self;
}

-(CGFloat)dashPhase {
    return _dashPhase;
}

-(CGFloat*)dashLengths {
    return _dashLengths;
}
-(size_t)dashLengthsCount {
    return _dashLengthsCount;
}

-(MKMapPoint *)points{
    return _allMapPoints;
}

-(NSInteger)segmentCount{
    return _segmentsCount;
}

-(NSInteger*)segmentLengths{
    return _segmentLengths;
}

-(void)setLineDashPhase:(CGFloat)phase lengths:(CGFloat *)lengths count:(size_t)count {
    _drawDashed = YES;
    _dashPhase = phase;
    _dashLengths = lengths;
    _dashLengthsCount = count;
}

-(CLLocationCoordinate2D)coordinateForString:(NSString*)string
{
    NSArray* splitString = [string componentsSeparatedByString:@","];
    NSString* latText = [splitString[0] substringFromIndex:1];
    NSString* longText = splitString[1];
    
    double latitude = [latText doubleValue];
    double longitude = [longText doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

-(MKMapPoint)mapPointForString:(NSString*)string{
//    takes a string of format $LAT,$LONG and turns it into an MKMapPoint;
    NSArray* splitString = [string componentsSeparatedByString:@","];
    NSString* latText = [splitString[0] substringFromIndex:1];
    NSString* longText = splitString[1];
    
    double latitude = [latText doubleValue];
    double longitude = [longText doubleValue];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
    return MKMapPointForCoordinate(coord);
}

-(MKMapPoint)mapPointForDict:(NSDictionary*)dict{
    double latitude = [dict[@"latitude"] doubleValue];
    double longitude = [dict[@"longitude"]doubleValue];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
    return MKMapPointForCoordinate(coord);
}


#define coords @"coordinates"

-(void)setupFromPlist:(NSString*)path{
    //        this is assuming that we're getting things from a plist. sometimes we won't be.

    NSArray* segments = [NSArray arrayWithContentsOfFile:path];
    if ([[segments lastObject]isKindOfClass:[NSArray class]]) {
//        because mapdata.plist (our old file) is in a different format, and contains arrays;
    _segmentsCount = segments.count;
    _segmentLengths = calloc(sizeof(NSInteger), _segmentsCount);
     _pointsCount = 0;
    //        enumerate through input segments:
    NSInteger i = 0;
    //        get segment lengths and pointsCount
    // this is probably less efficient then doing realloc()?
    for (NSArray* segment in segments){
        _segmentLengths[i] = segment.count;
        _pointsCount += segment.count;
        i++;
    }
    _allMapPoints = calloc(sizeof(MKMapPoint), _pointsCount);
    i = 0;
    for (NSArray* segment in segments){
        for (NSString* pointString in segment){
            _allMapPoints[i] = [self mapPointForString:pointString];
            i++;
            }
        }
    }else{
//        our new-style plists use dicts and other fun things
        _segmentsCount = segments.count;
        _segmentLengths = calloc(sizeof(NSInteger), _segmentsCount);
        _pointsCount = 0;
        NSInteger i = 0;
        //        get segment lengths and pointsCount
        // this is probably less efficient then doing realloc()?
        for (NSDictionary* segment in segments){
            NSArray *points = segment[coords];
            _segmentLengths[i] = points.count;
            _pointsCount += points.count;
            i++;
        }
        _allMapPoints = calloc(sizeof(MKMapPoint), _pointsCount);
        i = 0;
        for (NSDictionary* segment in segments){
            for (NSDictionary* pointDict in segment[coords]){
                _allMapPoints[i] = [self mapPointForDict:pointDict];
                i++;
            }
        }
    }
    [self setupDebugProperties];
}

-(void)setupDebugProperties{
   _boundingMapRect = MKMapRectMake(79061287.8222222, 95816897.2125126, 365704.533333331, 319911.090659514);
    _coordinate = CLLocationCoordinate2DMake(45.5531, -73.7253);
}

//-(void)setProperties{
//    MKMapPoint upperLeft = _allMapPoints[0];
//    MKMapPoint lowerRight = _allMapPoints[0];
//    MKMapPoint *point;
//    int i = 0;
//    for (i = 0; i < _pointsCount; i++){
//        point = &_allMapPoints[i];
//        if (point->x < upperLeft.x) upperLeft.x = point->x;
//        if (point->y < upperLeft.y) upperLeft.y = point->y;
//        if (point->x > lowerRight.x) lowerRight.x = point->x;
//        if (point->y > lowerRight.y) lowerRight.y = point->y;
//    }
//    //    set instance variables for properties required by protocol
//    _boundingMapRect = MKMapRectMake(upperLeft.x, upperLeft.y ,lowerRight.x - upperLeft.x, lowerRight.y - upperLeft.y);
//    _coordinate = MKCoordinateForMapPoint(MKMapPointMake((lowerRight.x + upperLeft.x)/2,
//                                                         (lowerRight.y + upperLeft.y)/2));
//
//}

//-(void)setProperties{
////    find our four corners;
//    CLLocationCoordinate2D upperLeftCoord = CLLocationCoordinate2DMake(-1000, 1000);
//    CLLocationCoordinate2D lowerRightCoord = CLLocationCoordinate2DMake(1000, -1000);
//    CLLocationCoordinate2D *coord;
//
//
//    int i = 0;
//    for (i = 0; i < _pointsCount; i++){
//        coord = &_allPoints[i];
//        if(coord->latitude > upperLeftCoord.latitude) upperLeftCoord.latitude = coord->latitude;
//        if(coord->latitude < lowerRightCoord.latitude) lowerRightCoord.latitude = coord->latitude;
//        if(coord->longitude < upperLeftCoord.longitude) upperLeftCoord.longitude = coord->longitude;
//        if(coord->longitude > lowerRightCoord.longitude) lowerRightCoord.longitude = coord->longitude;
//    }
//
//    MKMapPoint upperLeft = MKMapPointForCoordinate(upperLeftCoord);
//    MKMapPoint lowerRight = MKMapPointForCoordinate(lowerRightCoord);
//
//    //set instance variables for properties required by protocol
//    _boundingMapRect = MKMapRectMake(upperLeft.x, upperLeft.y ,lowerRight.x - upperLeft.x, lowerRight.y - upperLeft.y);
//    _coordinate = MKCoordinateForMapPoint(MKMapPointMake((lowerRight.x + upperLeft.x)/2,
//                                                         (lowerRight.y + upperLeft.y)/2));
//}

-(MKMapRect)boundingMapRect{
    return _boundingMapRect;
}

-(CLLocationCoordinate2D) coordinate{
    return _coordinate;
}

-(NSString*)description {
    NSString *description = [NSString stringWithFormat:@"TSTMultiLineOverlay: %i segments with %i points.", _segmentsCount, _pointsCount];
    return description;
}

-(void)dealloc{
    free(_allMapPoints);
    free(_segmentLengths);
}

@end
