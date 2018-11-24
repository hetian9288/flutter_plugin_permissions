//
//  PhotoPermissionStrategy.m
//  flutter_plugin_permissions
//
//  Created by 王贺天 on 2018/11/23.
//

#import "PhotoPermissionStrategy.h"
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#import <Photos/Photos.h>
//#else
#import <AssetsLibrary/AssetsLibrary.h>
//#endif

@implementation PhotoPermissionStrategy

- (PermissionStatusType)checkPermissionStatus:(PermissionGroupType)permission
{
    return [PhotoPermissionStrategy getPermissionStatu];
}

+ (PermissionStatusType)getPermissionStatu
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    return [PhotoPermissionStrategy determinePermissionStatus:status];
}

- (void) requestPermission:(PermissionGroupType)permission completionHandler:(PermissionStatusHandler _Nonnull)completionHandler
{
    PermissionStatusType status = [self checkPermissionStatus:permission];
    
    if(status != PermissionStatusUnknown) {
        completionHandler(status);
        return ;
    }
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus authorizationStatus) {
        completionHandler([PhotoPermissionStrategy determinePermissionStatus:authorizationStatus]);
    }];
}

+ (PermissionStatusType) determinePermissionStatus:(PHAuthorizationStatus) authorizationStatus
{
    switch (authorizationStatus) {
    case PHAuthorizationStatusAuthorized:
        return PermissionStatusGranted;
    case PHAuthorizationStatusDenied:
        return PermissionStatusDenied;
    case PHAuthorizationStatusRestricted:
        return PermissionStatusRestricted;
    default:
        return PermissionStatusUnknown;
    }
}

@end
