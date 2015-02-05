//
//  ViewController.m
//  SSHAutomator
//
//  Created by Ondrej Rafaj on 15/01/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "RIViewController.h"


@interface RIViewController ()

@end


@implementation RIViewController


#pragma mark Creating elements

- (void)createAllElements {
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark View lifecycle

- (void)loadView {
    [super loadView];
    
    [self createAllElements];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark Initialization

- (void)setup {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
