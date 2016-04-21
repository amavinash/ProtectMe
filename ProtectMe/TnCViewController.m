//
//  TnCViewController.m
//  ProtectMe
//
//  Created by Avinash Bhandarkar on 4/13/16.
//  Copyright © 2016 Avinash Bhandarkar. All rights reserved.
//

#import "TnCViewController.h"

@implementation TnCViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Terms & Conditions";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TC" ofType:@"txt"];
    NSError *error = nil;
    NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error)
    {
        UIAlertController *warningAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                              message:@"Error opening file"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        [warningAlert addAction:ok];
        
        [self presentViewController:warningAlert animated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.tncLabel setText:data];
    }
}

@end
