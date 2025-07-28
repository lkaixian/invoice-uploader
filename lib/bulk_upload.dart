import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'google_drive_helper.dart';
import 'google_sheets_helper.dart';
import 'sheet_config.dart';

/// Uploads a file to Google Drive under the given category folder.
/// Returns `true` if the upload was successful.
Future<bool> uploadToDrive({
  required GoogleSignInAccount user,
  required File file,
  required String filename,
  required String category,
}) async {
  final uploader = GoogleDriveUploader(user);

  final success = await uploader.uploadFile(
    file: file,
    fileName: filename.trim(),
    folderName: category,
  );

  return success;
}

/// Logs the upload details into the appropriate sheet.
/// Creates spreadsheet and sheet tab if needed.
Future<void> logToSheet({
  required GoogleSignInAccount user,
  required String filename,
  required String category,
  required DateTime date,
  required String amount,
}) async {
  final sheets = GoogleSheetsHelper(user);

  final sheetId = await sheets.getOrCreateMainSpreadsheet();
  await sheets.ensureCategorySheetExists(sheetId, category);
  await sheets.appendToCategorySheet(sheetId, category, [
    date.toIso8601String().split('T').first,
    amount.trim(),
    filename.trim(),
  ]);

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("sheetId_$category", sheetId);
  await prefs.setString("lastUsedCategory", category);
}

/// Combines both upload and logging for convenience
Future<void> uploadEntryToDriveAndSheets({
  required File file,
  required String filename,
  required String category,
  required DateTime date,
  required String amount,
  required GoogleSignInAccount user,
}) async {
  final success = await uploadToDrive(
    user: user,
    file: file,
    filename: filename,
    category: category,
  );

  if (!success) {
    throw Exception("Upload to Google Drive failed");
  }

  await logToSheet(
    user: user,
    filename: filename,
    category: category,
    date: date,
    amount: amount,
  );
}
