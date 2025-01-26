//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<dojah_flutter_sdk/DojahFlutterSdkPlugin.h>)
#import <dojah_flutter_sdk/DojahFlutterSdkPlugin.h>
#else
@import dojah_flutter_sdk;
#endif

#if __has_include(<integration_test/IntegrationTestPlugin.h>)
#import <integration_test/IntegrationTestPlugin.h>
#else
@import integration_test;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [DojahFlutterSdkPlugin registerWithRegistrar:[registry registrarForPlugin:@"DojahFlutterSdkPlugin"]];
  [IntegrationTestPlugin registerWithRegistrar:[registry registrarForPlugin:@"IntegrationTestPlugin"]];
}

@end
