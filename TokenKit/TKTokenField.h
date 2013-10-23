#import <UIKit/UIKit.h>

@class TKToken, TKTokenField;
@protocol TKTokenFieldDelegate <NSObject>
@optional
- (BOOL) tokenField:(TKTokenField *)tokenField shouldHighlightToken:(TKToken *)token;
- (BOOL) tokenField:(TKTokenField *)tokenField shouldSelectToken:(TKToken *)token;
- (BOOL) tokenField:(TKTokenField *)tokenField shouldDeselectToken:(TKToken *)token;
- (void) tokenField:(TKTokenField *)tokenField didHighlightToken:(TKToken *)token;
- (void) tokenField:(TKTokenField *)tokenField didSelectToken:(TKToken *)token;
- (void) tokenField:(TKTokenField *)tokenField didDeselectToken:(TKToken *)token;
- (void) tokenField:(TKTokenField *)tokenField didUnhighlightToken:(TKToken *)token;
@end

@interface TKTokenField : UIView
@property (nonatomic, readwrite, weak) IBOutlet id<TKTokenFieldDelegate> delegate;
@property (nonatomic, readwrite, strong) NSArray *tokens;
- (void) setTokens:(NSArray *)tokens animated:(BOOL)animated completion:(void(^)(BOOL finished))block;

@property (nonatomic, readwrite, strong) NSSet *selectedTokens;
- (void) setSelectedTokens:(NSSet *)selectedTokens animated:(BOOL)animate;

@property (nonatomic, readonly, strong) UICollectionView *collectionView;
- (UICollectionView *) newCollectionView;
- (TKToken *) tokenAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *) indexPathForToken:(TKToken *)token;
- (CGRect) rectForToken:(TKToken *)token;
@end

extern NSString * const TKTokenFieldCellReuseIdentifier;
