//
//  KLFacebookUtil.m
//  FacebookOAuth
//
//  Created by Leo Chang on 5/14/15.
//  Copyright (c) 2015 SpringHouse Entertainment Inc. All rights reserved.
//

#import "KLFacebookUtil.h"

@implementation KLFacebookUtil

+ (KLFacebookUtil*)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [KLFacebookUtil new];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _loginManager = [FBSDKLoginManager new];
    }
    return self;
}

- (FBSDKLoginButton*)sharedFacebookLoginButton
{
    if (!_sharedFacebookLoginButton)
    {
        FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
        //setup permissions
        loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends", @"user_likes"];
        loginButton.publishPermissions = @[@"publish_actions"];
        _sharedFacebookLoginButton = loginButton;
    }
    return _sharedFacebookLoginButton;
}

- (void)loginToFacebookCompletion:(BasicHandler)completion
{
    [self.loginManager logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends", @"user_likes"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error)
        {
            // Process error
            if (completion)
            {
                completion(NO, error);
            }
        }
        else if (result.isCancelled)
        {
            if (completion)
            {
                completion(NO, [NSError errorWithDomain:@"" code:UserCancelledErrorCode userInfo:@{@"message":@"User cancelled"}]);
            }
        }
        else
        {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"] && [result.grantedPermissions containsObject:@"public_profile"] && [result.grantedPermissions containsObject:@"user_friends"])
            {
                if (completion)
                {
                    completion(YES, nil);
                }
            }
            else
            {
                if (completion)
                {
                    completion(NO, [NSError errorWithDomain:@"" code:PermissionErrorCode userInfo:@{@"message":@"Permissions not enoungh"}]);
                }
            }
        }
    }];
}

- (void)requestPublishPermissionsCompletion:(BasicHandler)completion
{
    [self.loginManager logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error)
        {
            // Process error
            if (completion)
            {
                completion(NO, error);
            }
        }
        else if (result.isCancelled)
        {
            if (completion)
            {
                completion(NO, [NSError errorWithDomain:@"" code:UserCancelledErrorCode userInfo:@{@"message":@"User cancelled"}]);
            }
        }
        else
        {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"publish_actions"])
            {
                if (completion)
                {
                    completion(YES, nil);
                }
            }
            else
            {
                if (completion)
                {
                    completion(NO, [NSError errorWithDomain:@"" code:PermissionErrorCode userInfo:@{@"message":@"Permissions not enoungh"}]);
                }
            }
        }
    }];
}

- (void)logoutFromFacebook
{
    [self.loginManager logOut];
}

- (BOOL)isFacebookLogin
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        return YES;
    }
    return NO;
}

- (BOOL)canPublish
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        return [[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"];
    }
    return NO;
}

- (void)fetchUserDataForCurrentUserCompletion:(FetchHandler)completion
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 if (completion)
                 {
                     completion(YES, result, error);
                 }
             }
             else
             {
                 if (completion)
                 {
                     completion(NO, result, error);
                 }
             }
         }];
    }
    else
    {
        if (completion)
        {
            completion(NO, nil, [NSError errorWithDomain:@"" code:UserNotLoginErrorCode userInfo:@{@"message":@"user doesn't login"}]);
        }
    }
}

- (void)postMessageToFacebookViaPublishActionsWithParameters:(NSDictionary*)param completion:(PostHandler)completion
{
    if ([self canPublish])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/feed" parameters: param HTTPMethod:@"POST"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 if (completion)
                 {
                     completion(YES, result[@"id"], error);
                 }
             }
             else
             {
                 if (completion)
                 {
                     completion(NO, nil, error);
                 }
             }
         }];
    }
    else
    {
        if (completion)
        {
            completion(NO, nil, [NSError errorWithDomain:@"" code:PermissionErrorCode userInfo:@{@"message":@"Permissions not enoungh"}]);
        }
    }
}

- (void)userLikesCompletion:(FetchHandler)completion
{
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"user_likes"])
    {
        NSString *graphPath = [NSString stringWithFormat:@"me/likes"];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:graphPath parameters:nil HTTPMethod:@"GET"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error)
            {
                if (completion)
                {
                    completion(YES, result, error);
                }
            }
            else
            {
                if (completion)
                {
                    completion(NO, nil, error);
                }
            }
        }];
    }
    else
    {
        if (completion)
        {
            completion(NO, nil, [NSError errorWithDomain:@"" code:PermissionErrorCode userInfo:@{@"message":@"Permissions not enoungh"}]);
        }
    }
}

- (void)userLikesPagesWithObjectId:(NSString*)objectId completion:(BasicHandler)completion
{
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"user_likes"])
    {
        NSString *graphPath = [NSString stringWithFormat:@"me/likes/%@", objectId];
        [[[FBSDKGraphRequest alloc] initWithGraphPath:graphPath parameters:nil HTTPMethod:@"GET"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error)
            {
                if (completion)
                {
                    completion(YES, error);
                }
            }
            else
            {
                if (completion)
                {
                    completion(NO, error);
                }
            }
        }];
    }
    else
    {
        if (completion)
        {
            completion(NO, [NSError errorWithDomain:@"" code:PermissionErrorCode userInfo:@{@"message":@"Permissions not enoungh"}]);
        }
    }
    
}

- (void)userHasPublishWithId:(NSString*)postId completion:(BasicHandler)completion
{
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:postId parameters:nil HTTPMethod:@"GET"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error)
            {
                if (completion)
                {
                    completion(YES, error);
                }
            }
            else
            {
                if (completion)
                {
                    completion(NO, error);
                }
            }
        }];
    }
}


@end
