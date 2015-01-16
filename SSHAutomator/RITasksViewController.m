//
//  RITasksViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RITasksViewController.h"
#import "RIEditTaskViewController.h"
#import "RITasksViewController.h"
#import "RITasksTableView.h"
#import "RITasksController.h"
#import "RIJob.h"
#import "RIRunJob.h"


@interface RITasksViewController () <UITableViewDelegate>

@property (nonatomic, readonly) RITasksController *controller;
@property (nonatomic, readonly) RITasksTableView *tableView;

@property (nonatomic, readonly) UIBarButtonItem *editButton;
@property (nonatomic, readonly) UIBarButtonItem *doneButton;
@property (nonatomic, readonly) UIBarButtonItem *addButton;

@end


@implementation RITasksViewController


#pragma mark Creating elements

- (void)createControlButtons {
    _editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
    _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editPressed:)];
    _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTaskPressed:)];
    
    [self.navigationItem setRightBarButtonItems:@[_editButton, _addButton]];
}

- (void)createTableView {
    _tableView = [[RITasksTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setDataSource:_controller];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
    [self createControlButtons];
}

#pragma mark Settings

- (void)setJob:(RIJob *)job {
    _job = job;
    
    [self setTitle:_job.name];
    
    __typeof(self) __weak weakSelf = self;
    _controller = [[RITasksController alloc] init];
    [_controller setJob:_job];
    [_controller setRequiresReload:^{
        [weakSelf reloadData];
    }];
}

- (void)reloadData {
    [_controller reloadData];
    [_tableView reloadData];
}

#pragma mark Actions

- (void)addTaskPressed:(UIBarButtonItem *)sender {
    __typeof(self) __weak weakSelf = self;
    RIEditTaskViewController *c = [[RIEditTaskViewController alloc] init];
    [c setJob:_job];
    [c setDismissController:^(RIEditTaskViewController *controller, RITask *task) {
        if (task) {
            [_controller saveOrder];
        }
        [weakSelf reloadData];
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)editPressed:(UIBarButtonItem *)sender {
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    [self.navigationItem setRightBarButtonItems:@[(_tableView.isEditing ? _doneButton : _editButton), _addButton] animated:YES];
}

#pragma mark Initialization

- (void)setup {
    [super setup];
}

#pragma mark Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [RIRunJob run:_job];
    }
    else {
        __typeof(self) __weak weakSelf = self;
        RIEditTaskViewController *c = [[RIEditTaskViewController alloc] init];
        [c setJob:_job];
        [c setTask:[_controller taskAtIndexPath:indexPath]];
        [c setDismissController:^(RIEditTaskViewController *controller, RITask *task) {
            [weakSelf reloadData];
            [controller dismissViewControllerAnimated:YES completion:nil];
        }];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
        [self presentViewController:nc animated:YES completion:nil];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


@end
