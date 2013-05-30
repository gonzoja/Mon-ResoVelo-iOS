//
//  TSTMultiLineOverlay.m
//  overlayTests
//
//  Created by Colin Rothfels on 2013-05-28.
//  Copyright (c) 2013 cmyr. All rights reserved.
//

#import "TSTMultiLineOverlay.h"
@interface TSTMultiLineOverlay()
@end

@implementation TSTMultiLineOverlay
{
    CLLocationCoordinate2D* _allPoints;
    MKMapPoint* _allMapPoints;
//    deprecating _allPoints
    NSInteger _pointsCount;
    NSInteger _segmentsCount;
    NSInteger* _segmentLengths;

    //   properties for MKOverlayProtocol methods;
    MKMapRect _boundingMapRect;
    CLLocationCoordinate2D _coordinate;
}

-(id)initWithPlist:(NSString*)path{
    if (self = [super init]){
        [self setupFromPlist:path];
//        [self setupDebugProperties];
//        because setting things up manually is way too hard?

        
    }
    return self;
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


-(void)setupFromPlist:(NSString*)path{
    //        this is assuming that we're getting things from a plist. sometimes we won't be.
    NSArray* segments = [NSArray arrayWithContentsOfFile:path];
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
    _allPoints = calloc(sizeof(CLLocationCoordinate2D), _pointsCount);
//    _allMapPoints = calloc(sizeof(MKMapPoint), _pointsCount);
    i = 0;
    for (NSArray* segment in segments){
        for (NSString* pointString in segment){
            CGPoint p = CGPointFromString(pointString);
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(p.x, p.y);
//            MKMapPoint tstPoint =  MKMapPointForCoordinate(coord);
//            _allMapPoints[i] = tstPoint;
            _allPoints[i] = coord;
//            NSLog(@"%@, %f, %f, %f, %f", pointString, p.x, p.y, _allPoints[i].latitude, _allPoints[i].longitude);
            i++;
        }//            add each individual point to _allPoints;
    }
     //TODO: this should all be about mappoints, eventually. for now we're just converting

    
    
    
    i = 0;
    _allMapPoints = calloc(sizeof(MKMapPoint), _pointsCount);
    for (i = 0; i < _pointsCount; i++)
    {
        _allMapPoints[i] = MKMapPointForCoordinate(_allPoints[i]);
    }
    
    [self setProperties];
}

//-(void)setupDebugProperties{
////    this should be done dynamically based on whatever data we receive.
////    here's just manually set up for montreal.
//    MKMapPoint upperLeft = MKMapPointForCoordinate(CLLocationCoordinate2DMake(45.675, -74));
//    MKMapPoint lowerRight = MKMapPointForCoordinate(CLLocationCoordinate2DMake(45.412, -75.438));
//   _boundingMapRect = MKMapRectMake(upperLeft.x, upperLeft.y ,lowerRight.x - upperLeft.x, lowerRight.y - upperLeft.y);
//    _coordinate = CLLocationCoordinate2DMake(45.526, -73.658);
//}

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

-(void)setProperties{
//    find our four corners;
    CLLocationCoordinate2D upperLeftCoord = CLLocationCoordinate2DMake(-1000, 1000);
    CLLocationCoordinate2D lowerRightCoord = CLLocationCoordinate2DMake(1000, -1000);
    CLLocationCoordinate2D *coord;
    
    
    int i = 0;
    for (i = 0; i < _pointsCount; i++){
        coord = &_allPoints[i];
        if(coord->latitude > upperLeftCoord.latitude) upperLeftCoord.latitude = coord->latitude;
        if(coord->latitude < lowerRightCoord.latitude) lowerRightCoord.latitude = coord->latitude;
        if(coord->longitude < upperLeftCoord.longitude) upperLeftCoord.longitude = coord->longitude;
        if(coord->longitude > lowerRightCoord.longitude) lowerRightCoord.longitude = coord->longitude;
    }
    
    MKMapPoint upperLeft = MKMapPointForCoordinate(upperLeftCoord);
    MKMapPoint lowerRight = MKMapPointForCoordinate(lowerRightCoord);

    //set instance variables for properties required by protocol
    _boundingMapRect = MKMapRectMake(upperLeft.x, upperLeft.y ,lowerRight.x - upperLeft.x, lowerRight.y - upperLeft.y);
    _coordinate = MKCoordinateForMapPoint(MKMapPointMake((lowerRight.x + upperLeft.x)/2,
                                                         (lowerRight.y + upperLeft.y)/2));
    
    
}

-(MKMapRect)boundingMapRect{
    return _boundingMapRect;
}

-(CLLocationCoordinate2D) coordinate{
    return _coordinate;
}

-(void)dealloc{
    free(_allPoints);
    free(_allMapPoints);
    free(_segmentLengths);
}

@end
