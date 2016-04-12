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

@end

@implementation SetMessagesViewController

@synthesize messagesArray;

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
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
   
    }

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
    [messageItem setValue:@"Urgent Help Needed! <Location>" forKey:@"messageContent"];
    if (![context save:&error])
    {
        NSLog(@"Can't save %@ %@",error, [error localizedDescription]);
    }
    
    [messageItem setValue:@"Red" forKey:@"messageType"];
    [messageItem setValue:@"Help! I'm in trouble at <Location>" forKey:@"messageContent"];
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
    for (NSManagedObject *messageItem in self.messagesArray) {
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

@end
