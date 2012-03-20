//
//  CLineItem.h
//  BMD-X
//
//  Created by Steven Fuchs on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLineItem : NSObject
{
    NSString*					_lastName;
	NSString*					_firstName;
	NSString*					_middleName1;
	NSString*					_middleName2;
	NSString*					_middleName3;
	NSString*					_middleName4;
	NSString*					_middleName5;
	NSString*					_districtName;
	NSString*					_volumeName;
	NSString*					_pageName;
    BOOL                        mDoFinal;
}



- (NSString*)lineString;
-(void)finalizeLine:(BOOL)aFin;






@property	(copy) NSString*	lastName;
@property	(copy) NSString*    firstName;
@property	(copy) NSString*	middleName1;
@property	(copy) NSString*    middleName2;
@property	(copy) NSString*	middleName3;
@property	(copy) NSString*	middleName4;
@property	(copy) NSString*	middleName5;
@property	(copy) NSString*	districtName;
@property	(copy) NSString*	volumeName;
@property	(copy) NSString*	pageName;

@end
