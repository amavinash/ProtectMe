//
//  ViewController.h
//  ProtectMe
//
//  Created by Avinash Bhandarkar on 1/6/16.
//  Copyright © 2016 Avinash Bhandarkar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController<MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate , NSURLSessionTaskDelegate>
{
    CLLocationManager *locationManager;

}

@property (weak, nonatomic) UILabel *lattitudeValue;
@property (weak, nonatomic) UILabel *longitudeValue;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end

