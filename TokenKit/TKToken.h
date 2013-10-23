#import <Foundation/Foundation.h>

@interface TKToken : NSObject

- (instancetype) initWithTitle:(NSString *)title value:(id<NSCoding, NSCopying>)value;

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, strong) id<NSCoding, NSCopying> value;

@end
