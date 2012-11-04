//
//  ShopTableController.h
//  daikou_mock00
//
//  Created by 達人 前津 on 12/06/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTableController : UITableViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutBt;
- (IBAction)logoutBtAction:(id)sender;
//@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *roadingImg;

@end
