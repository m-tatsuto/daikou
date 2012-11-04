//
//  ViewController.m
//  daikou_mock00
//
//  Created by 達人 前津 on 12/05/31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (manager)return;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:NULL forKey:@"userLatitu"];
    [ud setObject:NULL forKey:@"userLongitu"];
    [ud setObject:NULL forKey:@"CustomerLocationDetail"];
    
    
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    manager.distanceFilter = kCLDistanceFilterNone;
    [manager startUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setDouble:newLocation.coordinate.latitude forKey:@"userLatitu"];
    [ud setDouble:newLocation.coordinate.longitude forKey:@"userLongitu"];
    [ud synchronize];
    
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
    
    geoCoder.delegate = self;
    [geoCoder start];
    
    NSLog(@"%f",[ud doubleForKey:@"userLatitu"]);
    NSLog(@"%f",[ud doubleForKey:@"userLongitu"]);
    
    
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendFormat:@"longitude : %f \n", placemark.coordinate.longitude];
    [str appendFormat:@"latitude : %f \n", placemark.coordinate.latitude];
    [str appendFormat:@"country : %@ \n", placemark.country];
    [str appendFormat:@"state : %@ \n", placemark.administrativeArea];
    [str appendFormat:@"locality : %@ \n", placemark.locality];
    [str appendFormat:@"additional locality : %@ \n", placemark.subLocality];
    [str appendFormat:@"postcode : %@ \n", placemark.postalCode];
    NSLog(@"%@",str);
    
    NSMutableString *userStr = [[NSMutableString alloc] init];
    [userStr appendFormat:@"%@,",placemark.administrativeArea];
    [userStr appendFormat:@"%@,",placemark.locality];
    [userStr appendFormat:@"%@,",placemark.subLocality];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:userStr forKey:@"CustomerLocationDetail"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}

- (IBAction)daikou_bt:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"リクエストを送信しますか？" message:@"前回のリクエスト情報はなくなります。" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"代行を呼ぶ", nil
                          ];
    alert.tag = 1;
    [alert show];

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{    
    
    if (alertView.tag == 1) {
        
        if(buttonIndex == 1){
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            double user_lat = [ud doubleForKey:@"userLatitu"];
            double user_lon = [ud doubleForKey:@"userLongitu"];
            
            NSLog(@"%f",user_lon);
            
            NSLog(@"%@",[ud objectForKey:@"CustomerLocationDetail"]);
            
            NSString *msStr = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes
            (NULL, (__bridge CFStringRef) [ud objectForKey:@"CustomerLocationDetail"], NULL, NULL, kCFStringEncodingMacJapanese);
            
            NSString* content = [[NSString alloc]initWithFormat:@"latitude=%f&longitude=%f&user_location=%@",user_lat,user_lon,msStr];
            
            NSURL* url = [NSURL URLWithString:@"http://115.31.200.177/nahanomi/daikou_customer.php"];
            NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc]
                                               initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:7.0];
            [urlRequest setHTTPMethod:@"POST"];
            [urlRequest setHTTPBody:[content dataUsingEncoding:
                                     NSASCIIStringEncoding]];
            
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSData *data = [
                            NSURLConnection
                            sendSynchronousRequest : urlRequest
                            returningResponse : &response
                            error : &error
                            ];
            
            NSString *valueStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            //NSLog(@"%@",valueStr);
            
            NSString *error_str = [error localizedDescription];
            
            //エラー処理↓
            if (0<[error_str length]) {
                NSLog(@"Failed to submit request");
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"通信が失敗しました。" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil
                                      ];
                [alert show];
            }else{
                bool strb = [valueStr isEqualToString:@"false"];
                if(strb){
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"失敗しました。" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil
                                          ];
                }else{
                    [ud setObject:valueStr forKey:@"json_customer_id"];
                    [ud setInteger:1 forKey:@"getJsonFlag"];
                    [self performSegueWithIdentifier:@"getShopInformation" sender:self];
                }
                //NSLog(@"%@",[ud objectForKey:@"json_customer_id"]);
            }
        }else{
            
        }
        
    }
    
}


- (IBAction)historyBt:(id)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:0 forKey:@"getJsonFlag"];
    
    [self performSegueWithIdentifier:@"getShopInformation" sender:self];
}
@end
