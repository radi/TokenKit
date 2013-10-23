#import "TKDeletableTokenCollectionViewCell.h"
#import "TKDynamicTokenField.h"
#import "TKToken.h"
#import "TKTokenPickerController.h"

@interface TKTokenField (TKDynamicTokenField) <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@end

@interface TKDynamicTokenField () <TKTokenPickerControllerDelegate, UIPopoverControllerDelegate>
@property (nonatomic, readonly, strong) TKTokenPickerController *listPickerViewController;
@property (nonatomic, readonly, strong) UIPopoverController *listPopoverController;
@end

@implementation TKDynamicTokenField
@dynamic delegate;
@synthesize listPickerViewController = _listPickerViewController;
@synthesize listPopoverController = _listPopoverController;

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [super collectionView:collectionView numberOfItemsInSection:section] + 1;
}

- (UICollectionView *) newCollectionView {
	UICollectionView *answer = [super newCollectionView];
	[answer registerClass:[TKDeletableTokenCollectionViewCell class] forCellWithReuseIdentifier:TKTokenFieldCellReuseIdentifier];
	[answer registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:TKDynamicTokenFieldAdditionCellReuseIdentifier];
	return answer;
}

- (void) configureAdditionCell:(UICollectionViewCell *)cell {
	if ([self remainingTokens].count) {
		cell.userInteractionEnabled = YES;
		cell.contentView.alpha = 1.0f;
		cell.backgroundView.alpha = 1.0f;
	} else {
		cell.userInteractionEnabled = NO;
		cell.contentView.alpha = 0.25f;
		cell.backgroundView.alpha = 0.25f;
	}
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (indexPath.item == self.tokens.count) {
			UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TKDynamicTokenFieldAdditionCellReuseIdentifier forIndexPath:indexPath];
			[cell setValue:TKDynamicTokenFieldAdditionCellReuseIdentifier forKey:@"reuseIdentifier"];
			[self configureAdditionCell:cell];
			return cell;
		}
	}
	return [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (indexPath.item == self.tokens.count) {
			return (CGSize){
				128.0f,
				44.0f
			};
		}
	}
	CGSize superAnswer = [super collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
	return (CGSize){
		superAnswer.width,
		44.0f
	};
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
	
	TKToken *token = [self tokenAtIndexPath:indexPath];
	if (!token) {
		[self add:collectionView];
		return;
	}
	
	UIMenuController *controller = [UIMenuController sharedMenuController];
	if (controller.menuVisible) {
		[controller setMenuVisible:NO animated:NO];
	}
	
	UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
	[cell becomeFirstResponder];
	if ([cell isKindOfClass:[TKDeletableTokenCollectionViewCell class]]) {
		((TKDeletableTokenCollectionViewCell *)cell).target = self;
	}
	
	CGRect rect = [self rectForToken:token];
	[controller setTargetRect:rect inView:self];
	[controller setMenuVisible:YES animated:NO];
}

- (NSArray *) remainingTokens {
	NSArray *selectedTokens = self.tokens;
	return [self.usableTokens filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		return ![selectedTokens containsObject:evaluatedObject];
	}]];
}

- (void) add:(id)sender {
	NSArray *remainingTokens = self.remainingTokens;
	if (remainingTokens.count) {
		UICollectionView *collectionView = self.collectionView;
		NSIndexPath *indexPath = [NSIndexPath indexPathForItem:([collectionView numberOfItemsInSection:0] - 1) inSection:0];
		CGRect rect = [collectionView layoutAttributesForItemAtIndexPath:indexPath].frame;
		self.listPickerViewController.tokens = remainingTokens;
		[self.listPickerViewController.tableView reloadData];
		self.listPickerViewController.contentSizeForViewInPopover = (CGSize){
			320.0f,
			self.listPickerViewController.tableView.contentSize.height
		};
		[self.listPopoverController setPopoverContentSize:self.listPopoverController.contentViewController.contentSizeForViewInPopover animated:NO];
		[self.listPopoverController presentPopoverFromRect:rect inView:self.collectionView permittedArrowDirections:UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown animated:NO];
	}
}

- (void) delete:(id)sender {
	__weak typeof(self) wSelf = self;
	NSMutableArray *toTokens = [self.tokens mutableCopy];
	[toTokens removeObjectsInArray:self.selectedTokens.allObjects];
	[self setTokens:toTokens animated:YES completion:^(BOOL finished) {
		__strong typeof(wSelf) sSelf = wSelf;
		if ([sSelf.delegate respondsToSelector:@selector(tokenField:didUpdateContentSize:)]) {
			[sSelf.delegate tokenField:sSelf didUpdateContentSize:sSelf.collectionView.contentSize];
		}
	}];
}

- (void) tokenPickerController:(TKTokenPickerController *)controller didSelectToken:(TKToken *)token {
	__weak typeof(self) wSelf = self;
	[self.listPopoverController dismissPopoverAnimated:YES];
	[self setTokens:[(self.tokens ?: @[]) arrayByAddingObject:token] animated:YES completion:^(BOOL finished) {
		__strong typeof(wSelf) sSelf = wSelf;
		if ([sSelf.delegate respondsToSelector:@selector(tokenField:didUpdateContentSize:)]) {
			[sSelf.delegate tokenField:sSelf didUpdateContentSize:sSelf.collectionView.contentSize];
		}
	}];
}

- (void) setTokens:(NSArray *)tokens animated:(BOOL)animated completion:(void (^)(BOOL))block {
	__weak typeof(self) wSelf = self;
	[super setTokens:tokens animated:animated completion:^(BOOL finished) {
		if (animated) {
			__strong typeof(self) sSelf = wSelf;
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(sSelf.tokens.count) inSection:0];
			UICollectionViewCell *cell = [sSelf.collectionView cellForItemAtIndexPath:indexPath];
			[UIView animateWithDuration:0.3f animations:^{
				[sSelf.collectionView deselectItemAtIndexPath:indexPath animated:NO];
				[sSelf configureAdditionCell:cell];
			}];
		}
		if (block) {
			block(finished);
		}
	}];
}

- (UIPopoverController *) listPopoverController {
	if (!_listPopoverController) {
		_listPopoverController = [[UIPopoverController alloc] initWithContentViewController:[[UINavigationController alloc] initWithRootViewController:self.listPickerViewController]];
		_listPopoverController.delegate = self;
	}
	return _listPopoverController;
}

- (TKTokenPickerController *) listPickerViewController {
	if (!_listPickerViewController) {
		_listPickerViewController = [TKTokenPickerController new];
		_listPickerViewController.tokens = @[];
		_listPickerViewController.delegate = self;
		_listPickerViewController.title = @"Add Token";
	}
	return _listPickerViewController;
}

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	NSIndexPath *addingCellIndexPath = [NSIndexPath indexPathForItem:self.tokens.count inSection:0];
	[self.collectionView deselectItemAtIndexPath:addingCellIndexPath animated:YES];
}

- (void) tokenPickerController:(TKTokenPickerController *)controller willDisplayCell:(UITableViewCell *)cell representingToken:(TKToken *)token {
	cell.textLabel.text = token.title;
}

@end

NSString * const TKDynamicTokenFieldAdditionCellReuseIdentifier = @"AdditionCell";
