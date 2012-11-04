//
//  CustomerDetailController.m
//  daikou_mock00
//
//  Created by 達人 前津 on 12/06/03.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomerDetailController.h"
#import "CustomerAnnotation.h"

@interface CustomerDetailController ()

@end

@implementation CustomerDetailController
@synthesize timeBt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    customerMap.delegate = self;
    customerMap.mapType = MKMapTypeStandard;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%d",[defaults integerForKey:@"shop_time"]);
    if([defaults integerForKey:@"shop_time"] > 0){
        timeBt.titleLabel.text = [[NSString alloc] initWithFormat:@"%d分",[defaults integerForKey:@"shop_time"]];
        NSLog(@"%d",[defaults integerForKey:@"shop_time"]);
    }
    
    NSString *latitudeStr = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"customer_latitude"]];
    
    NSString *longitudeStr = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"customer_longitude"]];
    
    double latitudeValue = [latitudeStr doubleValue];
    
    double longitudeValue = [longitudeStr doubleValue];
    
    NSLog(@"%f",latitudeValue);
    NSLog(@"%f",longitudeValue);
    
    CLLocationCoordinate2D co;
    co.latitude = latitudeValue;
    co.longitude = longitudeValue;
    
    [customerMap setCenterCoordinate:co animated:YES];
    
    MKCoordinateRegion region = customerMap.region;
    region.center = co;
    region.span.latitudeDelta = 0.1;
    region.span.longitudeDelta = 0.1;
    [customerMap setRegion:region animated:YES];
    
    CustomerAnnotation *custom = [[CustomerAnnotation alloc]initWithCoordinate:co];
    custom.title = @"お客さん";
    [customerMap addAnnotation:custom];
    
    //[self viewDidLoad];
	// Do any additional setup after loading the view.
}

-(MKAnnotationView*)mapView:(MKMapView*)mapView
          viewForAnnotation:(id)annotation{
    
    static NSString *PinIdentifier = @"Pin";
    MKPinAnnotationView *pav =
    (MKPinAnnotationView*)
    [customerMap dequeueReusableAnnotationViewWithIdentifier:PinIdentifier];
    if(pav == nil){
        pav = [[MKPinAnnotationView alloc]
                initWithAnnotation:annotation reuseIdentifier:PinIdentifier];
        pav.animatesDrop = YES;  // アニメーションをする
        pav.pinColor = MKPinAnnotationColorPurple;  // ピンの色を紫にする
        pav.canShowCallout = YES;  // ピンタップ時にコールアウトを表示する
    }
    return pav;
    
}


- (void)viewDidUnload
{
    customerMap = nil;
    [self setTimeBt:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (IBAction)shopSendMessage:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%d",[defaults integerForKey:@"shop_time"]);
    
    if([defaults integerForKey:@"shop_time"] > 0){
        NSString* content = [[NSString alloc]initWithFormat:@"shop_id=%@&customer_id=%d&shop_time=%d",[defaults objectForKey:@"ShopUserName"],[defaults integerForKey:@"customer_id"],[defaults integerForKey:@"shop_time"]];
    
        NSURL* url = [NSURL URLWithString:@"http://115.31.200.177/nahanomi/daikou_shop.php"];
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
                              initWithTitle:@"リクエスト失敗しました。通信ができませんでした。" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil
                              ];
            [alert show];
        
        }else {
            bool strb = [valueStr isEqualToString:@"true"];
            bool strbno2time = [valueStr isEqualToString:@"no2time"];
            
            if (strb) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"リクエスト成功しました。" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil
                                      ];
                [alert show];
            }else if (strbno2time) {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"２回送信はできません。" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil
                                      ];
                [alert show];
            }
        }
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"時間を決めてください" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil
                              ];
        [alert show];
    }
}
@end
