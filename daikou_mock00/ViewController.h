//
//  ViewController.h
//  daikou_mock00
//
//  Created by 達人 前津 on 12/05/31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController{
    CLLocationManager *manager;
}
- (IBAction)daikou_bt:(id)sender;
- (IBAction)historyBt:(id)sender;

@end
