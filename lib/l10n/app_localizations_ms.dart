// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class SMs extends S {
  SMs([String locale = 'ms']) : super(locale);

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get language => 'Bahasa';

  @override
  String get appTitle => 'Pemuat Naik Resit';

  @override
  String get theme => 'Tema';

  @override
  String get switchTheme => 'Tukar Tema';

  @override
  String get themeLight => 'Cerah';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeSystem => 'Ikut Sistem';

  @override
  String get settings => 'Tetapan';

  @override
  String signedInMessage(String email) {
    return '✅ Log masuk sebagai: $email';
  }

  @override
  String get signInCancelled => '❌ Log masuk dibatalkan';

  @override
  String get signedOut => '🔒 Telah log keluar';

  @override
  String signInError(String error) {
    return '❌ Ralat log masuk: $error';
  }

  @override
  String get welcomeHeader => 'Selamat Datang!';

  @override
  String welcomeUser(String user) {
    return 'Selamat datang, $user';
  }

  @override
  String get pleaseSignIn => 'Sila log masuk untuk memulakan.';

  @override
  String get signInButton => 'Log Masuk';

  @override
  String get signOutButton => 'Log Keluar';

  @override
  String get receiptUpload => 'Muat Naik Resit';

  @override
  String get spreadsheet => 'Lembaran Kerja';

  @override
  String get noCategory =>
      '⚠️ Tiada kategori dipilih. Sila muat naik sekurang-kurangnya satu resit dahulu.';

  @override
  String spreadsheetOpenFail(String error) {
    return '❌ Gagal buka lembaran: $error';
  }

  @override
  String get uploadSuccess => '✅ Berjaya dimuat naik!';

  @override
  String uploadFailed(int statusCode, String error) {
    return '❌ Gagal muat naik: $statusCode $error';
  }

  @override
  String get incompleteData =>
      '❌ Maklumat tidak lengkap. Sila semak input anda.';

  @override
  String get noImageSelected => 'Tiada imej dipilih';

  @override
  String get cameraButton => 'Kamera';

  @override
  String get galleryButton => 'Galeri';

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get selectCategory => 'Pilih Kategori';

  @override
  String get addCategoryOption => '➕ Tambah Kategori';

  @override
  String get newCategoryLabel => 'Nama Kategori Baru';

  @override
  String deleteCategoryTitle(String category) {
    return 'Padam “$category”?';
  }

  @override
  String get deleteCategoryConfirm =>
      'Adakah anda pasti ingin memadam kategori ini?';

  @override
  String get delete => 'Padam';

  @override
  String get cancel => 'Batal';

  @override
  String get amountLabel => 'Jumlah Resit (cth: 34.50)';

  @override
  String get enterAmount => 'Masukkan Jumlah';

  @override
  String get filenameLabel => 'Nama Fail (pilihan: auto jana)';

  @override
  String get selectFiles => 'Pilih Fail';

  @override
  String get date => 'Tarikh';

  @override
  String get file => 'Fail';

  @override
  String get previous => 'Sebelumnya';

  @override
  String get next => 'Seterusnya';

  @override
  String get pickDate => 'Pilih Tarikh';

  @override
  String get noDateSelected => 'Tiada tarikh dipilih';

  @override
  String get uploadButton => 'Muat Naik!';

  @override
  String get uploadingPleaseWait => 'Sila tunggu, sedang memuat naik...';

  @override
  String get uploadProgress => 'Memuat naik dan mengemas kini lembaran...';

  @override
  String get uploadSuccessSnackbar => '✅ Berjaya dimuat naik & direkod!';

  @override
  String get uploadFailedSnackbar => '❌ Muat naik gagal';

  @override
  String get uploadErrorTitle => 'Ralat Muat Naik';

  @override
  String get ok => 'OK';

  @override
  String get viewExpenses => 'Lihat Perbelanjaan';

  @override
  String get viewAll => 'Lihat Semua';

  @override
  String get bulkUpload => 'Muat Naik Pukal';

  @override
  String uploadedCount(int uploaded, int total) {
    return 'Dimuat naik $uploaded / $total';
  }

  @override
  String get addMoreFiles => 'Tambah Lagi Fail';

  @override
  String get originalName => 'Nama Asal';

  @override
  String get autoGenerateFilename => 'Auto Jana Nama Fail';

  @override
  String get topCategories => '3 Kategori Tertinggi';

  @override
  String get topSpends => '3 Perbelanjaan Tertinggi';

  @override
  String get monthJanuary => 'Januari';

  @override
  String get monthFebruary => 'Februari';

  @override
  String get monthMarch => 'Mac';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'Mei';

  @override
  String get monthJune => 'Jun';

  @override
  String get monthJuly => 'Julai';

  @override
  String get monthAugust => 'Ogos';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'Oktober';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'Disember';

  @override
  String get buyMeCoffee => 'Belanja Saya Kopi ☕';

  @override
  String get supportMyWork =>
      'Jika anda rasa aplikasi ini membantu, pertimbangkan untuk belanja saya kopi sebagai tanda sokongan.';

  @override
  String get linkOpenFailed => 'Gagal buka pautan';

  @override
  String get useCustomFileName => 'Guna Nama Fail Tersuai';

  @override
  String get fileName => 'Nama Fail';

  @override
  String get fileNameHint => 'Contoh: InvoiceLog';

  @override
  String get about => 'Tentang';

  @override
  String get aboutDescription =>
      'Ini adalah aplikasi untuk memuat naik dan merekod resit. Ia menyokong pengecaman imej, muat naik Google Drive dan penyelarasan Google Sheets.';

  @override
  String get aboutDisclaimer =>
      'Penghargaan:\n- Flutter & Dart SDK\n- Google APIs (Drive, Sheets, Sign-In)\n- flutter_dotenv untuk konfigurasi .env\n- firebase_crashlytics\n- dan pustaka sumber terbuka lain';

  @override
  String get aboutVersion => 'Versi';

  @override
  String get aboutVersionValue => '2508W1_NIGHTLY_BUILD';

  @override
  String get reportIssue => 'Laporkan Isu';

  @override
  String get reportIssueSubtitle => 'Jumpa pepijat? Maklumkan kami di GitHub.';

  @override
  String get permanentAutoFileName => 'Nama Fail Auto Kekal';

  @override
  String get permanentAutoFileNameSubtitle =>
      'Sentiasa jana nama fail secara automatik tanpa suntingan';

  @override
  String get permanentAutoFileNameEnabled => 'Auto nama fail kekal diaktifkan';

  @override
  String get permanentAutoFileNameDisabled =>
      'Auto nama fail kekal dinyahaktifkan';
}
