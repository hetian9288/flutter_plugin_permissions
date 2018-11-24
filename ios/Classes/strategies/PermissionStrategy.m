//
//  PermissionStrategy.m
//  flutter_plugin_permissions
//
//  Created by 王贺天 on 2018/11/24.
//

#import "PermissionStrategy.h"

@implementation PermissionStrategy

- (PermissionStatusType)checkPermissionStatus:(PermissionGroupType)permission
{
    return PermissionStatusUnknown;
}
- (void) requestPermission:(PermissionGroupType)permission completionHandler:(PermissionStatusHandler _Nonnull)completionHandler
{}

@end
