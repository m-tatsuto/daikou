//
//  ShopDetailViewController.h
//  daikou_mock00
//
//  Created by 達人 前津 on 12/06/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UILabel *tel_number1_label;
    IBOutlet UILabel *tel_number2_label;
    IBOutlet UILabel *price_2km_label;
    IBOutlet UILabel *price_3km_label;
    IBOutlet UILabel *price_5km_label;
    IBOutlet UILabel *price_7km_label;
    IBOutlet UILabel *price_9km_label;
    IBOutlet UILabel *price_12km_label;
    IBOutlet UILabel *office_address_label;
    IBOutlet UILabel *public_number_label;
}
@property (strong, nonatomic) IBOutlet UILabel *price_9km_label;

@end
