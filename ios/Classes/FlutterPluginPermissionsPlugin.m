#import "FlutterPluginPermissionsPlugin.h"
#import "PermissionGroup.h"
#import "PermissionStatus.h"
#import "PermissionManager.h"
#import "PermissionManager.h"

@interface FlutterPluginPermissionsPlugin ()

@property (readwrite) PermissionManager *permissionManager;

@end

@implementation FlutterPluginPermissionsPlugin

- (instancetype)init {
    self = [super init];
    if (!self) {
        return NULL;
    }
    
    self.permissionManager = [[PermissionManager alloc] init];
    
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_plugin_permissions"
            binaryMessenger:[registrar messenger]];
  FlutterPluginPermissionsPlugin* instance = [[FlutterPluginPermissionsPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}



- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    FlutterResult _methodResult;
  if ([@"checkPermissionStatus" isEqualToString:call.method]) {
      [PermissionManager checkPermissionStatus:[PermissionGroup strToPermissionGroup:call.arguments] result:result];
  } else if([@"requestPermissions" isEqualToString:call.method]) {
      if (_methodResult != NULL) {
          result([FlutterError errorWithCode:@"ERROR_ALREADY_REQUESTING_PERMISSIONS" message:@"A request for permissions is already running, please wait for it to finish before doing another request (note that you can request multiple permissions at the same time)." details:NULL]);
      }
      _methodResult = result;
      //转换成二进制数据
      NSData * data = [call.arguments dataUsingEncoding:NSUTF8StringEncoding];
      
      //解析JSON文件 OC中自带的方法
      NSMutableArray<NSString *> *tags = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
      NSMutableArray<NSNumber *>* permissions = [[NSMutableArray alloc] init];
      
      for (NSString *group in tags) {
          [permissions addObject:[NSNumber numberWithInteger:[PermissionGroup strToPermissionGroup:group]]];
      }
      [self.permissionManager requestPermissions:permissions completion:^(NSDictionary * _Nonnull permissionRequestResults) {
          result([self convertToJsonData:permissionRequestResults]);
      }];
      
  } else if([@"shouldShowRequestPermissionRationale" isEqualToString:call.method]){
      result(false);
  }else if([@"openAppSettings" isEqualToString:call.method]) {
      [PermissionManager openAppSettings:result];
  } else {
      result(FlutterMethodNotImplemented);
  }
}

-(NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

@end
