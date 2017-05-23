#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

- (NSDictionary *)sanitizedDictionaryForJSONSerialization {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        return self;
    }

    NSMutableDictionary *sanitizedSelf = [NSMutableDictionary new];

    for (NSString *key in self) {
        id value = self[key];
        if ([value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSNumber class]] ||
            [value isKindOfClass:[NSArray class]] ||
            [value isKindOfClass:[NSNull class]]) {
            sanitizedSelf[key] = value;
        }

        if ([value isKindOfClass:[NSDictionary class]]) {
            sanitizedSelf[key] = [(NSDictionary *)value sanitizedDictionaryForJSONSerialization];
        }
    }

    return sanitizedSelf;
}

@end
