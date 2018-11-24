//
//  MediaLibraryPermissionStrategy.m
//  flutter_plugin_permissions
//
//  Created by 王贺天 on 2018/11/23.
//

#import "MediaLibraryPermissionStrategy.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation MediaLibraryPermissionStrategy

- (PermissionStatusType)checkPermissionStatus:(PermissionGroupType)permission
{
    return [MediaLibraryPermissionStrategy getPermissionStatus];
}

+ (PermissionStatusType) getPermissionStatus
{
    if (@available(iOS 9.3, *)) {
        MPMediaLibraryAuthorizationStatus status  = [MPMediaLibrary authorizationStatus];

        return [MediaLibraryPermissionStrategy determinePermissionStatus:status];
    }
    
    return PermissionStatusUnknown;
}

+ (PermissionStatusType) determinePermissionStatus:(MPMediaLibraryAuthorizationStatus)authorizationStatus
API_AVAILABLE(ios(9.3)){
    switch (authorizationStatus) {
    case MPMediaLibraryAuthorizationStatusAuthorized:
        return PermissionStatusGranted;
    case MPMediaLibraryAuthorizationStatusDenied:
        return PermissionStatusDenied;
    case MPMediaLibraryAuthorizationStatusRestricted:
        return PermissionStatusRestricted;
    default:
        return PermissionStatusUnknown;
    }
}

- (void) requestPermission:(PermissionGroupType)permission completionHandler:(PermissionStatusHandler _Nonnull)completionHandler
{
    PermissionStatusType status = [self checkPermissionStatus:permission];
    if (status != PermissionStatusUnknown) {
        completionHandler(status);
        return;
    }
    
    if (@available(iOS 9.3, *))  {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
            PermissionStatusType _status =  [MediaLibraryPermissionStrategy determinePermissionStatus:status];
            completionHandler(_status);
        }];
    } else {
        completionHandler(PermissionStatusUnknown);
        return ;
    }
}

@end
