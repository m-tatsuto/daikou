//
//  CustomerDetailController.h
//  daikou_mock00
//
//  Created by 達人 前津 on 12/06/03.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CustomerDetailController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>{
    CLLocationManager *lm;
    IBOutlet MKMapView *customerMap;
}
@property (strong, nonatomic) IBOutlet UIButton *timeBt;

- (IBAction)shopSendMessage:(id)sender;

@end