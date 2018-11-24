//
//  SpeechPermissionStrategy.m
//  flutter_plugin_permissions
//
//  Created by 王贺天 on 2018/11/23.
//

#import "SpeechPermissionStrategy.h"
#import <Speech/Speech.h>

@implementation SpeechPermissionStrategy

- (PermissionStatusType)checkPermissionStatus:(PermissionGroupType)permission
{
    return PermissionStatusUnknown;
}

- (PermissionStatusType) getPermissionStatus
{
    if (@available(iOS 10.0, *)) {
        SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
        
        return [SpeechPermissionStrategy determinePermissionStatus:status];
    }
    
    return PermissionStatusUnknown;
}

- (void) requestPermission:(PermissionGroupType)permission completionHandler:(PermissionStatusHandler _Nonnull)completionHandler
{
    PermissionStatusType status = [self checkPermissionStatus:permission];
    
    if (status != PermissionStatusUnknown) {
        completionHandler(status);
        return;
    }
    
    if (@available(iOS 10.0, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            completionHandler([SpeechPermissionStrategy determinePermissionStatus:status]);
        }];
    } else {
        completionHandler(PermissionStatusUnknown);
    }
}

+ (PermissionStatusType)determinePermissionStatus:(SFSpeechRecognizerAuthorizationStatus)authorizationStatus
API_AVAILABLE(ios(10.0)){
    switch (authorizationStatus) {
    case SFSpeechRecognizerAuthorizationStatusAuthorized:
        return PermissionStatusGranted;
    case SFSpeechRecognizerAuthorizationStatusDenied:
        return PermissionStatusDenied;
    case SFSpeechRecognizerAuthorizationStatusRestricted:
        return PermissionStatusRestricted;
    default:
        return PermissionStatusUnknown;
    }
}

@end
