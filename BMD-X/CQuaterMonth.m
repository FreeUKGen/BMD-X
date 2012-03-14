//
//  CQuaterMonth.m
//  BMD-X
//
//  Created by Steven Fuchs on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CQuaterMonth.h"

@implementation CQuaterMonth

+(NSString*)monthForQuarter:(NSString*)qtrStr
{
    if ( [qtrStr isEqualToString:@"Mar"] )
        return @"1";
    else if ( [qtrStr isEqualToString:@"Jun"] )
        return @"4";
    else if ( [qtrStr isEqualToString:@"Sep"] )
        return @"7";
    else if ( [qtrStr isEqualToString:@"Dec"] )
        return @"10";
    else
        NSLog( "This is the quarter %@", qtrStr );

    return @"1";
}

@end
