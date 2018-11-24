//
//  PermissionGroup.m
//  flutter_plugin_permissions
//
//  Created by 王贺天 on 2018/11/23.
//

#import "PermissionGroup.h"

@implementation PermissionGroup

+ (PermissionGroupType)strToPermissionGroup:(NSString *)typeStr
{
    typeStr = [typeStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    if([typeStr isEqualToString:@"calendar"]){
        return PermissionGroupCalendar;
    }else if([typeStr isEqualToString:@"camera"]){
        return PermissionGroupCamera;
    }else if([typeStr isEqualToString:@"contacts"]){
        return PermissionGroupContacts;
    }else if([typeStr isEqualToString:@"location"]){
        return PermissionGroupLocation;
    }else if([typeStr isEqualToString:@"locationAlways"]){
        return PermissionGroupLocationAlways;
    }else if([typeStr isEqualToString:@"locationWhenInUse"]){
        return PermissionGroupLocationWhenInUse;
    }else if([typeStr isEqualToString:@"mediaLibrary"]){
        return PermissionGroupMediaLibrary;
    }else if([typeStr isEqualToString:@"microphone"]){
        return PermissionGroupMicrophone;
    }else if([typeStr isEqualToString:@"phone"]){
        return PermissionGroupPhone;
    }else if([typeStr isEqualToString:@"photos"]){
        return PermissionGroupPhotos;
    }else if([typeStr isEqualToString:@"reminders"]){
        return PermissionGroupReminders;
    }else if([typeStr isEqualToString:@"sensors"]){
        return PermissionGroupSensors;
    }else if([typeStr isEqualToString:@"sms"]){
        return PermissionGroupSms;
    }else if([typeStr isEqualToString:@"speech"]){
        return PermissionGroupSpeech;
//    }else if([typeStr isEqualToString:@"storage"]){
    }else{
        return PermissionGroupStorage;
    }
//    return PermissionGroupStorage;
}
    
+ (NSString *)permissionGroupToStr:(PermissionGroupType)typeStatus;
    {
        switch (typeStatus) {
            case PermissionGroupCalendar:
            return @"calendar";
            break;
            case PermissionGroupCamera:
            return @"camera";
            break;
            case PermissionGroupContacts:
            return @"contacts";
            break;
            case PermissionGroupLocation:
            return @"location";
            break;
            case PermissionGroupLocationAlways:
            return @"locationAlways";
            break;
            case PermissionGroupLocationWhenInUse:
            return @"locationWhenInUse";
            break;
            case PermissionGroupMediaLibrary:
            return @"mediaLibrary";
            break;
            case PermissionGroupMicrophone:
            return @"microphone";
            break;
            case PermissionGroupPhone:
            return @"phone";
            break;
            case PermissionGroupPhotos:
            return @"photos";
            break;
            case PermissionGroupReminders:
            return @"reminders";
            break;
            case PermissionGroupSensors:
            return @"sensors";
            break;
            case PermissionGroupSms:
            return @"sms";
            break;
            case PermissionGroupSpeech:
            return @"speech";
            break;
            case PermissionGroupStorage:
            return @"storage";
            break;
        }
    }
    
@end
