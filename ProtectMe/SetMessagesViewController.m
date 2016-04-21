//
//  SetMessagesViewController.m
//  ProtectMe
//
//  Created by Avinash Bhandarkar on 3/8/16.
//  Copyright © 2016 Avinash Bhandarkar. All rights reserved.
//

#import "SetMessagesViewController.h"

@interface SetMessagesViewController ()

@property (nonatomic, strong) NSMutableArray *messagesArray;
//@property (nonatomic, strong) UITextView *currentTextView;

@end

@implementation SetMessagesViewController

@synthesize messagesArray;
@synthesize scrollView;
//@synthesize currentTextView;

UITextView *currentTextView;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Set Messages";
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveMessages)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [self setupKeyboardAccessory];
    self.blueButtonMessageTextView.delegate = self;
    self.redButtonMessageTextView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardDidShowNotification
                                             object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"MessagesTable"];
    self.messagesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for (NSManagedObject *messageItem in self.messagesArray) {
        if ([[messageItem valueForKey:@"messageType"] isEqualToString:@"Red"])
        {
            [self.redButtonMessageTextView setText:[messageItem valueForKey:@"messageContent"]];
        }
        else
        {
            [self.blueButtonMessageTextView setText:[messageItem valueForKey:@"messageContent"]];
        }
    }
}

-(NSManagedObjectContext*)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication]delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)addMessagesToStore
{
    NSManagedObjectContext *context  = [self managedObjectContext];
    NSError *error = nil;
    NSManagedObject *messageItem = [NSEntityDescription insertNewObjectForEntityForName:@"MessagesTable" inManagedObjectContext:context];
    [messageItem setValue:@"Blue" forKey:@"messageType"];
    [messageItem setValue:@"Urgent Help Needed!" forKey:@"messageContent"];
    if (![context save:&error])
    {
        NSLog(@"Can't save %@ %@",error, [error localizedDescription]);
    }
    
    [messageItem setValue:@"Red" forKey:@"messageType"];
    [messageItem setValue:@"Help! I'm in trouble at " forKey:@"messageContent"];
    if (![context save:&error])
    {
        NSLog(@"Can't save %@ %@",error, [error localizedDescription]);
    }
}

-(void)saveMessages
{
    NSManagedObjectContext *context  = [self managedObjectContext];
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"MessagesTable"];
    self.messagesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for (NSManagedObject *messageItem in self.messagesArray)
    {
        if ([[messageItem valueForKey:@"messageType"] isEqualToString:@"Red"])
        {
            [messageItem setValue:self.redButtonMessageTextView.text forKey:@"messageContent"];
        }
        else
        {
            [messageItem setValue:self.blueButtonMessageTextView.text forKey:@"messageContent"];
        }
        if (![context save:&error])
        {
            NSLog(@"Can't save %@ %@",error, [error localizedDescription]);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    currentTextView = textView;
    textView.delegate = self;
}

#pragma mark
#pragma Keyboard methods

-(void)setupKeyboardAccessory
{
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.items = [NSArray arrayWithObjects:
                     [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                     [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneWithTyping)], nil];
    [toolbar sizeToFit];
    self.blueButtonMessageTextView.inputAccessoryView = toolbar;
    self.redButtonMessageTextView.inputAccessoryView = toolbar;
}

-(void)doneWithTyping
{
    [currentTextView resignFirstResponder];
}

-(void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    aRect.size.height -= 50;
    if (!CGRectContainsPoint(aRect, currentTextView.frame.origin)) {

        CGPoint scrollPoint = CGPointMake(0.0,kbSize.height + 64 + 50 - currentTextView.frame.origin.y);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{

    [self.scrollView setContentOffset:CGPointMake(0,-64) animated:YES];
}

@end
