//
//  SetNumbersViewController.m
//  ProtectMe
//
//  Created by Avinash Bhandarkar on 3/8/16.
//  Copyright © 2016 Avinash Bhandarkar. All rights reserved.
//
//Test Comment for commits

#import "SetNumbersViewController.h"

#define MAX_NUMBER_OF_CONTACTS  5
#define ADD_CONTACT_STRING      @"Add Contact"
#define MANAGE_CONTACT_STRING   @"Manage Contacts"

@interface SetNumbersViewController ()

@property (nonatomic, strong) NSMutableArray *contactsArray;
@property (nonatomic, strong) CNContactPickerViewController *contactsPicker;

@end

@implementation SetNumbersViewController

@synthesize contactsTableView;
@synthesize contactsArray;
@synthesize contactsPicker;


#pragma Mark
#pragma Database Methods

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

-(void)addContactToStoreWithName:(NSString*)name andNumber:(NSString*)number
{
    NSManagedObjectContext *context  = [self managedObjectContext];
    NSManagedObject *newContact = [NSEntityDescription insertNewObjectForEntityForName:@"ContactsTable" inManagedObjectContext:context];
    [newContact setValue:name forKey:@"contactName"];
    [newContact setValue:number forKey:@"contactNumber"];
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Can't save %@ %@",error, [error localizedDescription]);
    }
}

-(void)updateTheView
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"ContactsTable"];
    self.contactsArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.contactsTableView reloadData];
    if (self.contactsArray.count == MAX_NUMBER_OF_CONTACTS)
    {
        [self.manageContactsButton setTitle:MANAGE_CONTACT_STRING forState:UIControlStateNormal];
    }
    [self.view setNeedsLayout];
}

#pragma Mark
#pragma View Methods
- (void)viewWillAppear:(BOOL)animated
{
    // just add this line to the end of this method or create it if it does not exist
    
    [super viewWillAppear:YES];
    
    [self.contactsTableView reloadData];
}

-(void)viewWillLayoutSubviews
{
    NSLog(@"%f",self.view.bounds.size.height);

    CGFloat height = MIN(self.view.bounds.size.height, self.contactsTableView.contentSize.height);
    self.tableViewHeightConstraint.constant = height + 64;
    [self.view layoutIfNeeded];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"ContactsTable"];
    self.contactsArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.contactsTableView reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.contactsTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.title = @"Set Numbers";
    [self.manageContactsButton setTitle:ADD_CONTACT_STRING forState:UIControlStateNormal];
    self.contactsArray = [NSMutableArray array];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *contactCellId = @"ContactNumberCell";
    UITableViewCell *cell = [contactsTableView dequeueReusableCellWithIdentifier:contactCellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactCellId];
    }
    
    NSManagedObject *contactItem = [contactsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [contactItem valueForKey:@"contactName"];
    [cell.detailTextLabel setText:[contactItem valueForKey:@"contactNumber"]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contactsArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.contactsTableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL canEditRow = YES;
    return canEditRow;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [context deleteObject:[self.contactsArray objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if (![context save:&error])
        {
            NSLog(@"Can't save %@ %@",error, [error localizedDescription]);
        }
        [self.contactsArray removeObjectAtIndex:indexPath.row];
        [self.contactsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (indexPath.row < MAX_NUMBER_OF_CONTACTS)
        {
            [self.manageContactsButton setTitle:ADD_CONTACT_STRING forState:UIControlStateNormal];
        }
    }
    [self.contactsTableView setEditing:NO animated:YES];
    [self.contactsTableView reloadData];
    [self.view setNeedsDisplay];
}

#pragma MARK
#pragma Add Button Logic

- (IBAction)addButtonDidClick:(id)sender
{
    if (self.contactsArray.count < MAX_NUMBER_OF_CONTACTS)
    {
        [self showAddressBook];
    }
    else
    {
        [self.contactsTableView setEditing:YES animated:YES];
    }
}

#pragma MARK
#pragma Address Book Methods

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    NSLog(@"Contact Cancelled");
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    CNContact *contact =  contactProperty.contact;
    CNPhoneNumber *phoneNumber = contactProperty.value;
    NSString *selectedContactNumber = [phoneNumber stringValue];
    NSString *selectedContactName = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
    //check if the mobile number is valid and not the land line number
    if ([selectedContactNumber length] > 7)
    {
        [self addContactToStoreWithName:selectedContactName andNumber:selectedContactNumber];
        [self updateTheView];
    }
    else
    {
        // ToDo: Show Alert Here
    }
}

-(void)showAddressBook
{
    contactsPicker = [[CNContactPickerViewController alloc] init];
    [contactsPicker setDelegate:self];
    contactsPicker.displayedPropertyKeys = [NSArray arrayWithObjects:CNContactPhoneNumbersKey, nil];
    [self presentViewController:contactsPicker animated:YES completion:nil];
}
@end
