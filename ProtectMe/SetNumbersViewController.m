//
//  SetNumbersViewController.m
//  ProtectMe
//
//  Created by Avinash Bhandarkar on 3/8/16.
//  Copyright © 2016 Avinash Bhandarkar. All rights reserved.
//

#import "SetNumbersViewController.h"

#define NUMBER_OF_CONTACTS 5

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
    [self.contactsTableView reloadData];
    CGFloat height = MIN(self.view.bounds.size.height, self.contactsTableView.contentSize.height);
    self.tableViewHeight.constant = height;
    [self.view layoutIfNeeded];
}

//-(void)viewDidLayoutSubviews
//{
//    CGFloat height = MIN(self.view.bounds.size.height, self.contactsTableView.contentSize.height);
//    self.tableViewHeight.constant = height;
//    [self.view layoutIfNeeded];
//}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Set Numbers";
    self.contactsArray = [NSMutableArray arrayWithObjects:@"Add Number", nil];
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
    if (self.contactsArray.count < 6)
    {
        if (indexPath.row == self.contactsArray.count - 1) {
            [self showAddressBook];
        }
    }
    else
    {
        
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL canEditRow = YES;
    if (indexPath.row == self.contactsArray.count - 1 && self.contactsArray.count != 5) {
        canEditRow = NO;
    }
    return canEditRow;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self.contactsArray removeObjectAtIndex:indexPath.row];
        if (indexPath.row == 4)
        {
            [self.contactsArray addObject:@"Add Number"];
        }
    }
    [self.contactsTableView reloadData];
    [self.view setNeedsLayout];
    [self.view layoutSubviews];
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
    for (CNLabeledValue *label in contact.phoneNumbers) {
        selectedContactNumber = [label.value stringValue];
        if ([selectedContactNumber length] > 0)
        {
            [self.contactsArray insertObject:selectedContactName atIndex:self.contactsArray.count - 1];
            if (self.contactsArray.count == 6)
            {
                [self.contactsArray removeLastObject];
            }
            return;
        }
    }
    [self.contactsTableView reloadData];
    [self.view setNeedsLayout];
    [self.view layoutSubviews];
}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    NSLog(@"Contact Property Selected");
}

-(void)showAddressBook{
    contactsPicker = [[CNContactPickerViewController alloc] init];
    [contactsPicker setDelegate:self];
    [self presentViewController:contactsPicker animated:YES completion:nil];
}
@end
