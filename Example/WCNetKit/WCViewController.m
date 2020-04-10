//
//  WCViewController.m
//  WCNetKit
//
//  Created by 394771176 on 10/10/2019.
//  Copyright (c) 2019 394771176. All rights reserved.
//

#import "WCViewController.h"
#import <WCNetKit/WCNetManager.h>

@interface WCViewController () <WCNetManagerProtocol>

@end

@implementation WCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [WCNetManager sharedInstance];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"agent = %@", [WCNetManager sharedInstance].userAgent);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
