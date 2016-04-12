//
//  AboutUsViewController.m
//  ProtectMe
//
//  Created by Avinash Bhandarkar on 3/8/16.
//  Copyright © 2016 Avinash Bhandarkar. All rights reserved.
//

#import "AboutUsViewController.h"

@implementation AboutUsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"About ProtectMe";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AboutProtectMe" ofType:@"txt"];
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
        [self.aboutMeMessage setText:data];
    }
}

@end
