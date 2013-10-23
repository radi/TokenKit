#import "TKDeletableTokenCollectionViewCell.h"

@implementation TKDeletableTokenCollectionViewCell

- (BOOL) canBecomeFirstResponder {
	return YES;
}

- (void) delete:(id)sender {
	[self.target delete:self];
}

- (BOOL) canPerformAction:(SEL)action withSender:(id)sender {
	return self.token && (0 == strcmp(sel_getName(action), sel_getName(@selector(delete:))));
}

@end
