//
//  SensorPermissionStrategy.m
//  flutter_plugin_permissions
//
//  Created by 王贺天 on 2018/11/23.
//

#import "SensorPermissionStrategy.h"
#import <CoreMotion/CoreMotion.h>

@interface SensorPermissionStrategy ()

@property (nonatomic) CMMotionActivityManager *_motionActivityManager;
@end

@implementation SensorPermissionStrategy

- (PermissionStatusType)checkPermissionStatus:(PermissionGroupType)permission
{
    return [SensorPermissionStrategy getPermissionStatus];
}

+ (PermissionStatusType) getPermissionStatus
{
    if ([CMMotionActivityManager isActivityAvailable] == NO) {
        return PermissionStatusDisabled;
    }
    
    if(@available(iOS 11.0, *)) {
        CMAuthorizationStatus status = [CMMotionActivityManager authorizationStatus];
        
        switch (status) {
        case CMAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
        case CMAuthorizationStatusDenied:
            return PermissionStatusDenied;
        case CMAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        default:
            return PermissionStatusUnknown;
        }
    }
    
    return PermissionStatusUnknown;
}

- (void) requestPermission:(PermissionGroupType)permission completionHandler:(PermissionStatusHandler _Nonnull)completionHandler
{
    PermissionStatusType status = [self checkPermissionStatus:permission];
    
    if (status != PermissionStatusUnknown) {
        completionHandler(status);
        return ;
    }
    
    if (@available(iOS 11.0, *)) {
        __motionActivityManager = [[CMMotionActivityManager alloc] init];
        [__motionActivityManager startActivityUpdatesToQueue:[[NSOperationQueue alloc] init]
                                                withHandler:
         ^(CMMotionActivity *activity) {
             completionHandler(PermissionStatusGranted);
         }];
    } else {
        completionHandler(PermissionStatusUnknown);
    }
}

@end
