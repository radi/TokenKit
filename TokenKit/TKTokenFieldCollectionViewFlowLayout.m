#import "TKTokenFieldCollectionViewFlowLayout.h"

@implementation TKTokenFieldCollectionViewFlowLayout

//	Portions of this file comes from:
//	http://stackoverflow.com/questions/13017257/how-do-you-determine-spacing-between-cells-in-uicollectionview-flowlayout

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
	return YES;
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
	NSArray *answer = [super layoutAttributesForElementsInRect:rect];
	for (UICollectionViewLayoutAttributes *attributes in answer) {
		if (!attributes.representedElementKind) {
			attributes.frame = [self layoutAttributesForItemAtIndexPath:attributes.indexPath].frame;
		}
	}
	return answer;
}

- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewLayoutAttributes *currentItemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
	UIEdgeInsets sectionInset = self.sectionInset;
	CGRect currentItemRect = currentItemAttributes.frame;
	
	if (!indexPath.item) {
		currentItemRect.origin.x = sectionInset.left;
		currentItemAttributes.frame = currentItemRect;
		return currentItemAttributes;
	}

	NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:(indexPath.item - 1) inSection:indexPath.section];
	UICollectionViewLayoutAttributes *previousItemAttributes = [self layoutAttributesForItemAtIndexPath:previousIndexPath];
	CGRect collectionViewBounds = self.collectionView.bounds;
	CGRect previousItemRect = previousItemAttributes.frame;
	CGRect currentLineRect = CGRectMake(
		CGRectGetMinX(collectionViewBounds),
		CGRectGetMinY(currentItemRect),
		CGRectGetWidth(collectionViewBounds),
		CGRectGetHeight(currentItemRect));
	
	if (CGRectIntersectsRect(previousItemRect, currentLineRect)) {
		currentItemRect.origin.x = CGRectGetMaxX(previousItemRect) + self.minimumInteritemSpacing;
		currentItemAttributes.frame = currentItemRect;
		return currentItemAttributes;
	}
	
	currentItemRect.origin.x = sectionInset.left;
	currentItemAttributes.frame = currentItemRect;
	return currentItemAttributes;
}

@end
