//
//  CLineItem.m
//  BMD-X
//
//  Created by Steven Fuchs on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CLineItem.h"


@implementation CLineItem
@synthesize lastName		= _lastName;
@synthesize firstName		= _firstName;
@synthesize middleName1		= _middleName1;
@synthesize middleName2		= _middleName2;
@synthesize middleName3		= _middleName3;
@synthesize middleName4		= _middleName4;
@synthesize middleName5		= _middleName5;
@synthesize districtName	= _districtName;
@synthesize volumeName      = _volumeName;
@synthesize pageName        = _pageName;




- (BOOL) notEmpty
{
    return self.lastName != nil || self.firstName != nil || self.middleName1 != nil || self.districtName != nil || self.pageName != nil;
}

-(void)finalizeLine:(BOOL)aFin
{
    mDoFinal = aFin;
}

- (NSString*)lineString
{
    
    NSMutableString* answer = [NSMutableString string];
    if ([self notEmpty] )
    {
        [answer appendFormat:@"%@,", self.lastName == nil ? @"" : self.lastName ];
        if ( self.firstName )
            [answer appendFormat:@"%@,", self.firstName, nil ];
        if ( self.middleName1 ) {
            NSMutableArray* middles = [NSMutableArray arrayWithObject:self.middleName1];
            if ( self.middleName2 )
                [middles addObject:self.middleName2 ];
            if ( self.middleName3 )
                [middles addObject:self.middleName3 ];
            if ( self.middleName4 )
                [middles addObject:self.middleName4 ];
            if ( self.middleName5 )
                [middles addObject:self.middleName5 ];
            
            [answer appendFormat:@"%@,", [middles componentsJoinedByString:@" "], nil];
        }
        if ( self.districtName )
            [answer appendFormat:@"%@,", self.districtName, nil ];
        if ( self.volumeName )
            [answer appendFormat:@"%@,", self.volumeName, nil ];
        if ( self.pageName )
            [answer appendFormat:@"%@", self.pageName, nil ];

        if ( mDoFinal )
        {
            [answer appendString:@"\r"];
            mDoFinal = false;
            self.firstName = self.lastName = self.middleName1 = self.middleName2
                = self.middleName3 = self.middleName4 = self.middleName5
                    = self.districtName = self.volumeName = self.pageName = nil;
        }
    }
    return answer;
}




@end
