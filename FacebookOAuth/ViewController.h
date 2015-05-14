//
//  ViewController.h
//  FacebookOAuth
//
//  Created by Leo Chang on 5/14/15.
//  Copyright (c) 2015 SpringHouse Entertainment Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *publishButton;

- (IBAction)userProfile:(id)sender;
- (IBAction)userLikesPress:(id)sender;
- (IBAction)userLikeSpecificPage:(id)sender;
- (IBAction)userLoginButton:(id)sender;
- (IBAction)userPublishPermissionsButton:(id)sender;
- (IBAction)userPostDataButton:(id)sender;
- (IBAction)userPostCheckButton:(id)sender;

@end

