//
//  GHGModel.h
//  Mon ResoVelo
//
//  Created by Stewart Jackson on 2013-05-28.
//
//

#import <Foundation/Foundation.h>

@interface GHGModel : NSObject
{
    int hour;
    double distance;
    NSMutableArray *_factors;
}

-(id) initWithHour:(int)tripStartHour andDistance:(double)inMeters;

-(double)getGHG;

@end
