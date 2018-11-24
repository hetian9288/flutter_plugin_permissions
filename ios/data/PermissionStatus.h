//
//  PermissionStatus.h
//  Pods
//
//  Created by 王贺天 on 2018/11/23.
//

//enum PermissionStatus : String, Codable {
//    case denied = "denied"
//    case disabled = "disabled"
//    case granted = "granted"
//    case restricted = "restricted"
//    case unknown = "unknown"
//}

typedef NS_ENUM(NSInteger, PermissionStatusType){
    PermissionStatusDenied,
    PermissionStatusDisabled,
    PermissionStatusGranted,
    PermissionStatusRestricted,
    PermissionStatusUnknown
};

@interface PermissionStatus : NSObject

+ (PermissionStatusType)strToPermissionStatus:(NSString *)typeStr;
    
+ (NSString *)permissionStatusToStr:(PermissionStatusType)typeStatus;
    
@end

