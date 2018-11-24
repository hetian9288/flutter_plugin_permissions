//
//  ContactPermissionStrategy.m
//  flutter_plugin_permissions
//
//  Created by 王贺天 on 2018/11/23.
//

#import "ContactPermissionStrategy.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>

@implementation ContactPermissionStrategy

- (PermissionStatusType)checkPermissionStatus:(PermissionGroupType)permission
{
    return [ContactPermissionStrategy getPermissionStatus];
}

+ (PermissionStatusType)getPermissionStatus
{
    if(@available(iOS 9.0, *)){
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusAuthorized:
                return PermissionStatusGranted;
                break;
            case CNAuthorizationStatusDenied:
                return PermissionStatusDenied;
                break;
            case CNAuthorizationStatusRestricted:
                return PermissionStatusRestricted;
                break;
                
            default:
                return PermissionStatusUnknown;
                break;
        }
    }else {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        switch (status) {
        case kABAuthorizationStatusAuthorized:
            return PermissionStatusGranted;
        case kABAuthorizationStatusDenied:
            return PermissionStatusDenied;
        case kABAuthorizationStatusRestricted:
            return PermissionStatusRestricted;
        default:
            return PermissionStatusUnknown;
        }
    }
}

- (void) requestPermission:(PermissionGroupType)permission completionHandler:(PermissionStatusHandler _Nonnull)completionHandler
{
    PermissionStatusType permissionStatus = [self checkPermissionStatus:permission];
    if (permissionStatus != PermissionStatusUnknown) {
        completionHandler(permissionStatus);
        return ;
    }
    if(@available(iOS 9.0, *)){
        static CNContactStore *contactStore;
        contactStore =[[CNContactStore alloc]init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL authorized, NSError * _Nullable error) {
            if (authorized) {
                completionHandler(PermissionStatusGranted);
            } else {
                completionHandler(PermissionStatusDenied);
            }
        }];
    }else{
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool authorized, CFErrorRef error) {
            if (authorized) {
                completionHandler(PermissionStatusGranted);
            } else {
                completionHandler(PermissionStatusDenied);
            }
            
            CFRelease(addressBook);
        });
    }
}

@end
