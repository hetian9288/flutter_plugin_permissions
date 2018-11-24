//
//  PermissionStrategy.h
//  flutter_plugin_permissions
//
//  Created by 王贺天 on 2018/11/24.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PermissionGroup.h"
#import "PermissionStatus.h"

typedef void(^PermissionStatusHandler)(PermissionStatusType permission);

@interface PermissionStrategy : NSObject

- (PermissionStatusType)checkPermissionStatus:(PermissionGroupType)permission;
- (void) requestPermission:(PermissionGroupType)permission completionHandler:(PermissionStatusHandler _Nonnull)completionHandler;
@end
