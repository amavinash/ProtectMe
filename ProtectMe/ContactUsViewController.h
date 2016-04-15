//
//  ContactUsViewController.h
//  ProtectMe
//
//  Created by Avinash Bhandarkar on 3/8/16.
//  Copyright © 2016 Avinash Bhandarkar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *gmailButton;
@property (weak, nonatomic) IBOutlet UIView *phoneNumberButton;
@property (weak, nonatomic) IBOutlet UIView *twitterButton;
@property (weak, nonatomic) IBOutlet UIView *skypeButton;
- (IBAction)gmailButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButtonClicked;
@property (weak, nonatomic) IBOutlet UIButton *twitterButtonClicked;
@property (weak, nonatomic) IBOutlet UIButton *skypeButtonClicked;

@end
