#import "TKToken.h"

@implementation TKToken

- (instancetype) initWithTitle:(NSString *)title value:(id<NSCoding, NSCopying>)value {
	self = [super init];
	if (self) {
		_title = [title copy];
		_value = value;
	}
	return self;
}

@end
