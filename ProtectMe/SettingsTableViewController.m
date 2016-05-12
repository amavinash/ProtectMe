//
//  SettingsTableViewController.m
//  ProtectMe
//
//  Created by Avinash Bhandarkar on 2/18/16.
//  Copyright © 2016 Avinash Bhandarkar. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "SetNumbersViewController.h"
#import "SetMessagesViewController.h"
#import "AboutUsViewController.h"
#import "ContactUsViewController.h"
#import "TnCViewController.h"

@interface SettingsTableViewController()

@property (copy,nonatomic) NSArray *settingOptions;

@end

@implementation SettingsTableViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.settingOptions = @[@"Set Numbers", @"Set Messages", @"About Us", @"Contact Us",@"Terms & Conditions"];
    self.title = @"ProtectMe";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    //Background image for the view
    NSNumber *screenHeight = @([UIScreen mainScreen].bounds.size.height);
    NSString *imageName = [NSString stringWithFormat:@"waterMark-%@h", screenHeight];
    UIImage *image = [UIImage imageNamed:imageName];
    [self.waterMarkImage setImage:image];
    [self.view sendSubviewToBack:self.waterMarkImage];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.settingOptions count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *simpleIdentifier = @"SimpleCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleIdentifier];
    }
    cell.textLabel.text = [self.settingOptions objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            {
                SetNumbersViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SetNumbersViewController"];
                [self.navigationController pushViewController:dvc animated:YES];
            }
            break;
        case 1:
            {
                SetMessagesViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SetMessagesViewController"];
                [self.navigationController pushViewController:dvc animated:YES];
            }
            break;
        case 2:
            {
                AboutUsViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
                [self.navigationController pushViewController:dvc animated:YES];
            }
            
            break;
        case 3:
            {
                ContactUsViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
                [self.navigationController pushViewController:dvc animated:YES];
            }
            break;
        case 4:
            {
                TnCViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TnCViewController"];
                [self.navigationController pushViewController:dvc animated:YES];
            }
            
        default:
            break;
    }
    
}



@end

