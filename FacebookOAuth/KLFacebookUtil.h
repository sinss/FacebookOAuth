//
//  KLFacebookUtil.h
//  FacebookOAuth
//
//  Created by Leo Chang on 5/14/15.
//  Copyright (c) 2015 SpringHouse Entertainment Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

const static int PermissionErrorCode = 999;
const static int UserCancelledErrorCode = 998;
const static int UserNotLoginErrorCode = 997;

typedef void (^BasicHandler) (BOOL success , NSError *error);
typedef void (^FetchHandler) (BOOL success, id result, NSError *error);
typedef void (^PostHandler) (BOOL success, NSString *postId, NSError *error);

@interface KLFacebookUtil : NSObject

/*
 使用FacebookSDK提供的登入按鈕
 */
@property (nonatomic, strong) FBSDKLoginButton *sharedFacebookLoginButton;
@property (nonatomic, strong) FBSDKLoginManager *loginManager;

+ (KLFacebookUtil*)sharedInstance;

/******************************************************************
 
 Login / Logout
 
 *******************************************************************/

/*
 基本的權限請求
 */
- (void)loginToFacebookCompletion:(BasicHandler)completion;
/*
 Publish的權限需要另外申請
 */
- (void)requestPublishPermissionsCompletion:(BasicHandler)completion;
/*
 使用自已的UI登出
 */
- (void)logoutFromFacebook;
/*
 判斷目前的Facebook登入狀態
 */
- (BOOL)isFacebookLogin;
/*
 判斷是否有權限
 */
- (BOOL)canPublish;

/******************************************************************
 
 Calling Graph API
 
 *******************************************************************/
/*
 Request user's public profile
 */
- (void)fetchUserDataForCurrentUserCompletion:(FetchHandler)completion;

/*
 Post data to Facebook
 @param param : @{ @"message" : @"hello world"}
 */
- (void)postMessageToFacebookViaPublishActionsWithParameters:(NSDictionary*)param completion:(PostHandler)completion;

/*
 User likes form current user
 */
- (void)userLikesCompletion:(FetchHandler)completion;
- (void)userLikesPagesWithObjectId:(NSString*)objectId completion:(BasicHandler)completion;

/*
 1738789776_10200459946178052 ==> NO
 1738789776_10200459949258129 ==> YES
 */
- (void)userHasPublishWithId:(NSString*)postId completion:(BasicHandler)completion;

@end
