//
//  AudioVideoPermissionStrategy.m
//  flutter_plugin_permissions
//
//  Created by 王贺天 on 2018/11/23.
//

#import "AudioVideoPermissionStrategy.h"
#import <AVFoundation/AVFoundation.h>
#import "PermissionGroup.h"
#import "PermissionStatus.h"

@implementation AudioVideoPermissionStrategy

- (PermissionStatusType)checkPermissionStatus:(PermissionGroupType)permission
{
    if (permission == PermissionGroupCamera) {
        return [AudioVideoPermissionStrategy getPermissionStatus:AVMediaTypeVideo];
    } else if (permission == PermissionGroupMicrophone) {
        return [AudioVideoPermissionStrategy getPermissionStatus:AVMediaTypeAudio];
    }
    return PermissionStatusUnknown;
}

+ (PermissionStatusType) getPermissionStatus:(AVMediaType)mediaType
{
    AVAuthorizationStatus avAuthorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    switch (avAuthorizationStatus) {
    case AVAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
    case AVAuthorizationStatusDenied:
            return PermissionStatusDenied;
    case AVAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
    default:
            return PermissionStatusUnknown;
    }
}

- (void) requestPermission:(PermissionGroupType)permission completionHandler:(PermissionStatusHandler _Nonnull)completionHandler
{
    PermissionStatusType statusType = [self checkPermissionStatus:permission];
    if (statusType != PermissionStatusUnknown) {
        completionHandler(statusType);
        return ;
    }
    
    AVMediaType mediaType;
    
    if (permission == PermissionGroupCamera) {
        mediaType = AVMediaTypeVideo;
    } else if (permission == PermissionGroupMicrophone) {
        mediaType = AVMediaTypeAudio;
    } else {
        completionHandler(PermissionStatusUnknown);
        return;
    }
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if(granted == YES) {
            completionHandler(PermissionStatusGranted);
        }else {
            completionHandler(PermissionStatusDenied);
        }
    }];
}

@end
