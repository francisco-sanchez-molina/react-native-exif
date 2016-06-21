#import <UIKit/UIKit.h>
#import "RCTLog.h"
#import "RCTBridgeModule.h"


@interface Exif : NSObject <RCTBridgeModule>
@end

@implementation Exif

RCT_EXPORT_MODULE(Exif)

RCT_EXPORT_METHOD(getExif(successCallback:(NSString *)path (RCTResponseSenderBlock)callback,errorCallback:(RCTResponseSenderBlock)callback )) {
  
  
}

@end