//
//  CalorieModel.m
//  Mon ResoVelo
//
//  Created by Stewart Jackson on 2013-05-28.
//
//

#import "CalorieModel.h"

@implementation CalorieModel

-(id) initWithDuration:(double)inSeconds andAverageSpeed:(double)inKPH andWeight:(int)inPounds
{
    self = [super init];
    if (self) {
        weight = inPounds;
        avgSpeed = inKPH;
        duration = inSeconds;
		
        factors = [NSMutableArray arrayWithObjects:
                   [NSNumber numberWithDouble:0.0295],
                   [NSNumber numberWithDouble:0.0355],
                   [NSNumber numberWithDouble:0.0426],
                   [NSNumber numberWithDouble:0.0512],
                   [NSNumber numberWithDouble:0.0561],
                   [NSNumber numberWithDouble:0.0615],
                   [NSNumber numberWithDouble:0.0675],
                   [NSNumber numberWithDouble:0.0740],
                   [NSNumber numberWithDouble:0.0811],
                   [NSNumber numberWithDouble:0.0891],
                   [NSNumber numberWithDouble:0.0975],
                   [NSNumber numberWithDouble:0.1173],
                   [NSNumber numberWithDouble:0.1441],
                   nil];
    }
    return self;
}

-(double)getCalories{
    double calories = 0;
    double factor = 0;
    
    if (self){
        if (avgSpeed < 3.0){
            factor = 0;
        } else if (avgSpeed <= 12.9){
            factor = [[factors objectAtIndex:0]doubleValue];
        }else if (avgSpeed <= 16.1){
            factor = [[factors objectAtIndex:1]doubleValue];
        }else if (avgSpeed <= 19.3){
            factor = [[factors objectAtIndex:2]doubleValue];
        }else if (avgSpeed <= 22.5){
            factor = [[factors objectAtIndex:3]doubleValue];
        }else if (avgSpeed <= 24.1){
            factor = [[factors objectAtIndex:4]doubleValue];
        }else if (avgSpeed <= 25.8){
            factor = [[factors objectAtIndex:5]doubleValue];
        }else if (avgSpeed <= 27.4){
            factor = [[factors objectAtIndex:6]doubleValue];
        }else if (avgSpeed <= 29.0){
            factor = [[factors objectAtIndex:7]doubleValue];
        }else if (avgSpeed <= 30.6){
            factor = [[factors objectAtIndex:8]doubleValue];
        }else if (avgSpeed <= 32.2){
            factor = [[factors objectAtIndex:9]doubleValue];
        }else if (avgSpeed <= 33.8){
            factor = [[factors objectAtIndex:10]doubleValue];
        }else if (avgSpeed <= 37.0){
            factor = [[factors objectAtIndex:11]doubleValue];
        }else{
            factor = [[factors objectAtIndex:12]doubleValue];
        }
        
        NSLog(@"Factor: %f", factor);
        NSLog(@"Weight: %i", weight);
        NSLog(@"Avg Speed: %f", avgSpeed);
        NSLog(@"Duration: %f", duration);
        
        
        calories = factor*weight*duration/60;
        return calories;
        
    }
}

@end

