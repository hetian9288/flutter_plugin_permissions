//
//  LocationPermissionStrategy.m
//  flutter_plugin_permissions
//
//  Created by 王贺天 on 2018/11/23.
//

#import "LocationPermissionStrategy.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationPermissionStrategy ()

@property (nonatomic, copy)PermissionStatusHandler _permissionStatusHandler;
@property (nonatomic) PermissionGroupType _requestedPermission;
@property (nonatomic) CLLocationManager *_locationManager;

@end
@implementation LocationPermissionStrategy
static LocationPermissionStrategy *tools;
+(instancetype)shareUserInfo {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[self alloc] init];
    });
    return tools;
}

- (PermissionStatusType)checkPermissionStatus:(PermissionGroupType)permission
{
    return [LocationPermissionStrategy getPermissionStatus:permission];
}

+ (PermissionStatusType)getPermissionStatus:(PermissionGroupType)permission
{
    BOOL isLocation = [CLLocationManager locationServicesEnabled];
    if (!isLocation) {
        return PermissionStatusDisabled;;
    }
    
    CLAuthorizationStatus status  = [CLLocationManager authorizationStatus];
    
    return [LocationPermissionStrategy determinePermissionStatus:permission authorizationStatus:status];
}

+ (PermissionStatusType) determinePermissionStatus:(PermissionGroupType)permission authorizationStatus:(CLAuthorizationStatus)authorizationStatus
{
    if (@available(iOS 8.0, *)) {
        if (permission == PermissionGroupLocationAlways) {
            switch (authorizationStatus) {
                case kCLAuthorizationStatusAuthorizedAlways:
                return PermissionStatusGranted;
                case kCLAuthorizationStatusAuthorizedWhenInUse:
                case kCLAuthorizationStatusDenied:
                return PermissionStatusDenied;
                case kCLAuthorizationStatusRestricted:
                return PermissionStatusRestricted;
            default:
                return PermissionStatusUnknown;
            }
        }
        
        switch (authorizationStatus) {
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            return PermissionStatusGranted;
            case kCLAuthorizationStatusDenied:
            return PermissionStatusDenied;
            case kCLAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        default:
            return PermissionStatusUnknown;
        }
    }
    
    switch (authorizationStatus) {
        case kCLAuthorizationStatusAuthorizedAlways:
        return PermissionStatusGranted;
        case kCLAuthorizationStatusDenied:
        return PermissionStatusDenied;
        case kCLAuthorizationStatusRestricted:
        return PermissionStatusRestricted;
        default:
        return PermissionStatusUnknown;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        return;
    }
    
    [LocationPermissionStrategy determinePermissionStatus:__requestedPermission authorizationStatus:status];
}

- (void) requestPermission:(PermissionGroupType)permission completionHandler:(PermissionStatusHandler _Nonnull)completionHandler
{
    PermissionStatusType permissionStatus = [self checkPermissionStatus:permission];
    if (permissionStatus != PermissionStatusUnknown) {
        completionHandler(permissionStatus);
        return;
    }
    
    __requestedPermission = permission;
    [LocationPermissionStrategy shareUserInfo]._permissionStatusHandler = completionHandler;
    
    __locationManager =[[CLLocationManager alloc] init];
    
    static CLLocationManager *manager;
    manager =[[CLLocationManager alloc] init];

    if (permission == PermissionGroupLocation) {
        [manager requestAlwaysAuthorization];//一直获取定位信息
    }else if(permission == PermissionGroupLocationAlways){
        [manager requestAlwaysAuthorization];//一直获取定位信息
    }else if(permission == PermissionGroupLocationWhenInUse){
        [manager requestWhenInUseAuthorization];//使用的时候获取定位信息
    }
    
    manager.delegate =[LocationPermissionStrategy shareUserInfo];
    
}

@end
