//
//  PermissionStatus.m
//  flutter_plugin_permissions
//
//  Created by 王贺天 on 2018/11/23.
//

#import "PermissionStatus.h"

@implementation PermissionStatus

+ (PermissionStatusType)strToPermissionStatus:(NSString *)typeStr
{
    if ([typeStr isEqualToString:@"denied"]){
        return PermissionStatusDenied;
    }else if([typeStr isEqualToString:@"disabled"]){
        return PermissionStatusDisabled;
    }else if([typeStr isEqualToString:@"granted"]){
        return PermissionStatusGranted;
    }else if([typeStr isEqualToString:@"restricted"]){
        return PermissionStatusRestricted;
    }else if([typeStr isEqualToString:@"unknown"]){
        return PermissionStatusUnknown;
    }
    return PermissionStatusUnknown;
}
    
+ (NSString *)permissionStatusToStr:(PermissionStatusType)typeStatus
{
    switch (typeStatus) {
        case PermissionStatusDenied:
        return @"denied";
        break;
        case PermissionStatusGranted:
        return @"granted";
        break;
        case PermissionStatusUnknown:
        return @"unknown";
        break;
        case PermissionStatusDisabled:
        return @"disabled";
        break;
        case PermissionStatusRestricted:
        return @"restricted";
        break;
        
        default:
        return @"unknown";
        break;
    }
}
    
@end
