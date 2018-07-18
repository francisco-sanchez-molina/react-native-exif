#include <stdio.h>

#import "ReactNativeExif.h"
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTLog.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSDictionary+JSON.h"

@import Photos;

@implementation ReactNativeExif

RCT_EXPORT_MODULE(ReactNativeExif)

RCT_EXPORT_METHOD(getExif:(NSString *)path resolver:(RCTPromiseResolveBlock)resolve
                          rejecter:(RCTPromiseRejectBlock)reject) {


    @try {

        if([path hasPrefix:@"assets-library"]) {
            printf("assets library");

            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {

                NSDictionary *exif = [[[myasset defaultRepresentation] metadata] sanitizedDictionaryForJSONSerialization];
                NSDictionary *mutableExif = [exif mutableCopy];
                [mutableExif setValue:myasset.defaultRepresentation.filename forKey:@"originalUri"];
                printf("Resolving first");
                resolve(mutableExif);

            };

            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [assetslibrary assetForURL:url
                           resultBlock:resultblock
                          failureBlock:^(NSError *error) {
                              printf("couldnt get photo");
                              NSLog(@"error couldn't get photo");
                              reject(@"exif.getExif", @"Failed to get exif", error);
                          }];

        } else {
            PHFetchResult* assets = [PHAsset fetchAssetsWithLocalIdentifiers:@[path] options:nil];
            
            PHAsset *asset = assets.firstObject;
            if (asset.mediaType == PHAssetMediaTypeImage) {
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    
                    CGImageSourceRef mySourceRef = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
                    if (mySourceRef != NULL)
                    {
                        NSDictionary *exif = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(mySourceRef,0,NULL);
                        CFRelease(mySourceRef);
                        
                        NSDictionary *mutableExif = [exif mutableCopy];
                        [mutableExif setValue:path forKey:@"originalUri"];
                        resolve(mutableExif);
                        return;
                    }
                }];
            }
            
            [NSException raise:@"Invalid local identifier" format:@"Local identifier of %@* is invalid", path];
        }

    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: exception.reason};
        NSError *error = [NSError errorWithDomain:@"world" code:200 userInfo:userInfo];
        reject(@"fail", @"getExif", error);
    }


}

RCT_EXPORT_METHOD(getLatLong:(NSString *)path resolver:(RCTPromiseResolveBlock)resolve
                          rejecter:(RCTPromiseRejectBlock)reject) {
  @try {
    if([path hasPrefix:@"assets-library"]) {
      ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
      {
        CLLocation *location = [myasset valueForProperty:ALAssetPropertyLocation];

        if (! location) {
          return resolve(nil);
        }

        double latitude = location.coordinate.latitude;
        double longitude = location.coordinate.longitude;

        NSMutableDictionary *latLongDict = [[NSMutableDictionary alloc] init];
        [latLongDict setValue:[NSNumber numberWithFloat:latitude] forKey:@"latitude"];
        [latLongDict setValue:[NSNumber numberWithFloat:longitude] forKey:@"longitude"];

        resolve(latLongDict);
      };

      ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
      NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
      [assetslibrary assetForURL:url
                     resultBlock:resultblock
                    failureBlock:^(NSError *error) {
                        NSLog(@"error couldn't get photo");
                        reject(@"exif.getLatLong", @"Failed to get lat long", error);
                    }];

    } else {
      NSData* pngData = [NSData dataWithContentsOfFile:path];

      CGImageSourceRef mySourceRef = CGImageSourceCreateWithData((CFDataRef)pngData, NULL);
      if (mySourceRef != NULL)
      {
          NSDictionary *exif = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(mySourceRef,0,NULL);
          CFRelease(mySourceRef);
          NSDictionary *location = [exif objectForKey:(NSString *)kCGImagePropertyGPSDictionary];

          if (! location) {
            return resolve(nil);
          }
          
          for(NSString *key in [location allKeys]) {
              NSLog(@"%@ : %@",key, [location objectForKey:key]);
          }

          NSNumber *latitude = [location objectForKey:@"Latitude"];
          NSNumber *longitude = [location objectForKey:@"Longitude"];
          NSString *latitudeRef = [location objectForKey:@"LatitudeRef"];
          NSString *longitudeRef = [location objectForKey:@"LongitudeRef"];
          
          if ([@"S" isEqualToString:latitudeRef]) {
              latitude = @(- latitude.doubleValue);
          }
          if ([@"W" isEqualToString:longitudeRef]) {
              longitude = @(- longitude.doubleValue);
          }

          NSMutableDictionary *latLongDict = [[NSMutableDictionary alloc] init];
          [latLongDict setValue:latitude forKey:@"latitude"];
          [latLongDict setValue:longitude forKey:@"longitude"];

          resolve(latLongDict);
      }
    }
  }
  @catch (NSException *exception) {
      NSLog(@"%@", exception.reason);
      NSDictionary *userInfo = @{NSLocalizedDescriptionKey: exception.reason};
      NSError *error = [NSError errorWithDomain:@"world" code:200 userInfo:userInfo];
      reject(@"fail", @"getLatLong", error);
  }
}

RCT_EXPORT_METHOD(getExifWithLocalIdentifier:(NSString *)localIdentifier resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    
    @try {
        
        PHFetchResult* assets = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
        PHAsset *asset = assets.firstObject;
        if (asset.mediaType != PHAssetMediaTypeImage) {
            [NSException raise:@"Asset is not an image" format:@"Asset for provided local identifier %@* is not an image", localIdentifier];
            return;
        }
        
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            CGImageSourceRef mySourceRef = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
            
            if (mySourceRef == NULL) {
                [NSException raise:@"Could not load image" format:@"The image could not be loaded"];
            }
            NSDictionary *exif = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(mySourceRef,0,NULL);
            CFRelease(mySourceRef);
            
            NSDictionary *mutableExif = [exif mutableCopy];
            [mutableExif setValue:localIdentifier forKey:@"originalUri"];
            resolve(mutableExif);
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: exception.reason};
        NSError *error = [NSError errorWithDomain:@"world" code:200 userInfo:userInfo];
        reject(@"fail", @"getExifWithLocalIdentifier", error);
    }
    
}

@end
