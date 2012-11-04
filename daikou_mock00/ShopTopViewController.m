//
//  ShopTopViewController.m
//  daikou_mock00
//
//  Created by 達人 前津 on 12/06/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShopTopViewController.h"

@interface ShopTopViewController ()

@end

@implementation ShopTopViewController
@synthesize user_id;
@synthesize user_password;

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
    user_id.delegate = self;
    user_password.delegate = self;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    user_id.text = [defaults objectForKey:@"ShopUserName"];
    
    
    
    
	// Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //NSLog(@"textFieldShouldBeginEditing");
    return YES;  //これをNOにすると、キーボードが出ません
}


//テキストフィールドを編集する直後に呼び出されます
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //NSLog(@"textFieldDidBeginEditing");
}


//Returnボタンがタップされた時に呼び出されます
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *userStr;
    NSString *passwardStr;
    userStr=user_id.text;
    passwardStr=user_password.text;//テキストを受け取って
    NSLog(@"%@",userStr);
    NSLog(@"%@",passwardStr);
    
    //「resignFirstResponder」はユーザーのアクションに対して
    //最初に応答するオブジェクトを放棄するという命令なので
    //「tf」が放棄されて、キーボードも消えます
    [user_id resignFirstResponder];
    [user_password resignFirstResponder];
    return YES;
}


//テキストフィールドの編集が終了する直前に呼び出されます
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *userStr;
    NSString *passwardStr;
    userStr=user_id.text;
    passwardStr=user_password.text;
    
    [defaults setObject:userStr forKey:@"ShopUserName"];
    NSLog(@"%@",[defaults objectForKey:@"shopMessage"]);
    
    //NSLog(@"textFieldShouldEndEditing");
    return YES;  //これをNOにすると、キーボードが消えません
}

- (void)viewDidUnload
{
    [self setUser_id:nil];
    [self setUser_password:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backCustomerBt:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)loginBtAction:(id)sender {
    //NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *userStr = @"";
    NSString *passwardStr = @"";
    userStr=user_id.text;
    passwardStr=user_password.text;
    
    
    NSLog(@"%@",userStr);
    NSLog(@"%@",passwardStr);
    
    bool userBool = [userStr isEqualToString:@""];
    bool passBool = [passwardStr isEqualToString:@""];
    
    //[self performSegueWithIdentifier:@"loginView" sender:self];
    
    
    if (userBool && passBool) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"" message:@"ユーザーID、パスワードを入力してください" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil
                              ];
        [alert show];
        
        NSLog(@"u and p not");
        
    }else if(userBool){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"" message:@"ユーザーIDを入れてください" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil
                              ];
        [alert show];
        
        NSLog(@"u not");
        
    }else if(passBool){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"" message:@"パスワードをいれてください" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil
                              ];
        [alert show];
        
        NSLog(@"p not");
        
    }else{
        NSLog(@"post");
        NSString* content = [[NSString alloc]initWithFormat:@"user_id=%@&password=%@",userStr,passwardStr];
        
        NSURL* url = [NSURL URLWithString:@"http://115.31.200.177/nahanomi/daikou_shop_login.php"];
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
        
        NSMutableString *valueStr = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSString *error_str = [error localizedDescription];
        if (0<[error_str length]) {
            NSLog(@"Failed to submit request");
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"通信ができませんでした。" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil
                                  ];
            [alert show];
            
        }else {
            NSLog(@"%@",valueStr);
            bool strb = [valueStr isEqualToString:@"login"];
            if(strb){
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"ログインしました！" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil
                                      ];
                
                [alert show];
                //NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                
                [self performSegueWithIdentifier:@"loginView" sender:self];
                
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"ユーザーID、またはパスワードが間違っています" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil
                                      ];
                
                [alert show];
            }
        }
    }
}
@end
