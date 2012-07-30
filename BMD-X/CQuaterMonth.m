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
        return @"2";
    else if ( [qtrStr isEqualToString:@"Sep"] )
        return @"3";
    else if ( [qtrStr isEqualToString:@"Dec"] )
        return @"4";

    return @"1";
}

@end
