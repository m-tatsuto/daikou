//
//  ShopTopViewController.h
//  daikou_mock00
//
//  Created by 達人 前津 on 12/06/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTopViewController : UIViewController
- (IBAction)backCustomerBt:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *user_id;
@property (strong, nonatomic) IBOutlet UITextField *user_password;
- (IBAction)loginBtAction:(id)sender;

@end
