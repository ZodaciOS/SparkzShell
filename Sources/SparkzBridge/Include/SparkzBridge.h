#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSNotificationName const SparkzOutputNotification;

@interface SparkzEngine : NSObject

- (void)start;
- (void)sendInput:(NSString *)input;

@end

NS_ASSUME_NONNULL_END
