# TokenKit

Bare-bones token field built with a collection view.

## Using TokenKit

To use Token Kit, you’ll incorporate `TKTokenField` which manages an internal UICollectionView to show one cell for each token. Pass in `tokens` and modify them thru `-setTokens:animated:`. If you’re interested in handling token cell selection, you can assign a delegate and operate on `selectedTokens` or modify these thru `-setSelectedTokens:animated:`.

Additional methods on the token field are provided for flexibility, and there is a `TKDynamicTokenField` which allows the user to pick one or several tokens from a predefined list. This implementation uses `UIPopoverController`, so it is only available for the iPad.

To customize any cell, just register classes or nibs on the collection view when you load the token field. The cell identifier used by `TKTokenField` is provided to you for identity checks, and `TKTokenField` maintains identifier consistency internally so you do not have to copy it into the nib.

There’s a [Sample App](https://github.com/evadne/TokenKit-Sample) which uses `TKDynamicTokenField` and shows a technique for auto-resizing the field on content change.

## Credits

*	[Evadne Wu](http://radi.ws)
