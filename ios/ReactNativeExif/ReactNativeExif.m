#import "ReactNativeExif.h"
#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "RCTLog.h"
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
                NSMutableDictionary *mutableExif = [NSMutableDictionary exif];

                [mutableExif setValue:myasset.defaultRepresentation.url forKey:@"originalUri"];   
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
                
                NSMutableDictionary *mutableExif = [NSMutableDictionary exif];
                [mutableExif setValue:path forKey:@"originalUri"];   
                resolve(mutableExif);
            }
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        NSError *error = [NSError errorWithDomain:@"world" code:200 userInfo:@"error"];
        reject(@"fail", @"getExif", error);
    }


}

@end