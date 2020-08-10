#import "TruecallerSdkPlugin.h"
#if __has_include(<truecaller_sdk/truecaller_sdk-Swift.h>)
#import <truecaller_sdk/truecaller_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "truecaller_sdk-Swift.h"
#endif

@implementation TruecallerSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTruecallerSdkPlugin registerWithRegistrar:registrar];
}
@end
