import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ms'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Finance and Invoice Manager App'**
  String get appTitle;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @switchTheme.
  ///
  /// In en, this message translates to:
  /// **'Switch Theme'**
  String get switchTheme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @signedInMessage.
  ///
  /// In en, this message translates to:
  /// **'✅ Signed in as {email}'**
  String signedInMessage(String email);

  /// Shown when the user cancels the sign-in process
  ///
  /// In en, this message translates to:
  /// **'❌ Sign-in cancelled'**
  String get signInCancelled;

  /// Shown when the user signs out
  ///
  /// In en, this message translates to:
  /// **'🔒 Signed out'**
  String get signedOut;

  /// No description provided for @signInError.
  ///
  /// In en, this message translates to:
  /// **'❌ Error signing in: {error}'**
  String signInError(String error);

  /// Generic welcome message on home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcomeHeader;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {user}'**
  String welcomeUser(String user);

  /// Prompt message asking the user to sign in
  ///
  /// In en, this message translates to:
  /// **'Please sign in to begin.'**
  String get pleaseSignIn;

  /// Label for the sign-in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// Label for the sign-out button
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutButton;

  /// Title for receipt upload section
  ///
  /// In en, this message translates to:
  /// **'Single Upload'**
  String get receiptUpload;

  /// Label for spreadsheet view
  ///
  /// In en, this message translates to:
  /// **'Spreadsheet'**
  String get spreadsheet;

  /// Message shown when no category is selected
  ///
  /// In en, this message translates to:
  /// **'⚠️ No category chosen yet. Please upload at least one receipt first.'**
  String get noCategory;

  /// No description provided for @spreadsheetOpenFail.
  ///
  /// In en, this message translates to:
  /// **'❌ Failed to open spreadsheet: {error}'**
  String spreadsheetOpenFail(String error);

  /// Shown when the upload is successful
  ///
  /// In en, this message translates to:
  /// **'✅ Upload success!'**
  String get uploadSuccess;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Upload failed: {statusCode} {error}'**
  String uploadFailed(int statusCode, String error);

  /// Message when required form data is incomplete
  ///
  /// In en, this message translates to:
  /// **'❌ Some data is incomplete. Please check your entries.'**
  String get incompleteData;

  /// Shown when user hasn't selected an image
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get noImageSelected;

  /// Button label for taking a photo
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraButton;

  /// Button label for choosing image from gallery
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryButton;

  /// Label for the category selection field
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// Prompt for selecting a category
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// Option to add a new category
  ///
  /// In en, this message translates to:
  /// **'➕ Add Category'**
  String get addCategoryOption;

  /// Label for entering new category name
  ///
  /// In en, this message translates to:
  /// **'New Category Name'**
  String get newCategoryLabel;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \'{category}\'?'**
  String deleteCategoryTitle(String category);

  /// Placeholder text when no category is selected for deletion
  ///
  /// In en, this message translates to:
  /// **'Delete selected category'**
  String get deleteCategoryTitlePlaceholder;

  /// Confirmation message for deleting a category
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove this category?'**
  String get deleteCategoryConfirm;

  /// Label for delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Label for cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label for the invoice amount field
  ///
  /// In en, this message translates to:
  /// **'Invoice Amount (e.g. 34.50)'**
  String get amountLabel;

  /// Placeholder for invoice amount input
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enterAmount;

  /// Label for filename input field
  ///
  /// In en, this message translates to:
  /// **'Filename (optional: auto generated)'**
  String get filenameLabel;

  /// Button label for selecting multiple files
  ///
  /// In en, this message translates to:
  /// **'Select Files'**
  String get selectFiles;

  /// Label for date picker
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Label for file name or upload
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// Button to go to the previous item
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Button to go to the next item
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Button label to open date picker
  ///
  /// In en, this message translates to:
  /// **'Pick Date'**
  String get pickDate;

  /// Shown when no date is picked yet
  ///
  /// In en, this message translates to:
  /// **'No date selected'**
  String get noDateSelected;

  /// Button label for uploading
  ///
  /// In en, this message translates to:
  /// **'Upload!'**
  String get uploadButton;

  /// Message shown while uploading
  ///
  /// In en, this message translates to:
  /// **'Uploading, please wait...'**
  String get uploadingPleaseWait;

  /// Message shown during upload progress
  ///
  /// In en, this message translates to:
  /// **'Uploading and updating sheet...'**
  String get uploadProgress;

  /// Snackbar shown on successful upload
  ///
  /// In en, this message translates to:
  /// **'✅ Uploaded & logged to sheet!'**
  String get uploadSuccessSnackbar;

  /// Snackbar shown when upload fails
  ///
  /// In en, this message translates to:
  /// **'❌ Upload failed'**
  String get uploadFailedSnackbar;

  /// Title for error alert dialog
  ///
  /// In en, this message translates to:
  /// **'Upload Error'**
  String get uploadErrorTitle;

  /// Button label for confirming
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Button label to view logged expenses
  ///
  /// In en, this message translates to:
  /// **'View Expenses'**
  String get viewExpenses;

  /// Button label to view all records
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Title for bulk upload feature
  ///
  /// In en, this message translates to:
  /// **'Bulk Upload'**
  String get bulkUpload;

  /// Message shown after each successful file upload
  ///
  /// In en, this message translates to:
  /// **'Uploaded {uploaded} of {total}'**
  String uploadedCount(int uploaded, int total);

  /// Button label for adding more files
  ///
  /// In en, this message translates to:
  /// **'Add more files'**
  String get addMoreFiles;

  /// Label for original file name
  ///
  /// In en, this message translates to:
  /// **'Original name'**
  String get originalName;

  /// Label for auto filename toggle
  ///
  /// In en, this message translates to:
  /// **'Auto-generate filename'**
  String get autoGenerateFilename;

  /// Label for top categories chart
  ///
  /// In en, this message translates to:
  /// **'Top 3 Categories'**
  String get topCategories;

  /// Label for top spending chart
  ///
  /// In en, this message translates to:
  /// **'Top 3 Spends'**
  String get topSpends;

  /// January month label
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJanuary;

  /// February month label
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFebruary;

  /// March month label
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMarch;

  /// April month label
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApril;

  /// May month label
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// June month label
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJune;

  /// July month label
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJuly;

  /// August month label
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAugust;

  /// September month label
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSeptember;

  /// October month label
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOctober;

  /// November month label
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNovember;

  /// December month label
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDecember;

  /// Label/button to support the developer
  ///
  /// In en, this message translates to:
  /// **'Buy me a coffee ☕'**
  String get buyMeCoffee;

  /// Message encouraging donations to developer
  ///
  /// In en, this message translates to:
  /// **'CAWFEE TIME! If you find this app useful, consider buying me a coffee to support my work.'**
  String get supportMyWork;

  /// Shown when failing to launch a URL
  ///
  /// In en, this message translates to:
  /// **'Could not open the link'**
  String get linkOpenFailed;

  /// Toggle for manually entering file name
  ///
  /// In en, this message translates to:
  /// **'Use custom file name'**
  String get useCustomFileName;

  /// Label for filename field
  ///
  /// In en, this message translates to:
  /// **'File Name'**
  String get fileName;

  /// Hint for filename input field
  ///
  /// In en, this message translates to:
  /// **'e.g. InvoiceLog'**
  String get fileNameHint;

  /// Drawer item for About dialog
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// App description shown in the About dialog
  ///
  /// In en, this message translates to:
  /// **'A simple app to manage your finance and invoices using Flutter and Google APIs.\n\nIt allows you to upload receipts, log expenses, and view your financial data in a structured way.\n\nBuilt with love by Larm Kai Xian.'**
  String get aboutDescription;

  /// Disclaimer/credits shown in About dialog
  ///
  /// In en, this message translates to:
  /// **'Credits:\n- Flutter & Dart SDK\n - Google APIs (Drive, Sheets, Sign-In)\n - flutter_dotenv for secure environment config\n - firebase_crashlytics \n'**
  String get aboutDisclaimer;

  /// Label for version info in About dialog
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutVersion;

  /// The full app version string shown in the About dialog
  ///
  /// In en, this message translates to:
  /// **'2508W1_NIGHTLY_BUILD'**
  String get aboutVersionValue;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get reportIssue;

  /// No description provided for @reportIssueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Found a bug? Let us know on GitHub.'**
  String get reportIssueSubtitle;

  /// No description provided for @permanentAutoFileName.
  ///
  /// In en, this message translates to:
  /// **'Permanent Auto File Name'**
  String get permanentAutoFileName;

  /// No description provided for @permanentAutoFileNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Always auto-generate filenames without editing'**
  String get permanentAutoFileNameSubtitle;

  /// No description provided for @permanentAutoFileNameEnabled.
  ///
  /// In en, this message translates to:
  /// **'Permanent auto filename enabled'**
  String get permanentAutoFileNameEnabled;

  /// No description provided for @permanentAutoFileNameDisabled.
  ///
  /// In en, this message translates to:
  /// **'Permanent auto filename disabled'**
  String get permanentAutoFileNameDisabled;

  /// No description provided for @changelogTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get changelogTitle;

  /// No description provided for @changelog_1.
  ///
  /// In en, this message translates to:
  /// **'Added Traditional Chinese language support'**
  String get changelog_1;

  /// No description provided for @changelog_2.
  ///
  /// In en, this message translates to:
  /// **'Added About section'**
  String get changelog_2;

  /// No description provided for @changelog_3.
  ///
  /// In en, this message translates to:
  /// **'Added option for permanent auto filename generation (in settings)'**
  String get changelog_3;

  /// No description provided for @changelog_4.
  ///
  /// In en, this message translates to:
  /// **'Added Firebase Crashlytics for crash reporting'**
  String get changelog_4;

  /// No description provided for @changelog_5.
  ///
  /// In en, this message translates to:
  /// **'Added \'Report a bug\' button that redirects to GitHub Issues (in settings)'**
  String get changelog_5;

  /// No description provided for @changelog_6.
  ///
  /// In en, this message translates to:
  /// **'Added web support — access the app via website'**
  String get changelog_6;

  /// No description provided for @changelog_7.
  ///
  /// In en, this message translates to:
  /// **'Replaced print() with logging system'**
  String get changelog_7;

  /// No description provided for @changelog_8.
  ///
  /// In en, this message translates to:
  /// **'Minor bug fixes'**
  String get changelog_8;

  /// No description provided for @changelog_note.
  ///
  /// In en, this message translates to:
  /// **'Note: Versioning format changed to <1.0.0 for pre-releases. Build number format: YYYYMMW-BUILD_TYPE, where BUILD_TYPE = RELEASE, BETA, NIGHTLY'**
  String get changelog_note;

  /// No description provided for @changelog_latest_1.
  ///
  /// In en, this message translates to:
  /// **'Added \"What\'s new section\".'**
  String get changelog_latest_1;

  /// No description provided for @changelog_latest_2.
  ///
  /// In en, this message translates to:
  /// **'App name changed to suit current featureset.'**
  String get changelog_latest_2;

  /// No description provided for @changelog_latest_3.
  ///
  /// In en, this message translates to:
  /// **'Naming changed from \"Receipt Upload\" to \"Single Upload\".'**
  String get changelog_latest_3;

  /// No description provided for @changelog_latest_4.
  ///
  /// In en, this message translates to:
  /// **'Redesigned Category selection and synchronous across both uploads.'**
  String get changelog_latest_4;

  /// No description provided for @changelog_latest_5.
  ///
  /// In en, this message translates to:
  /// **'Overhaul bulk uploading process to be more intuitive.'**
  String get changelog_latest_5;

  /// No description provided for @changelog_latest_6.
  ///
  /// In en, this message translates to:
  /// **'Users can now change, add, and remove categories during bulk uploading.'**
  String get changelog_latest_6;

  /// No description provided for @changelog_latest_7.
  ///
  /// In en, this message translates to:
  /// **'Fixed colors and fonts for better intuitiveness.'**
  String get changelog_latest_7;

  /// No description provided for @changelog_latest_8.
  ///
  /// In en, this message translates to:
  /// **'Implementing notification pop out for prototyping.'**
  String get changelog_latest_8;

  /// No description provided for @changelog_latest_9.
  ///
  /// In en, this message translates to:
  /// **'Implementing queued uploads.'**
  String get changelog_latest_9;

  /// No description provided for @changelog_latest_note.
  ///
  /// In en, this message translates to:
  /// **'Note: WIP, disabled.'**
  String get changelog_latest_note;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ms', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return SZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'ms':
      return SMs();
    case 'zh':
      return SZh();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
