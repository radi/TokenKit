#import "TKToken.h"
#import "TKTokenFieldCollectionViewCell.h"
#import "TKTokenField.h"
#import "TKTokenFieldCollectionViewFlowLayout.h"

@interface TKTokenField () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, readonly, strong) UICollectionViewFlowLayout *collectionViewLayout;
@end

@implementation TKTokenField
@synthesize collectionView = _collectionView;
@synthesize collectionViewLayout = _collectionViewLayout;
@synthesize tokens = _tokens;
@dynamic selectedTokens;

- (id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
	return self;
}

- (void) awakeFromNib {
	[super awakeFromNib];
	[self setup];
}

- (void) setup {
	[self.collectionView reloadData];
	[self addSubview:self.collectionView];
}

//- (NSArray *) tokens {
//	if (!_tokens) {
//		_tokens = @[];
//	}
//	return _tokens;
//}

- (void) setTokens:(NSArray *)tokens {
	[self setTokens:tokens animated:NO];
}

- (void) setTokens:(NSArray *)tokens animated:(BOOL)animated {
	if (_tokens != tokens) {
		UICollectionView *collectionView = self.collectionView;
		NSMutableSet *selectedTokens = [self.selectedTokens mutableCopy];
		[selectedTokens intersectSet:[NSSet setWithArray:tokens]];
		
		if (!animated) {
			_tokens = tokens;
			[collectionView reloadData];
			self.selectedTokens = selectedTokens;
			return;
		}
		
		__block __unsafe_unretained UIResponder * (^firstResponder)(UIView *) = ^ (UIView *view) {
			if (view.isFirstResponder) {
				return (UIResponder *)self;
			}
			for (UIView *subview in view.subviews) {
				UIResponder *answer = firstResponder(subview);
				if (answer) {
					return answer;
				}
			}
			return (UIResponder *)nil;
		};
		
		NSArray *deletedIndexPaths = ((^{
			NSArray *deletedTokens = [_tokens filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^(TKToken *existingToken, NSDictionary *bindings) {
				return (BOOL)![tokens containsObject:existingToken];
			}]];
			NSMutableArray *answer = [NSMutableArray array];
			for (TKToken *token in deletedTokens) {
				NSUInteger index = [_tokens indexOfObject:token];
				[answer addObject:[NSIndexPath indexPathForItem:index inSection:0]];
			}
			return answer;
		})());
		
		NSArray *insertedIndexPaths = ((^{
			NSArray *insertedTokens = [tokens filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^(TKToken *remainingToken, NSDictionary *bindings) {
				return (BOOL)![_tokens containsObject:remainingToken];
			}]];
			
			NSMutableArray *answer = [NSMutableArray array];
			for (TKToken *token in insertedTokens) {
				NSUInteger index = [tokens indexOfObject:token];
				[answer addObject:[NSIndexPath indexPathForItem:index inSection:0]];
			}
			return answer;
		})());
		
		[firstResponder(collectionView) resignFirstResponder];
		[collectionView performBatchUpdates:^{
			[collectionView deleteItemsAtIndexPaths:deletedIndexPaths];
			[collectionView insertItemsAtIndexPaths:insertedIndexPaths];
			_tokens = tokens;
		} completion:^(BOOL finished) {
			self.selectedTokens = selectedTokens;
		}];
	}
}

- (NSSet *) selectedTokens {
	NSMutableSet *answer = [NSMutableSet set];
	for (NSIndexPath *indexPath in [self.collectionView indexPathsForSelectedItems]) {
		TKToken *token = [self tokenAtIndexPath:indexPath];
		if (token) {
			[answer addObject:token];
		}
	}
	return answer;
}

- (void) setSelectedTokens:(NSSet *)selectedTokens {
	[self setSelectedTokens:selectedTokens animated:NO];
}

- (void) setSelectedTokens:(NSSet *)selectedTokens animated:(BOOL)animate {
	NSSet *fromSelectedTokens = self.selectedTokens;
	if (fromSelectedTokens != selectedTokens) {
		for (TKToken *token in fromSelectedTokens) {
			NSIndexPath *indexPath = [self indexPathForToken:token];
			if (indexPath) {
				[self.collectionView deselectItemAtIndexPath:indexPath animated:animate];
			}
		}
		for (TKToken *token in selectedTokens) {
			NSIndexPath *indexPath = [self indexPathForToken:token];
			if (indexPath) {
				[self.collectionView selectItemAtIndexPath:indexPath animated:animate scrollPosition:UICollectionViewScrollPositionNone];
			}
		}
	}
}

- (void) didMoveToSuperview {
	[super didMoveToSuperview];
	if (self.superview) {
		[self.collectionView reloadData];
	}
}

- (UICollectionView *) collectionView {
	if (!_collectionView) {
		_collectionView = [self newCollectionView];
	}
	return _collectionView;
}

- (UICollectionViewFlowLayout *) collectionViewLayout {
	if (!_collectionViewLayout) {
		_collectionViewLayout = [[TKTokenFieldCollectionViewFlowLayout alloc] init];
		_collectionViewLayout.itemSize = (CGSize){ 128, 128 };
	}
	return _collectionViewLayout;
}

- (UICollectionView *) newCollectionView {
	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionViewLayout];
	collectionView.dataSource = self;
	collectionView.delegate = self;
	collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	collectionView.backgroundColor = self.backgroundColor;
	[collectionView registerClass:[TKTokenFieldCollectionViewCell class] forCellWithReuseIdentifier:TKTokenFieldCellReuseIdentifier];
	return collectionView;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.tokens.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	TKToken *token = self.tokens[indexPath.item];
	return [self sizeForToken:token];
}

- (CGSize) sizeForToken:(TKToken *)token {
	return [TKTokenFieldCollectionViewCell sizeForToken:token];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	TKToken *token = [self tokenAtIndexPath:indexPath];
	TKTokenFieldCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TKTokenFieldCellReuseIdentifier forIndexPath:indexPath];
	cell.token = token;
	return cell;
}

- (BOOL) collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(tokenField:shouldHighlightToken:)]) {
		return [self.delegate tokenField:self shouldHighlightToken:[self tokenAtIndexPath:indexPath]];
	}
	return YES;
}

- (void) collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(tokenField:didHighlightToken:)]) {
		[self.delegate tokenField:self didHighlightToken:[self tokenAtIndexPath:indexPath]];
	}
}

- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(tokenField:shouldSelectToken:)]) {
		return [self.delegate tokenField:self shouldSelectToken:[self tokenAtIndexPath:indexPath]];
	}
	return YES;
}

- (BOOL) collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(tokenField:shouldDeselectToken:)]) {
		return [self.delegate tokenField:self shouldDeselectToken:[self tokenAtIndexPath:indexPath]];
	}
	return YES;
}

- (void) collectionView:(UICollectionView *) collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(tokenField:didSelectToken:)]) {
		[self.delegate tokenField:self didSelectToken:[self tokenAtIndexPath:indexPath]];
	}
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(tokenField:didDeselectToken:)]) {
		[self.delegate tokenField:self didDeselectToken:[self tokenAtIndexPath:indexPath]];
	}
}

- (void) collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(tokenField:didUnhighlightToken:)]) {
		[self.delegate tokenField:self didUnhighlightToken:[self tokenAtIndexPath:indexPath]];
	}
}

- (TKToken *) tokenAtIndexPath:(NSIndexPath *)indexPath {
	if (self.tokens.count > indexPath.item) {
		return self.tokens[indexPath.item];
	}
	return nil;
}

- (NSIndexPath *) indexPathForToken:(TKToken *)token {
	NSUInteger index = [self.tokens indexOfObject:token];
	if (index == NSNotFound) {
		return nil;
	}
	return [NSIndexPath indexPathForItem:index inSection:0];
}

- (CGRect) rectForToken:(TKToken *)token {
	NSIndexPath *indexPath = [self indexPathForToken:token];
	if (!indexPath) {
		return CGRectNull;
	}
	UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
	return [self convertRect:attributes.frame fromView:self.collectionView];
}

@end

NSString * const TKTokenFieldCellReuseIdentifier = @"Cell";
