//
//  CustomerAnnotation.h
//  daikou_mock00
//
//  Created by 達人 前津 on 12/06/03.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapkit/Mapkit.h>

@interface CustomerAnnotation : NSObject <MKAnnotation>{
    
    CLLocationCoordinate2D coordinate;
    NSString *title;
    
}

@property(nonatomic)CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;

-(id)initWithCoordinate:(CLLocationCoordinate2D)co;

@end
