//
//  ViewController.m
//  ProtectMe
//
//  Created by Avinash Bhandarkar on 1/6/16.
//  Copyright © 2016 Avinash Bhandarkar. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic,assign) double lattitudeVal;
@property (nonatomic,assign) double longitudeVal;

@end


@implementation ViewController

@synthesize lattitudeValue,lattitudeVal;
@synthesize longitudeValue,longitudeVal;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager requestLocation];
    void (^testBlock)(void) = ^{
        NSLog(@"This is sample Block");
    };
    testBlock();
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//MessageViewController Delegate Methods
- (IBAction)blueButtonTapped:(id)sender {
    if(![MFMessageComposeViewController canSendText]) {
        
        
        
        UIAlertController *warningAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                              message:@"Your device doesn't support SMS!"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        [warningAlert addAction:ok];
        
        [self presentViewController:warningAlert animated:YES completion:nil];
        
        return;
        
    }
    
    NSArray *recipents = @[@"+12133590044",@"avinashb123@gmail.com"];
    
    NSString *lon = [NSString stringWithFormat:@"%.8f", longitudeVal];
    NSString *lat = [NSString stringWithFormat:@"%.8f", lattitudeVal];
    NSString *locationHyperLink = [NSString stringWithFormat:@"comgooglemaps://?center=%@,%@",lat,lon];
    
    NSString *message = [NSString stringWithFormat:@"HELP!!! I am in Trouble at %@ \nPlease Help me!",locationHyperLink];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    
    messageController.messageComposeDelegate = self;
    
    [messageController setRecipients:recipents];
    
    [messageController setBody:message];
    
    
    
    // Present message view controller on screen
    
    [self presentViewController:messageController animated:YES completion:nil];
}

- (IBAction)redButtonTapped:(id)sender {
    if(![MFMessageComposeViewController canSendText]) {
        
        UIAlertController *warningAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                              message:@"Your device doesn't support SMS!"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        [warningAlert addAction:ok];
        
        [self presentViewController:warningAlert animated:YES completion:nil];
        
        return;
        
    }
    
    NSArray *recipents = @[@"012345678", @"9876543210"];
    
    NSString *message = [NSString stringWithFormat:@"HELP!!! I am in Trouble at <location> Please Help me!"];
    
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    
    messageController.messageComposeDelegate = self;
    
    [messageController setRecipients:recipents];
    
    [messageController setBody:message];
    
    // Present message view controller on screen
    
    [self presentViewController:messageController animated:YES completion:nil];
}


-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        break;
            
        case MessageComposeResultFailed:
        {
            UIAlertController *warningAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                  message:@"Failed to send SMS!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:nil];
            [warningAlert addAction:ok];
            
            [self presentViewController:warningAlert animated:YES completion:nil];
        }
        break;
            
        case MessageComposeResultSent:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        break;
            
        default:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

//Location Manager Delegate Methods

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                        message:@"Failed to get your location" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [errorAlert addAction:Ok];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray*)locations
{
    NSLog(@"didUpdateToLocation: %@", locations);
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        longitudeValue.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        lattitudeValue.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        longitudeVal = currentLocation.coordinate.longitude;
        lattitudeVal = currentLocation.coordinate.latitude;
    }
}

@end
