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
  String get appTitle => 'Aplikasi Pemuat Naik Resit';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Cerah';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get settings => 'Tetapan';

  @override
  String signedInMessage(Object email) {
    return '✅ Log masuk sebagai $email';
  }

  @override
  String get signInCancelled => '❌ Log masuk dibatalkan';

  @override
  String get signedOut => '🔒 Telah log keluar';

  @override
  String signInError(Object error) {
    return '❌ Ralat semasa log masuk: $error';
  }

  @override
  String get welcomeHeader => 'Selamat datang!';

  @override
  String welcomeUser(Object user) {
    return 'Selamat datang, $user';
  }

  @override
  String get pleaseSignIn => 'Sila log masuk untuk bermula.';

  @override
  String get signInButton => 'Log Masuk';

  @override
  String get signOutButton => 'Log Keluar';

  @override
  String get receiptUpload => 'Muat Naik Resit';

  @override
  String get spreadsheet => 'Spreadsheet';

  @override
  String get noCategory =>
      '⚠️ Tiada kategori dipilih. Sila muat naik sekurang-kurangnya satu resit dahulu.';

  @override
  String spreadsheetOpenFail(Object error) {
    return '❌ Gagal buka helaian: $error';
  }

  @override
  String get uploadSuccess => '✅ Muat naik berjaya!';

  @override
  String uploadFailed(Object statusCode, Object error) {
    return '❌ Gagal muat naik: $statusCode $error';
  }

  @override
  String failedToLoadData(Object error) {
    return '❌ Gagal memuatkan data: $error';
  }

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
  String deleteCategoryTitle(Object category) {
    return 'Padam \'$category\'?';
  }

  @override
  String get deleteCategoryConfirm =>
      'Adakah anda pasti ingin memadam kategori ini?';

  @override
  String get delete => 'Padam';

  @override
  String get cancel => 'Batal';

  @override
  String get amountLabel => 'Jumlah Invois (cth: 34.50)';

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
  String get uploadingPleaseWait => 'Sedang memuat naik, sila tunggu...';

  @override
  String get uploadProgress => 'Memuat naik dan mengemas kini spreadsheet...';

  @override
  String get uploadSuccessSnackbar =>
      '✅ Telah dimuat naik & dicatat ke spreadsheet!';

  @override
  String get uploadFailedSnackbar => '❌ Gagal memuat naik';

  @override
  String get uploadErrorTitle => 'Ralat Muat Naik';

  @override
  String get ok => 'OK';

  @override
  String get viewExpenses => 'Lihat Perbelanjaan';

  @override
  String get viewAll => 'Lihat Semua';

  @override
  String get bulkUpload => 'Muat Naik Berkelompok';
}
