//
//  CalorieModel.h
//  Mon ResoVelo
//
//  Created by Stewart Jackson on 2013-05-28.
//
//

#import <Foundation/Foundation.h>

@interface CalorieModel : NSObject
{
    int weight;
    double duration;
    double avgSpeed;
    NSMutableArray *factors;
}

-(id) initWithDuration:(double)inSeconds andAverageSpeed:(double)inKPH andWeight:(int)inPounds;

-(double) getCalories;

@end