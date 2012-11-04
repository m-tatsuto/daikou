//
//  CustomerAnnotation.m
//  daikou_mock00
//
//  Created by 達人 前津 on 12/06/03.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomerAnnotation.h"

@implementation CustomerAnnotation

@synthesize coordinate;
@synthesize title;

-(id)initWithCoordinate:(CLLocationCoordinate2D)co{
    coordinate = co;
    return self;
}

@end
