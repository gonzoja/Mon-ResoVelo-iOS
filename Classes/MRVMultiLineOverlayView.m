//
//  TSTMultiLineOverlayView.m
//  overlayTests
//
//  Created by Colin Rothfels on 2013-05-29.
//  Copyright (c) 2013 cmyr. All rights reserved.
//

#import "MRVMultiLineOverlayView.h"
#import "MRVMultiLineOverlay.h"

#define IN_DEBUG 1

@implementation MRVMultiLineOverlayView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)drawMapRect:(MKMapRect)mapRect
         zoomScale:(MKZoomScale)zoomScale
         inContext:(CGContextRef)context{
    
    MRVMultiLineOverlay *pathsOverlay = (MRVMultiLineOverlay *)(self.overlay);
    CGFloat lineWidth;
    CGColorRef strokeColor;
    
    lineWidth = MKRoadWidthAtZoomScale(zoomScale);
    if (pathsOverlay.strokeWidthModifier){
        lineWidth *= pathsOverlay.strokeWidthModifier;
    }
        // outset the map rect by the line width so that points just outside
        // of the currently drawn rect are included in the generated path.
        // (from the breadcrumb example project)
        
        MKMapRect clipRect = MKMapRectInset(mapRect, -lineWidth, -lineWidth);
        CGPathRef path;

        path = [self newPathForPoints:pathsOverlay.points
                     segments:pathsOverlay.segmentCount
               segmentLengths:pathsOverlay.segmentLengths
                      clipRect:clipRect
                     zoomScale:zoomScale];
    
    strokeColor = pathsOverlay.strokeColor ? [pathsOverlay.strokeColor CGColor] : [[UIColor redColor] CGColor];
        if (path)
        {
            CGContextAddPath(context, path);
            CGContextSetStrokeColorWithColor(context, strokeColor);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineWidth(context, lineWidth);
            CGContextStrokePath(context);
            CGPathRelease(path);
        }
//    }
    
}

//from the breadcrumb example project
static BOOL lineIntersectsRect(MKMapPoint p0, MKMapPoint p1, MKMapRect r)
{
    double minX = MIN(p0.x, p1.x);
    double minY = MIN(p0.y, p1.y);
    double maxX = MAX(p0.x, p1.x);
    double maxY = MAX(p0.y, p1.y);
    
    MKMapRect r2 = MKMapRectMake(minX, minY, maxX - minX, maxY - minY);
    return MKMapRectIntersectsRect(r, r2);
}

#define MIN_POINT_DELTA 3.0
-(CGPathRef)newPathForPoints:(MKMapPoint *)points
            segments:(NSInteger)segments
      segmentLengths:(NSInteger*)segmentLengths
            clipRect:(MKMapRect)mapRect
            zoomScale:(MKZoomScale)zoomScale


{
    CGMutablePathRef path = CGPathCreateMutable();
    MKMapPoint point, lastPoint;
    CGPoint cgPoint;
    BOOL liftPen = YES;
    // Calculate the minimum distance between any two points by figuring out
    // how many map points correspond to MIN_POINT_DELTA of screen points
    // at the current zoomScale.
    #define POW2(a) ((a) * (a))
    double minPointDelta = MIN_POINT_DELTA / zoomScale;
    double c2 = POW2(minPointDelta);
    NSUInteger lines_drawn = 0;
    int i, s, p, j;
    i = s = p = j = 0;
    for (s = 0; s < segments; s++){
            //            So You've Decided To Draw A Segment.
        liftPen = YES; // starting a new segment
        lastPoint = points[i]; // 
        i++;
        for (p = 1; p < segmentLengths[s]; p++) // p = 1, i.e. 2nd point in a segment
        {
            point = points[i];
            double a2b2 = POW2(point.x - lastPoint.x) + POW2(point.y - lastPoint.y);
            if (a2b2 >= c2) { // if the two points aren't too close relative to zoomScale
            if (lineIntersectsRect(point, lastPoint, mapRect))
            { //if we're going to draw a line segment
                if (liftPen) 
                { // if we need to move the pen, do so
                    cgPoint = [self pointForMapPoint:lastPoint];
                    CGPathMoveToPoint(path, NULL, cgPoint.x, cgPoint.y);
                    liftPen = NO;
                }
                // draw to the new point
                cgPoint = [self pointForMapPoint:point];
                CGPathAddLineToPoint(path, NULL, cgPoint.x, cgPoint.y);
                lines_drawn ++;
            }else{ // if we're skipping a line segment, we'll need to move the pen
                liftPen = YES;
            }
            lastPoint = point;
        }
            i++;
        }
        
    }
    NSLog(@"overlay view drew %i lines", lines_drawn);
    return path;
}

@end
