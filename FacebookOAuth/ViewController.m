//
//  ViewController.m
//  FacebookOAuth
//
//  Created by Leo Chang on 5/14/15.
//  Copyright (c) 2015 SpringHouse Entertainment Inc. All rights reserved.
//

#import "ViewController.h"
#import "KLFacebookUtil.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FBSDKLoginButton *button = [[KLFacebookUtil sharedInstance] sharedFacebookLoginButton];
    button.frame = CGRectMake(CGRectGetWidth(self.view.frame) / 2, 50, 120, 40);
    [self.view addSubview:button];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshState];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)userProfile:(id)sender
{
    [[KLFacebookUtil sharedInstance] fetchUserDataForCurrentUserCompletion:^(BOOL success, id result, NSError *error){
    
        NSLog(@"%@", result);
    }];
}

- (IBAction)userLikesPress:(id)sender
{
    [[KLFacebookUtil sharedInstance] userLikesCompletion:^(BOOL success, id result, NSError *error) {
    
        NSLog(@"%@", result);
    }];
}

- (IBAction)userLikeSpecificPage:(id)sender
{
    [[KLFacebookUtil sharedInstance] userLikesPagesWithObjectId:@"193831710644458" completion:^(BOOL success, NSError *error){
    
        NSLog(@"status : %@", success ? @"YES" : @"NO");
    }];
}

- (IBAction)userLoginButton:(id)sender
{
    if ([KLFacebookUtil sharedInstance].isFacebookLogin)
    {
        [[KLFacebookUtil sharedInstance] logoutFromFacebook];
        
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    }
    else
    {
        [[KLFacebookUtil sharedInstance] loginToFacebookCompletion:^(BOOL success, NSError *error){
            
            [self refreshState];
            
            NSLog(@"status : %@", success?@"YES":@"NO");
            NSLog(@"error : %@", error);
        }];;
    }
    
}

- (IBAction)userPublishPermissionsButton:(id)sender
{
    if (![KLFacebookUtil sharedInstance].canPublish)
    {
        [[KLFacebookUtil sharedInstance] requestPublishPermissionsCompletion:^(BOOL success, NSError *error){
            
            [self refreshState];
            
            NSLog(@"status : %@", success?@"YES":@"NO");
            NSLog(@"error : %@", error);
        }];
    }
}

- (IBAction)userPostDataButton:(id)sender
{
    [[KLFacebookUtil sharedInstance] postMessageToFacebookViaPublishActionsWithParameters:@{@"message" : @"平安．喜樂"} completion:^(BOOL success, NSString *postId, NSError *error){
    
        if (error)
        {
            if (error.code == PermissionErrorCode)
            {
                
            }
        }
        NSLog(@"post : %@, %@", success?@"YES":@"NO", postId);
        NSLog(@"error : %@", error);
    }];
}

- (IBAction)userPostCheckButton:(id)sender
{
    [[KLFacebookUtil sharedInstance] userHasPublishWithId:@"1738789776_10200459946178052" completion:^(BOOL success, NSError *error){
    
        NSLog(@"status : %@", success?@"YES":@"NO");
        NSLog(@"error : %@", error);
    }];
}

#pragma mark - Private methods
- (void)refreshState
{
    if ([KLFacebookUtil sharedInstance].isFacebookLogin)
    {
        [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    }
    else
    {
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    }
    
    if ([KLFacebookUtil sharedInstance].canPublish)
    {
        [self.publishButton setTitle:@"Has Publish Permission" forState:UIControlStateNormal];
    }
    else
    {
        [self.publishButton setTitle:@"No Publish Permission" forState:UIControlStateNormal];
    }
}

@end
