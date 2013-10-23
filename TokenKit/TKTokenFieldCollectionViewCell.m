#import "TKToken.h"
#import "TKTokenFieldCollectionViewCell.h"

@implementation TKTokenFieldCollectionViewCell
@synthesize textLabel = _textLabel;
@synthesize token = _token;

+ (CGSize) sizeForToken:(TKToken *)token {
	static dispatch_once_t onceToken;
	static TKTokenFieldCollectionViewCell *sampler;
	dispatch_once(&onceToken, ^{
		sampler = [self new];
	});
	sampler.textLabel.text = token.title;
	return [sampler sizeThatFits:(CGSize){ 320, 320 }];
}

- (UILabel *) textLabel {
	if (!_textLabel) {
		_textLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
		_textLabel.font = [UIFont boldSystemFontOfSize:20.0f];
		_textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:_textLabel];
	}
	return _textLabel;
}

- (void) setToken:(TKToken *)token {
	if (_token != token) {
		_token = token;
		self.textLabel.text = token.title;
	}
}

- (CGSize) sizeThatFits:(CGSize)size {
	CGSize answer = [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
	return (CGSize){
		ceilf(answer.width) + 40.0f,
		ceilf(answer.height)
	};
}

@end
