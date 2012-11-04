//
//  ShopTimeController.m
//  daikou_mock00
//
//  Created by 達人 前津 on 12/06/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShopTimeController.h"

@interface ShopTimeController ()

@end

@implementation ShopTimeController
@synthesize shop_timer;

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
    shop_timer.delegate = self;
    shop_timer.dataSource = self;
	// Do any additional setup after loading the view.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView*)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return 60;
}

-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%d分",row+1];
}

- (void)viewDidUnload
{
    [self setShop_timer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)shopTimerBt:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger val = [shop_timer selectedRowInComponent:0];
    
    [defaults setInteger:val+1 forKey:@"shop_time"];
    [defaults synchronize];
    ShopTimeController *parent = [self.navigationController.viewControllers objectAtIndex:1];
    [parent viewDidLoad];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
