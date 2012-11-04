//
//  CustomerTableController.m
//  daikou_mock00
//
//  Created by 達人 前津 on 12/06/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomerTableController.h"
#import "SBJson.h"

@interface CustomerTableController ()

@end

@implementation CustomerTableController
@synthesize backTopBt;

NSMutableURLRequest *request;
NSMutableArray *statuses;

bool loadingflag1 = false;

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
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if([ud integerForKey:@"getJsonFlag"] == 1){
        static NSString *strCell = @"ShopHeaderCell";
        UITableViewCell *cell = [self.tableView
                                 dequeueReusableCellWithIdentifier:strCell];
        
        self.tableView.tableHeaderView = cell;
        
        table_cell_num = 0;
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:Nil forKey:@"customerTableDate"];
        
        
    }else {
        static NSString *strCell = @"ShopHeaderCell";
        UITableViewCell *cell = [self.tableView
                                 dequeueReusableCellWithIdentifier:strCell];
        
        self.tableView.tableHeaderView = cell;
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSData *datax = [defaults objectForKey:@"customerTableDate"];
        NSArray *arraydata = [NSKeyedUnarchiver unarchiveObjectWithData:datax];
        
        table_cell_num = [[arraydata objectAtIndex:0] count];
    }
    
    /*
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_bg.jpg"]];
    [tempImageView setFrame:self.tableView.frame]; 
    
    self.tableView.backgroundView = tempImageView;
     */
    
}

- (void)viewDidUnload
{
    [self setBackTopBt:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return table_cell_num;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    return [ud objectForKey:@"json_customer_id"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"MessageCustomCell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:strCell];
    
    UILabel *label_shop_time = (UILabel*)[cell viewWithTag:1];
    UILabel *label_shop_name = (UILabel*)[cell viewWithTag:2];
    UIImageView *img_label = (UIImageView*)[cell viewWithTag:4];
    //UIButton *tel_button = (UIButton*)[cell viewWithTag:3];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData *datax = [defaults objectForKey:@"customerTableDate"];
    NSArray *arraydata = [NSKeyedUnarchiver unarchiveObjectWithData:datax];
    
    //NSLog(@"%@",[[[arraydata objectAtIndex:0] objectForKey:@"1"]objectForKey:@"shop_id"]);
    NSLog(@"%d",indexPath.row);
    
    NSString *table_row = [[NSString alloc]initWithFormat:@"%d",(indexPath.row + 1)];
    
    //SEL tel_action = @selector(shop_tel:);
    //[tel_button addTarget:self action:tel_action forControlEvents:UIControlEventTouchUpInside];
    
    label_shop_time.text = [[NSString alloc] initWithFormat:@"%@分",[[[arraydata objectAtIndex:0] objectForKey:table_row]objectForKey:@"shop_message"]];
    
    label_shop_name.text = [[NSString alloc]initWithFormat:@"%@",[[[arraydata objectAtIndex:0] objectForKey:table_row]objectForKey:@"shop_name"]];
    
    int i;
    i = [label_shop_time.text intValue];
    NSLog(@"%d",i);
    
    if(i > 20){
        img_label.image = [UIImage imageNamed:@"list_bg_slow.png"];
    }else if(i > 10){
        img_label.image = [UIImage imageNamed:@"list_bg_normal.png"];
    }else {
        img_label.image = [UIImage imageNamed:@"list_bg_first.png"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData *datax = [defaults objectForKey:@"customerTableDate"];
    NSArray *arraydata = [NSKeyedUnarchiver unarchiveObjectWithData:datax];
    
    NSString *table_row = [[NSString alloc]initWithFormat:@"%d",(indexPath.row + 1)];
    
    NSString *public_number = [[NSString alloc] initWithFormat:@"%@",[[[arraydata objectAtIndex:0] objectForKey:table_row]objectForKey:@"public_number"]];
    
    NSLog(@"%@",public_number);
    
    [defaults setObject:public_number forKey:@"public_number"];
    
    
    [self performSegueWithIdentifier:@"ShopDetail" sender:self];
    /*
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData *datax = [defaults objectForKey:@"customerTableDate"];
    NSArray *arraydata = [NSKeyedUnarchiver unarchiveObjectWithData:datax];
    
    NSString *table_row = [[NSString alloc]initWithFormat:@"%d",(indexPath.row + 1)];
    
    NSString *telnumber = [[NSString alloc] initWithFormat:@"tel:%@",[[[arraydata objectAtIndex:0] objectForKey:table_row]objectForKey:@"shop_tel_number"]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telnumber]];
     */
}


//** button push **//

-(void)shop_tel:(id)sender event:(UIEvent*)event{

}

//** button push end //



//*** 非同期通信 ***
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIApplication* app = [UIApplication sharedApplication]; 
    app.networkActivityIndicatorVisible = NO;
    loadingflag1 = false;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    UIApplication* app = [UIApplication sharedApplication]; 
    app.networkActivityIndicatorVisible = NO;
    
    //loading.hidden = YES;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSLog(@"%@", response);
    
    
    NSMutableString *json_string = [[NSMutableString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    bool userBool = [json_string isEqualToString:@"false"];
    
    if(userBool){
        
        CGFloat topOffset = -44.0;
        self.tableView.contentInset = UIEdgeInsetsMake(topOffset, 0, 0, 0);
        
        static NSString *strCell = @"ShopHeaderCell";
        UITableViewCell *cell = [self.tableView
                                 dequeueReusableCellWithIdentifier:strCell];
        UIActivityIndicatorView *indicatoer = (UIActivityIndicatorView*)[cell viewWithTag:1];
        
        indicatoer.hidden = YES;
        self.tableView.tableHeaderView = cell;
        
        loadingflag1 = false;
        
        [self.tableView reloadData];
        return false;
        
    }
    
    NSInteger jsonlen = json_string.length;
    
    NSString *str = [json_string substringWithRange:NSMakeRange(0,jsonlen)];
    
    // JSONデータをパースする。
    // ここではJSONデータが配列としてパースされるので、NSArray型でデータ取得
    
    statuses = [[NSArray alloc]initWithArray:[str JSONValue]];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:statuses];
    [defaults setObject:data forKey:@"customerTableDate"];
    
    table_cell_num = [[statuses objectAtIndex:0] count];
    
    CGFloat topOffset = -44.0;
    self.tableView.contentInset = UIEdgeInsetsMake(topOffset, 0, 0, 0);
    
    static NSString *strCell = @"ShopHeaderCell";
    UITableViewCell *cell = [self.tableView
                             dequeueReusableCellWithIdentifier:strCell];
    UIActivityIndicatorView *indicatoer = (UIActivityIndicatorView*)[cell viewWithTag:1];
    
    indicatoer.hidden = YES;
    self.tableView.tableHeaderView = cell;
    
    loadingflag1 = false;
    
    [self.tableView reloadData];
}
//*** 非同期通信 end ***


- (IBAction)BackTopAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView.contentOffset.y < -10){
        if(!loadingflag1){
            loadingflag1 = true;
            
            static NSString *strCell = @"ShopHeaderCell";
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
            
            NSString* content = [[NSString alloc]initWithFormat:@"customer_id=%@",[ud objectForKey:@"json_customer_id"]];
            
            NSString *requUrl = [[NSString alloc]initWithFormat:@"http://115.31.200.177/nahanomi/daikou_customer_message.php"];
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
@end
