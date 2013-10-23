#import "TKTokenPickerController.h"

@implementation TKTokenPickerController

- (void) setTokens:(NSArray *)objects {
	if (_tokens != objects) {
		_tokens = objects;
		if (self.isViewLoaded) {
			[self.tableView reloadData];
		}
	}
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.tokens.count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TKToken *token = self.tokens[indexPath.row];
	[self.delegate tokenPickerController:self didSelectToken:token];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	TKToken *token = self.tokens[indexPath.row];
	[self.delegate tokenPickerController:self willDisplayCell:cell representingToken:token];
	return cell;
}

@end
