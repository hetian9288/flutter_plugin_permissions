//
//  Header.h
//  Pods
//
//  Created by 王贺天 on 2018/11/23.
//

typedef NS_ENUM(NSInteger, PermissionGroupType) {
    PermissionGroupCalendar,
    PermissionGroupCamera,
    PermissionGroupContacts,
    PermissionGroupLocation,
    PermissionGroupLocationAlways,
    PermissionGroupLocationWhenInUse,
    PermissionGroupMediaLibrary,
    PermissionGroupMicrophone,
    PermissionGroupPhone,
    PermissionGroupPhotos,
    PermissionGroupReminders,
    PermissionGroupSensors,
    PermissionGroupSms,
    PermissionGroupSpeech,
    PermissionGroupStorage
};

@interface PermissionGroup : NSObject
    
+ (PermissionGroupType)strToPermissionGroup:(NSString *)typeStr;
    
+ (NSString *)permissionGroupToStr:(PermissionGroupType)typeStatus;
    
@end
