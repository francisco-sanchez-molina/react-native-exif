#import "ReactNativeExif.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "RCTLog.h"
@import Photos;

@implementation ReactNativeExif

RCT_EXPORT_MODULE(ReactNativeExif)

RCT_EXPORT_METHOD(getExif:(NSString *)path resolver:(RCTPromiseResolveBlock)resolve
                          rejecter:(RCTPromiseRejectBlock)reject) {
  
    @try {

        UIImage * myImage = [UIImage imageWithContentsOfFile: path];
        NSData* pngData =  UIImageJPEGRepresentation(myImage, 1.0);
        
        CGImageSourceRef mySourceRef = CGImageSourceCreateWithData((CFDataRef)pngData, NULL);
        if (mySourceRef != NULL)
        {
            NSDictionary *myMetadata = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(mySourceRef,0,NULL);
            resolve(myMetadata);
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        NSError *error = [NSError errorWithDomain:@"world" code:200 userInfo:@"error"];
        reject(@"fail", @"getExif", error);
    }


}

@end