//
//  SetMessagesViewController.h
//  ProtectMe
//
//  Created by Avinash Bhandarkar on 3/8/16.
//  Copyright © 2016 Avinash Bhandarkar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SetMessagesViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *blueButtonMessageTextView;
@property (weak, nonatomic) IBOutlet UITextView *redButtonMessageTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end
