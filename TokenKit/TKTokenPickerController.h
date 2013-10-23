#import <UIKit/UIKit.h>

@class TKTokenPickerController, TKToken;
@protocol TKTokenPickerControllerDelegate <NSObject>
- (void) tokenPickerController:(TKTokenPickerController *)controller willDisplayCell:(UITableViewCell *)cell representingToken:(TKToken *)token;
- (void) tokenPickerController:(TKTokenPickerController *)controller didSelectToken:(TKToken *)token;
@end

@interface TKTokenPickerController : UITableViewController
@property (nonatomic, readwrite, weak) id<TKTokenPickerControllerDelegate> delegate;
@property (nonatomic, readwrite, strong) NSArray *tokens;
@end
