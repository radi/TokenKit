#import "TKTokenField.h"

@protocol TKDynamicTokenFieldDelegate <TKTokenFieldDelegate>
@optional
- (void) tokenField:(TKTokenField *)tokenField didUpdateContentSize:(CGSize)contentSize;
@end

@interface TKDynamicTokenField : TKTokenField
@property (nonatomic, readwrite, weak) id<TKDynamicTokenFieldDelegate> delegate;
@property (nonatomic, readwrite, strong) NSArray *usableTokens;
@end

extern NSString * const TKDynamicTokenFieldAdditionCellReuseIdentifier;
