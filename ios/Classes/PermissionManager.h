//
//  PermissionManager.h
//  flutter_plugin_permissions
//
//  Created by 王贺天 on 2018/11/23.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import "PermissionGroup.h"
#import "PermissionStatus.h"
#import "PermissionStrategy.h"
#import "AudioVideoPermissionStrategy.h"
#import "ContactPermissionStrategy.h"
#import "EventPermissionStrategy.h"
#import "LocationPermissionStrategy.h"
#import "MediaLibraryPermissionStrategy.h"
#import "PhotoPermissionStrategy.h"
#import "SpeechPermissionStrategy.h"
#import "SensorPermissionStrategy.h"
#import "UnknownPermissionStrategy.h"

typedef void (^PermissionRequestCompletion)(NSDictionary *permissionRequestResults);
@interface PermissionManager : NSObject

+ (void) checkPermissionStatus:(PermissionGroupType) permission result:(FlutterResult)result;
+ (void) openAppSettings:(FlutterResult)result;
+ (PermissionStrategy *) createPermissionStrategy:(PermissionGroupType) permission;
- (void) requestPermissions:(NSMutableArray<NSNumber *>*) permissions completion:(PermissionRequestCompletion)completion;

@end
