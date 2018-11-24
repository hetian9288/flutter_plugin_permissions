//
//  EventPermissionStrategy.m
//  flutter_plugin_permissions
//
//  Created by 王贺天 on 2018/11/23.
//

#import "EventPermissionStrategy.h"
#import <EventKit/EventKit.h>

@implementation EventPermissionStrategy

- (PermissionStatusType)checkPermissionStatus:(PermissionGroupType)permission
{
    return [EventPermissionStrategy getPermissionStatus:permission];
}

+ (PermissionStatusType)getPermissionStatus:(PermissionGroupType)permission
{
    EKEntityType entityType;
    if (permission == PermissionGroupCalendar) {
        entityType = EKEntityTypeEvent;
    }else if (permission == PermissionGroupReminders){
        entityType = EKEntityTypeReminder;
    }else {
        return PermissionStatusUnknown;
    }
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:entityType];
    switch (status) {
    case EKAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
    case EKAuthorizationStatusDenied:
            return PermissionStatusDenied;
    case EKAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
    default:
            return PermissionStatusUnknown;
    }
}

- (void) requestPermission:(PermissionGroupType)permission completionHandler:(PermissionStatusHandler _Nonnull)completionHandler
{
    PermissionStatusType permissionStatus = [self checkPermissionStatus:permission];
    if (permissionStatus != PermissionStatusUnknown) {
        completionHandler(permissionStatus);
        return ;
    }
    
    EKEntityType entityType;
    if (permission == PermissionGroupCalendar) {
        entityType = EKEntityTypeEvent;
    }else if (permission == PermissionGroupReminders){
        entityType = EKEntityTypeReminder;
    }else {
        completionHandler(PermissionStatusUnknown);
        return ;
    }
    EKEventStore *store = [[EKEventStore alloc]init];
    [store requestAccessToEntityType:entityType completion:^(BOOL authorized, NSError * _Nullable error) {
        if (authorized) {
            completionHandler(PermissionStatusGranted);
        } else {
            completionHandler(PermissionStatusDenied);
        }
    }];
}

@end
