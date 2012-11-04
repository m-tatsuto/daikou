//
//  ShopDetailViewController.m
//  daikou_mock00
//
//  Created by 達人 前津 on 12/06/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "SBJson.h"

@interface ShopDetailViewController ()

@end

@implementation ShopDetailViewController
@synthesize price_9km_label;

NSMutableURLRequest *request;
NSMutableArray *statuses;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *msStr = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes
    (NULL, (__bridge CFStringRef) [defaults objectForKey:@"public_number"], NULL, NULL, kCFStringEncodingMacJapanese);

    NSString* content = [[NSString alloc]initWithFormat:@"public_id=%@",msStr];
    
    NSURL* url = [NSURL URLWithString:@"http://115.31.200.177/nahanomi/daikou_shop_detail.php"];
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc]
                                       initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:7.0];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[content dataUsingEncoding:
                             NSASCIIStringEncoding]];
    
    //エラー処理↓
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [
                    NSURLConnection
                    sendSynchronousRequest : urlRequest
                    returningResponse : &response
                    error : &error
                    ];
    
    
    
    NSString *error_str = [error localizedDescription];
    
    if (0<[error_str length]) {
        NSLog(@"Failed to submit request");
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"通信ができませんでした。" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil
                              ];
        [alert show];
        
    }else {
        NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
        NSMutableString *json_string = [[NSMutableString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        
        statuses = [[NSArray alloc]initWithArray:[json_string JSONValue]];
        
        NSLog(@"%@",statuses);
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:statuses];
        [defaults setObject:data forKey:@"shopDetailJson"];
        
        [office_address_label setLineBreakMode:UILineBreakModeWordWrap];//改行モード
        [office_address_label setNumberOfLines:0];
        
        self.navigationItem.title = [[NSString alloc] initWithFormat:@"%@",[[statuses objectAtIndex:0]objectForKey:@"user_name"]];
        tel_number1_label.text = [[NSString alloc] initWithFormat:@"%@",[[statuses objectAtIndex:0]objectForKey:@"tel_number1"]];
        tel_number2_label.text = [[NSString alloc] initWithFormat:@"%@",[[statuses objectAtIndex:0]objectForKey:@"tel_number2"]];
        price_2km_label.text = [[NSString alloc] initWithFormat:@"%@円",[[statuses objectAtIndex:0]objectForKey:@"price_2km"]];
        price_3km_label.text = [[NSString alloc] initWithFormat:@"%@円",[[statuses objectAtIndex:0]objectForKey:@"price_3km"]];
        price_5km_label.text = [[NSString alloc] initWithFormat:@"%@円",[[statuses objectAtIndex:0]objectForKey:@"price_5km"]];
        price_7km_label.text = [[NSString alloc] initWithFormat:@"%@円",[[statuses objectAtIndex:0]objectForKey:@"price_7km"]];
        price_9km_label.text = [[NSString alloc] initWithFormat:@"%@円",[[statuses objectAtIndex:0]objectForKey:@"price_9km"]];
        price_12km_label.text = [[NSString alloc] initWithFormat:@"%@円",[[statuses objectAtIndex:0]objectForKey:@"price_12km"]];
        office_address_label.text = [[NSString alloc] initWithFormat:@"%@",[[statuses objectAtIndex:0]objectForKey:@"office_address"]];
        public_number_label.text = [[NSString alloc] initWithFormat:@"%@",[[statuses objectAtIndex:0]objectForKey:@"public_number"]];
    }
}

- (void)viewDidUnload
{
    tel_number1_label = nil;
    tel_number2_label = nil;
    price_2km_label = nil;
    price_3km_label = nil;
    price_5km_label = nil;
    price_7km_label = nil;
    [self setPrice_9km_label:nil];
    price_9km_label = nil;
    price_12km_label = nil;
    office_address_label = nil;
    public_number_label = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
         NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
         NSData *datax = [defaults objectForKey:@"shopDetailJson"];
         NSArray *arraydata = [NSKeyedUnarchiver unarchiveObjectWithData:datax];
         
        if (indexPath.row == 0) {
            NSString *telnumber = [[NSString alloc] initWithFormat:@"%@",[[arraydata objectAtIndex:0] objectForKey:@"tel_number1"]];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:telnumber message:@"この番号に電話しますか？" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"電話する", nil
                                  ];
            alert.tag = 1;
            [alert show];
        }else if(indexPath.row == 1){
            NSString *telnumber = [[NSString alloc] initWithFormat:@"%@",[[arraydata objectAtIndex:0] objectForKey:@"tel_number2"]];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:telnumber message:@"この番号に電話しますか？" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"電話する", nil
                                  ];
            alert.tag = 2;
            [alert show];
        }
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData *datax = [defaults objectForKey:@"shopDetailJson"];
    NSArray *arraydata = [NSKeyedUnarchiver unarchiveObjectWithData:datax];
    
    if (alertView.tag == 1) {
        if(buttonIndex == 1){
            NSString *telnumber = [[NSString alloc] initWithFormat:@"tel:%@",[[arraydata objectAtIndex:0] objectForKey:@"tel_number1"]];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telnumber]];
        }
    }else if(alertView.tag == 2){
        if(buttonIndex == 1){
            NSString *telnumber = [[NSString alloc] initWithFormat:@"tel:%@",[[arraydata objectAtIndex:0] objectForKey:@"tel_number2"]];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telnumber]];
        }
    }
}

@end
