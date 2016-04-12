//
//  SetNumbersViewController.h
//  ProtectMe
//
//  Created by Avinash Bhandarkar on 3/8/16.
//  Copyright © 2016 Avinash Bhandarkar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <CoreData/CoreData.h>

//Test Comment for commits

@interface SetNumbersViewController : UIViewController<UITableViewDataSource , UITableViewDelegate , ABPeoplePickerNavigationControllerDelegate, CNContactPickerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@property (weak, nonatomic) IBOutlet UIButton *manageContactsButton;

@end
