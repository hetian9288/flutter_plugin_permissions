//
//  UnknownPermissionStrategy.m
//  flutter_plugin_permissions
//
//  Created by 王贺天 on 2018/11/23.
//

#import "UnknownPermissionStrategy.h"

@implementation UnknownPermissionStrategy

- (PermissionStatusType)checkPermissionStatus:(PermissionGroupType)permission
{
    return PermissionStatusUnknown;
}

- (void) requestPermission:(PermissionGroupType)permission completionHandler:(PermissionStatusHandler _Nonnull)completionHandler
{
    completionHandler(PermissionStatusUnknown);
}

@end
