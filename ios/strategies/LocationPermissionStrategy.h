//
//  LocationPermissionStrategy.h
//  flutter_plugin_permissions
//
//  Created by 王贺天 on 2018/11/23.
//

#import "PermissionStrategy.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationPermissionStrategy : PermissionStrategy <CLLocationManagerDelegate>

@end

NS_ASSUME_NONNULL_END
