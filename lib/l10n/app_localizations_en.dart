// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get language => 'Language';

  @override
  String get appTitle => 'Invoice Uploader App';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get settings => 'Settings';

  @override
  String signedInMessage(Object email) {
    return '✅ Signed in as $email';
  }

  @override
  String get signInCancelled => '❌ Sign-in cancelled';

  @override
  String get signedOut => '🔒 Signed out';

  @override
  String signInError(Object error) {
    return '❌ Error signing in: $error';
  }

  @override
  String get welcomeHeader => 'Welcome!';

  @override
  String welcomeUser(Object user) {
    return 'Welcome, $user';
  }

  @override
  String get pleaseSignIn => 'Please sign in to begin.';

  @override
  String get signInButton => 'Sign In';

  @override
  String get signOutButton => 'Sign Out';

  @override
  String get receiptUpload => 'Receipt Upload';

  @override
  String get spreadsheet => 'Spreadsheet';

  @override
  String get noCategory =>
      '⚠️ No category chosen yet. Please upload at least one receipt first.';

  @override
  String spreadsheetOpenFail(Object error) {
    return '❌ Failed to open spreadsheet: $error';
  }

  @override
  String get uploadSuccess => '✅ Upload success!';

  @override
  String uploadFailed(Object statusCode, Object error) {
    return '❌ Upload failed: $statusCode $error';
  }

  @override
  String failedToLoadData(Object error) {
    return '❌ Failed to load data: $error';
  }

  @override
  String get noImageSelected => 'No image selected';

  @override
  String get cameraButton => 'Camera';

  @override
  String get galleryButton => 'Gallery';

  @override
  String get categoryLabel => 'Category';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get addCategoryOption => '➕ Add Category';

  @override
  String get newCategoryLabel => 'New Category Name';

  @override
  String deleteCategoryTitle(Object category) {
    return 'Delete \'$category\'?';
  }

  @override
  String get deleteCategoryConfirm => 'Do you want to remove this category?';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get amountLabel => 'Invoice Amount (e.g. 34.50)';

  @override
  String get enterAmount => 'Enter Amount';

  @override
  String get filenameLabel => 'Filename (optional: auto generated)';

  @override
  String get selectFiles => 'Select Files';

  @override
  String get date => 'Date';

  @override
  String get file => 'File';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get pickDate => 'Pick Date';

  @override
  String get noDateSelected => 'No date selected';

  @override
  String get uploadButton => 'Upload!';

  @override
  String get uploadingPleaseWait => 'Uploading, please wait...';

  @override
  String get uploadProgress => 'Uploading and updating sheet...';

  @override
  String get uploadSuccessSnackbar => '✅ Uploaded & logged to sheet!';

  @override
  String get uploadFailedSnackbar => '❌ Upload failed';

  @override
  String get uploadErrorTitle => 'Upload Error';

  @override
  String get ok => 'OK';

  @override
  String get viewExpenses => 'View Expenses';

  @override
  String get viewAll => 'View All';

  @override
  String get bulkUpload => 'Bulk Upload';
}
