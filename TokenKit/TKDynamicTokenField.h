#import "TKTokenField.h"

@interface TKDynamicTokenField : TKTokenField
@property (nonatomic, readwrite, strong) NSArray *usableTokens;
@end

extern NSString * const TKDynamicTokenFieldAdditionCellReuseIdentifier;
