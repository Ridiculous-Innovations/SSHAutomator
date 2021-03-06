//
//  RIEditTaskViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 16/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIEditTaskViewController.h"
#import <LUIFramework/LUIFramework.h>
#import <RETableViewManager/RETableViewManager.h>
#import "RIBrowserViewController.h"
#import "RITask.h"
#import "NSObject+CoreData.h"


@interface RIEditTaskViewController () <RETableViewManagerDelegate>

@property (nonatomic, readonly) RETableViewManager *manager;

@property (nonatomic, readonly) REBoolItem *taskEnabled;
@property (nonatomic, readonly) RELongTextItem *taskCommand;

@end


@implementation RIEditTaskViewController


#pragma mark Settings

- (void)assignValues {
    if (_task) {
        [_taskEnabled setValue:_task.enabled];
        [_taskCommand setValue:_task.command];
    }
}

- (void)setTask:(RITask *)task {
    _task = task;
    [self assignValues];
}

#pragma mark Creating elements

- (void)createControls {
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:LUITranslate(@"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
    [self.navigationItem setLeftBarButtonItem:cancel];
    
    UIBarButtonItem *browser = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(browsePressed:)];
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:LUITranslate(@"Save") style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    [self.navigationItem setRightBarButtonItems:@[save, browser]];
}

- (void)createTableElements {
    _manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    
    RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:LUITranslate(@"Task details")];
    [_manager addSection:section];
    
    _taskEnabled = [REBoolItem itemWithTitle:LUITranslate(@"Enabled") value:YES];
    [section addItem:_taskEnabled];
    
    _taskCommand = [RELongTextItem itemWithTitle:nil value:nil placeholder:LUITranslate(@"CommandsExampleCode")];
    [_taskCommand setValidators:@[@"presence"]];
    [_taskCommand setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_taskCommand setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_taskCommand setCellHeight:250];
    [section addItem:_taskCommand];

    [self assignValues];
}

- (void)createAllElements {
    [self createTableElements];
    [self createControls];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createAllElements];
}

#pragma mark Actions

- (void)browsePressed:(UIBarButtonItem *)sender {
    __typeof(self) __weak weakSelf = self;
    RIBrowserViewController *c = [[RIBrowserViewController alloc] init];
    [c setInsertPath:^(NSString *path) {
        [weakSelf.taskCommand setValue:[weakSelf.taskCommand.value stringByAppendingString:path]];
        [weakSelf.taskCommand reloadRowWithAnimation:UITableViewRowAnimationNone];
    }];
    [c setAccount:_job.account];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
    [nc.navigationController setToolbarHidden:NO];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)closePressed:(UIBarButtonItem *)sender {
    if (_dismissController) {
        _dismissController(self, nil);
    }
}

- (void)savePressed:(UIBarButtonItem *)sender {
    NSArray *managerErrors = self.manager.errors;
    if (managerErrors.count > 0) {
        NSMutableArray *errors = [NSMutableArray array];
        for (NSError *error in managerErrors) {
            [errors addObject:error.localizedDescription];
        }
        NSString *errorString = [errors componentsJoinedByString:@"\n"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LUITranslate(@"Errors") message:errorString delegate:nil cancelButtonTitle:LUITranslate(@"Ok") otherButtonTitles:nil];
        [alert show];
    }
    else {
        if (!_task) {
            _task = [self.coreData newTaskForJob:_job];
        }
        [_task setEnabled:_taskEnabled.value];
        [_task setCommand:_taskCommand.value];
        [_task setSort:0];
        [self.coreData saveContext];
        if (_dismissController) {
            _dismissController(self, _task);
        }
    }
}


@end
