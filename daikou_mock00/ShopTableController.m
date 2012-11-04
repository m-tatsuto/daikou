//
//  ShopTableController.m
//  daikou_mock00
//
//  Created by 達人 前津 on 12/06/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShopTableController.h"
#import "SBJson.h"

@interface ShopTableController ()

@end

@implementation ShopTableController
//@synthesize roadingImg;
@synthesize logoutBt;
NSMutableURLRequest *request;
NSMutableArray *statuses;

bool loadingflag = false;

int table_cell_num;

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
    static NSString *strCell = @"CustomHeaderCell";
    UITableViewCell *cell = [self.tableView
                             dequeueReusableCellWithIdentifier:strCell];
    
    self.tableView.tableHeaderView = cell;
    
    table_cell_num = 0;
    UIApplication* app = [UIApplication sharedApplication]; 
    app.networkActivityIndicatorVisible = YES;
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    double user_lat = [ud doubleForKey:@"userLatitu"];
    double user_lon = [ud doubleForKey:@"userLongitu"];
    
    NSString* content = [[NSString alloc]initWithFormat:@"latitude=%f&longitude=%f",user_lat,user_lon];
    
    NSString *requUrl = [[NSString alloc]initWithFormat:@"http://115.31.200.177/nahanomi/daikou_shop_json.php"];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:7.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[content dataUsingEncoding:
                             NSASCIIStringEncoding]];
    [NSURLConnection connectionWithRequest: request delegate: self ];

}

- (void)viewDidUnload
{
    [self setLogoutBt:nil];
    //[self setRoadingImg:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return table_cell_num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"CustomCell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:strCell];
    UILabel *label1 = (UILabel*)[cell viewWithTag:1];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData *datax = [defaults objectForKey:@"statusesDate"];
    NSArray *arraydata = [NSKeyedUnarchiver unarchiveObjectWithData:datax];
    
    NSString *usrLoStr =[[NSString alloc] initWithFormat:@"%@",[[arraydata objectAtIndex:(indexPath.row)]objectForKey:@"user_location"]];
    bool userBool = [usrLoStr isEqualToString:@""];
    if (!userBool) {
        label1.text = [[NSString alloc] initWithFormat:@"%@",[[arraydata objectAtIndex:(indexPath.row)]objectForKey:@"user_location"]];
    }else {
        label1.text = [[NSString alloc] initWithFormat:@"%@",[[arraydata objectAtIndex:(indexPath.row)]objectForKey:@"customer_time"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData *datax = [defaults objectForKey:@"statusesDate"];
    NSArray *arraydata = [NSKeyedUnarchiver unarchiveObjectWithData:datax];
    
    [defaults setObject:[[arraydata objectAtIndex:indexPath.row]objectForKey:@"latitude"] forKey:@"customer_latitude"];
    [defaults setObject:[[arraydata objectAtIndex:indexPath.row]objectForKey:@"longitude"] forKey:@"customer_longitude"];
    [defaults setObject:[[arraydata objectAtIndex:indexPath.row]objectForKey:@"customer_id"] forKey:@"customer_id"];
    [defaults synchronize];
    [self performSegueWithIdentifier:@"CustomerDetail" sender:self];
}


//*** 非同期通信 ***
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIApplication* app = [UIApplication sharedApplication]; 
    app.networkActivityIndicatorVisible = NO;
    loadingflag = false;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //loading.hidden = YES;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSLog(@"%@", response);
    
    NSMutableString *json_string = [[NSMutableString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",json_string);
    
    statuses = [[NSArray alloc]initWithArray:[json_string JSONValue]];
    
    //NSLog(@"%@",statuses);
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:statuses];
    [defaults setObject:data forKey:@"statusesDate"];
    
    
    NSLog(@"statuses:%d",[statuses count]);
    table_cell_num = [statuses count];
    //NSLog(@"%d",table_cell_num);
    
    UIApplication* app = [UIApplication sharedApplication]; 
    app.networkActivityIndicatorVisible = NO;
    
    CGFloat topOffset = -44.0;
    self.tableView.contentInset = UIEdgeInsetsMake(topOffset, 0, 0, 0);
    //roadingImg.hidden = YES;
    
    static NSString *strCell = @"CustomHeaderCell";
    UITableViewCell *cell = [self.tableView
                             dequeueReusableCellWithIdentifier:strCell];
    UIActivityIndicatorView *indicatoer = (UIActivityIndicatorView*)[cell viewWithTag:1];
    
    indicatoer.hidden = YES;
    self.tableView.tableHeaderView = cell;
    
    loadingflag = false;
    
    [self.tableView reloadData];
}
//*** 非同期通信 end ***


- (IBAction)logoutBtAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y < 0){
        NSLog(@"did");
        
    }
    //NSLog(@"scroll");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y < -10){
        if(!loadingflag){
            loadingflag = true;
        //[self performSelector:@selector(_taskFinished) withObject:nil afterDelay:2.0];
        
        //roadingImg.hidden = NO;
        
        static NSString *strCell = @"CustomHeaderCell";
        UITableViewCell *cell = [self.tableView
                                 dequeueReusableCellWithIdentifier:strCell];
        UIActivityIndicatorView *indicatoer = (UIActivityIndicatorView*)[cell viewWithTag:1];
            
        UILabel *label = (UILabel*)[cell viewWithTag:2];
        label.text = @"更新中...";
        
        indicatoer.hidden = NO;
        self.tableView.tableHeaderView = cell;
         
        
        CGFloat topOffset = 0.0;
        self.tableView.contentInset = UIEdgeInsetsMake(topOffset, 0, 0, 0);
        UIApplication* app = [UIApplication sharedApplication]; 
        app.networkActivityIndicatorVisible = YES;
        
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            double user_lat = [ud doubleForKey:@"userLatitu"];
            double user_lon = [ud doubleForKey:@"userLongitu"];
            
            NSString* content = [[NSString alloc]initWithFormat:@"latitude=%f&longitude=%f",user_lat,user_lon];
            
            NSString *requUrl = [[NSString alloc]initWithFormat:@"http://115.31.200.177/nahanomi/daikou_shop_json.php"];
            request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:7.0];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[content dataUsingEncoding:
                                  NSASCIIStringEncoding]];
            
            [NSURLConnection connectionWithRequest: request delegate: self ];
        }
        NSLog(@"did_finish");
    }
    //NSLog(@"scrollend");
}

- (void)_taskFinished
{
    
}
@end
