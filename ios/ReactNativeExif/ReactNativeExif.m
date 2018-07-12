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

            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {

                NSDictionary *exif = [[[myasset defaultRepresentation] metadata] sanitizedDictionaryForJSONSerialization];
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

            NSData* pngData = [NSData dataWithContentsOfFile:path];

            CGImageSourceRef mySourceRef = CGImageSourceCreateWithData((CFDataRef)pngData, NULL);
            if (mySourceRef != NULL)
            {
                NSDictionary *exif = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(mySourceRef,0,NULL);
                CFRelease(mySourceRef);

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

@end
