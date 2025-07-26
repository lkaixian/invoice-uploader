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
    Locale('zh'),
    Locale('ms'),
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
  /// **'Invoice Uploader App'**
  String get appTitle;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

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
  /// **'System'**
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
  String signedInMessage(Object email);

  /// No description provided for @signInCancelled.
  ///
  /// In en, this message translates to:
  /// **'❌ Sign-in cancelled'**
  String get signInCancelled;

  /// No description provided for @signedOut.
  ///
  /// In en, this message translates to:
  /// **'🔒 Signed out'**
  String get signedOut;

  /// No description provided for @signInError.
  ///
  /// In en, this message translates to:
  /// **'❌ Error signing in: {error}'**
  String signInError(Object error);

  /// No description provided for @welcomeHeader.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcomeHeader;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {user}'**
  String welcomeUser(Object user);

  /// No description provided for @pleaseSignIn.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to begin.'**
  String get pleaseSignIn;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @signOutButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutButton;

  /// No description provided for @receiptUpload.
  ///
  /// In en, this message translates to:
  /// **'Receipt Upload'**
  String get receiptUpload;

  /// No description provided for @spreadsheet.
  ///
  /// In en, this message translates to:
  /// **'Spreadsheet'**
  String get spreadsheet;

  /// No description provided for @noCategory.
  ///
  /// In en, this message translates to:
  /// **'⚠️ No category chosen yet. Please upload at least one receipt first.'**
  String get noCategory;

  /// No description provided for @spreadsheetOpenFail.
  ///
  /// In en, this message translates to:
  /// **'❌ Failed to open spreadsheet: {error}'**
  String spreadsheetOpenFail(Object error);

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Upload success!'**
  String get uploadSuccess;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Upload failed: {statusCode} {error}'**
  String uploadFailed(Object statusCode, Object error);

  /// No description provided for @failedToLoadData.
  ///
  /// In en, this message translates to:
  /// **'❌ Failed to load data: {error}'**
  String failedToLoadData(Object error);

  /// No description provided for @noImageSelected.
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get noImageSelected;

  /// No description provided for @cameraButton.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraButton;

  /// No description provided for @galleryButton.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryButton;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @addCategoryOption.
  ///
  /// In en, this message translates to:
  /// **'➕ Add Category'**
  String get addCategoryOption;

  /// No description provided for @newCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'New Category Name'**
  String get newCategoryLabel;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \'{category}\'?'**
  String deleteCategoryTitle(Object category);

  /// No description provided for @deleteCategoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove this category?'**
  String get deleteCategoryConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice Amount (e.g. 34.50)'**
  String get amountLabel;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enterAmount;

  /// No description provided for @filenameLabel.
  ///
  /// In en, this message translates to:
  /// **'Filename (optional: auto generated)'**
  String get filenameLabel;

  /// No description provided for @selectFiles.
  ///
  /// In en, this message translates to:
  /// **'Select Files'**
  String get selectFiles;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick Date'**
  String get pickDate;

  /// No description provided for @noDateSelected.
  ///
  /// In en, this message translates to:
  /// **'No date selected'**
  String get noDateSelected;

  /// No description provided for @uploadButton.
  ///
  /// In en, this message translates to:
  /// **'Upload!'**
  String get uploadButton;

  /// No description provided for @uploadingPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Uploading, please wait...'**
  String get uploadingPleaseWait;

  /// No description provided for @uploadProgress.
  ///
  /// In en, this message translates to:
  /// **'Uploading and updating sheet...'**
  String get uploadProgress;

  /// No description provided for @uploadSuccessSnackbar.
  ///
  /// In en, this message translates to:
  /// **'✅ Uploaded & logged to sheet!'**
  String get uploadSuccessSnackbar;

  /// No description provided for @uploadFailedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'❌ Upload failed'**
  String get uploadFailedSnackbar;

  /// No description provided for @uploadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Error'**
  String get uploadErrorTitle;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @viewExpenses.
  ///
  /// In en, this message translates to:
  /// **'View Expenses'**
  String get viewExpenses;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @bulkUpload.
  ///
  /// In en, this message translates to:
  /// **'Bulk Upload'**
  String get bulkUpload;
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
