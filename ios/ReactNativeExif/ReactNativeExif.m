#import "ReactNativeExif.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTLog.h>
#import <AssetsLibrary/AssetsLibrary.h>

@import Photos;

@implementation ReactNativeExif

RCT_EXPORT_MODULE(ReactNativeExif)

RCT_EXPORT_METHOD(getExif:(NSString *)path resolver:(RCTPromiseResolveBlock)resolve
                          rejecter:(RCTPromiseRejectBlock)reject) {
  
    
    @try {

        if([path hasPrefix:@"assets-library"]) {
            
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {
                
                NSDictionary *exif = [[myasset defaultRepresentation] metadata];
                NSDictionary *mutableExif = [exif mutableCopy];
                [mutableExif setValue:myasset.defaultRepresentation.filename forKey:@"originalUri"];   
                resolve(mutableExif);
                
            };
            
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [assetslibrary assetForURL:url
                           resultBlock:resultblock
                          failureBlock:^(NSError *error) {
                              NSLog(@"error couldn't get photo");
                          }];
            
        } else {
        
            UIImage * myImage = [UIImage imageWithContentsOfFile: path];
            NSData* pngData =  UIImageJPEGRepresentation(myImage, 1.0);
        
            CGImageSourceRef mySourceRef = CGImageSourceCreateWithData((CFDataRef)pngData, NULL);
            if (mySourceRef != NULL)
            {
                NSDictionary *exif = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(mySourceRef,0,NULL);
                
                NSDictionary *mutableExif = [exif mutableCopy];
                [mutableExif setValue:path forKey:@"originalUri"];   
                resolve(mutableExif);
            }
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: exception.reason};
        NSError *error = [NSError errorWithDomain:@"world" code:200 userInfo:userInfo];
        reject(@"fail", @"getExif", error);
    }


}

@end
