//
//  GHGModel.m
//  Mon ResoVelo
//
//  Created by Stewart Jackson on 2013-05-28.
//
//

#import "GHGModel.h"

@implementation GHGModel

-(id)initWithHour:(int)tripStartHour andDistance:(double)inMeters
{
    self = [super init];
    if (self) {
        hour = tripStartHour;
        distance = inMeters;
        
        factors = [NSMutableArray arrayWithObjects:
                   [NSNumber numberWithDouble:1.14],
                   [NSNumber numberWithDouble:1.14],
                   [NSNumber numberWithDouble:1.14],
                   [NSNumber numberWithDouble:1.14],
                   [NSNumber numberWithDouble:1.14],
                   [NSNumber numberWithDouble:1.14],
                   [NSNumber numberWithDouble:1.17],
                   [NSNumber numberWithDouble:1.27],
                   [NSNumber numberWithDouble:1.31],
                   [NSNumber numberWithDouble:1.26],
                   [NSNumber numberWithDouble:1.23],
                   [NSNumber numberWithDouble:1.21],
                   [NSNumber numberWithDouble:1.21],
                   [NSNumber numberWithDouble:1.21],
                   [NSNumber numberWithDouble:1.25],
                   [NSNumber numberWithDouble:1.27],
                   [NSNumber numberWithDouble:1.31],
                   [NSNumber numberWithDouble:1.26],
                   [NSNumber numberWithDouble:1.23],
                   [NSNumber numberWithDouble:1.16],
                   [NSNumber numberWithDouble:1.15],
                   [NSNumber numberWithDouble:1.15],
                   [NSNumber numberWithDouble:1.14],
                   [NSNumber numberWithDouble:1.14],
                   nil];

    }
    return self;
}


-(double)getGHG{
    double ghg = 0;
    double hourFactor = 0;
    
    if (self){
        hourFactor = [[factors objectAtIndex:hour]doubleValue];
        ghg = hourFactor*0.0000919*2.289*distance;
        
        NSLog(@"Hour: %i", hour);
        NSLog(@"Distance: %f", distance);
        NSLog(@"Hour Factor: %f", hourFactor);
        NSLog(@"Greenhouse Gas: %f", ghg);
        
    }
    return ghg;
    
}

@end
