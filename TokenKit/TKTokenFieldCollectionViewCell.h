#import <UIKit/UIKit.h>

@class TKToken;
@interface TKTokenFieldCollectionViewCell : UICollectionViewCell

@property (nonatomic, readonly, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, readwrite, strong) TKToken *token;

@property (nonatomic, readwrite, weak) id actionTarget;
@property (nonatomic, readwrite, strong) NSArray *performableActions;

+ (CGSize) sizeForToken:(TKToken *)token;

@end
