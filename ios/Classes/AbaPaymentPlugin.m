#import "AbaPaymentPlugin.h"
#if __has_include(<aba_payment/aba_payment-Swift.h>)
#import <aba_payment/aba_payment-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "aba_payment-Swift.h"
#endif

@implementation AbaPaymentPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAbaPaymentPlugin registerWithRegistrar:registrar];
}
@end
