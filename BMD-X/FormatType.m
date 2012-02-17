//
//  FormatType.m
//  BMD-X
//
//  Created by Steven Fuchs on 2/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FormatType.h"


@implementation CFormatType
+(NSString*)codeForTitle:(NSString*)titleString
{
    if ( [titleString isEqualToString:@"Fiche"] ) {
        return @"F";
    } else if ( [titleString isEqualToString:@"Microfilm"] ) {
        return @"M";
    } else if ( [titleString isEqualToString:@"Book"] ) {
        return @"B";
    } else if ( [titleString isEqualToString:@"Webscan"] ) {
        return @"S";
    } else if ( [titleString isEqualToString:@"Unknown"] ) {
        return @"U";
    }
    
    return @"";
}



- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
