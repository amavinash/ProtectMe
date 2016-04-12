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
    cell.textLabel.text = [contactsArray objectAtIndex:indexPath.row];
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self.contactsArray removeObjectAtIndex:indexPath.row];
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

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    NSString *selectedContactNumber;
    NSString *selectedContactName = [NSString stringWithFormat:@"%@ %@", contact.givenName, contact.familyName];
    for (CNLabeledValue *label in contact.phoneNumbers)
    {
        selectedContactNumber = [label.value stringValue];
        if ([selectedContactNumber length] > 0)
        {
            [self.contactsArray insertObject:selectedContactName atIndex:self.contactsArray.count];
            if (self.contactsArray.count == MAX_NUMBER_OF_CONTACTS)
            {
                [self.manageContactsButton setTitle:MANAGE_CONTACT_STRING forState:UIControlStateNormal];
            }
            break;
        }
    }
    [self.contactsTableView reloadData];
    [self.view setNeedsLayout];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.view setNeedsDisplay];
//    });
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    NSLog(@"Contact Property Selected");
    [self.contactsTableView reloadData];
}

-(void)showAddressBook
{
    contactsPicker = [[CNContactPickerViewController alloc] init];
    [contactsPicker setDelegate:self];
    [self presentViewController:contactsPicker animated:YES completion:nil];
}
@end
