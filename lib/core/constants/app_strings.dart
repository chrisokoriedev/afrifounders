/// App-wide string constants
class AppStrings {
  AppStrings._();
  static const String hiveBox = 'items';
  static const String hiveBoxTheme = 'theme';
  

  // App
  static const String appName = 'Item Manager';

  // Home Screen
  static const String homeTitle = 'My Items';
  static const String emptyListTitle = 'No items yet';
  static const String emptyListSubtitle = 'Tap the + button to add your first item';
  static const String addItem = 'Add Item';
  static const String editItem = 'Edit Item';

  // Item Form
  static const String itemTitle = 'Title';
  static const String itemTitleHint = 'Enter item title';
  static const String itemDescription = 'Description';
  static const String itemDescriptionHint = 'Enter item description (optional)';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';

  // Validation
  static const String titleRequired = 'Title is required';
  static const String titleTooLong = 'Title must be less than 100 characters';
  static const String descriptionTooLong = 'Description must be less than 500 characters';

  // Errors
  static const String errorLoadingItems = 'Failed to load items';
  static const String errorAddingItem = 'Failed to add item';
  static const String errorUpdatingItem = 'Failed to update item';
  static const String errorDeletingItem = 'Failed to delete item';
  static const String retry = 'Retry';
  static const String unknownError = 'An unknown error occurred';

  // Delete Confirmation
  static const String deleteConfirmation = 'Delete Item';
  static const String deleteConfirmationMessage = 'Are you sure you want to delete this item?';
  static const String confirm = 'Confirm';
  static const String no = 'No';

  // Search and Sort
  static const String searchHint = 'Search items...';
  static const String sortBy = 'Sort by';
  static const String sortDateCreated = 'Date Created';
  static const String sortDateUpdated = 'Date Updated';
  static const String sortTitle = 'Title';
}

