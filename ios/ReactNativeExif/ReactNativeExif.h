#import <React/RCTBridgeModule.h>

@interface ReactNativeExif : NSObject <RCTBridgeModule>

+ (void)getExif:(NSString *)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
+ (void)getLatLong:(NSString *)path resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;

@end
