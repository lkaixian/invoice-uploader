import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sheet_config.dart';

class GoogleSheetsHelper {
  final GoogleSignInAccount account;
  final _sheetsApiBase = "https://sheets.googleapis.com/v4/spreadsheets";
  final _driveApiBase = "https://www.googleapis.com/drive/v3/files";

  GoogleSheetsHelper(this.account);

  Future<String?> _getAuthToken() async {
    final auth = await account.authentication;
    return auth.accessToken;
  }

  /// Get or create a single master spreadsheet and store/retrieve its ID using SharedPreferences
  Future<String> getOrCreateMainSpreadsheet() async {
    final prefs = await SharedPreferences.getInstance();
    final sheetTitle = SheetConfig().currentSheetId;
    final cachedId = prefs.getString('spreadsheetId_$sheetTitle');
    if (cachedId != null && cachedId.isNotEmpty) {
      return cachedId;
    }

    final token = await _getAuthToken();

    // Search for spreadsheet by title
    final query =
        "mimeType='application/vnd.google-apps.spreadsheet' and name='$sheetTitle' and trashed=false";
    final searchRes = await http.get(
      Uri.parse("$_driveApiBase?q=${Uri.encodeComponent(query)}"),
      headers: {"Authorization": "Bearer $token"},
    );

    final data = jsonDecode(searchRes.body);
    if (data['files'] != null && data['files'].isNotEmpty) {
      final existingId = data['files'][0]['id'];
      await prefs.setString('spreadsheetId_$sheetTitle', existingId);
      return existingId;
    }

    // Create the spreadsheet if not found
    final createRes = await http.post(
      Uri.parse(_sheetsApiBase),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "properties": {"title": sheetTitle},
      }),
    );

    final created = jsonDecode(createRes.body);
    final newId = created['spreadsheetId'];
    await prefs.setString('spreadsheetId', newId);
    return newId;
  }

  /// Ensure a worksheet/tab exists with category name
  Future<void> ensureCategorySheetExists(
    String spreadsheetId,
    String category,
  ) async {
    final token = await _getAuthToken();

    final getSheetRes = await http.get(
      Uri.parse("$_sheetsApiBase/$spreadsheetId"),
      headers: {"Authorization": "Bearer $token"},
    );
    final sheetData = jsonDecode(getSheetRes.body);
    final sheetsRaw = sheetData['sheets'];
    final sheets = (sheetsRaw is List) ? sheetsRaw : <dynamic>[];

    final exists = sheets.any(
      (sheet) =>
          sheet['properties']?['title']?.toString().toLowerCase() ==
          category.toLowerCase(),
    );

    if (!exists) {
      await http.post(
        Uri.parse("$_sheetsApiBase/$spreadsheetId:batchUpdate"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "requests": [
            {
              "addSheet": {
                "properties": {"title": category},
              },
            },
          ],
        }),
      );
    }
  }

  /// Append a row to the specified category tab
  Future<void> appendToCategorySheet(
    String spreadsheetId,
    String category,
    List<String> rowData,
  ) async {
    final token = await _getAuthToken();

    final range = "${Uri.encodeComponent(category)}!A:C";
    final body = jsonEncode({
      "values": [rowData],
    });

    await http.post(
      Uri.parse(
        "$_sheetsApiBase/$spreadsheetId/values/$range:append?valueInputOption=USER_ENTERED",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: body,
    );
  }

  Future<List<List<String>>> fetchCategorySheetRows(
    String spreadsheetId,
    String category,
  ) async {
    final token = await _getAuthToken();
    final range = "${Uri.encodeComponent(category)}!A:C";

    final response = await http.get(
      Uri.parse("$_sheetsApiBase/$spreadsheetId/values/$range"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load data: ${response.body}");
    }

    final data = jsonDecode(response.body);

    // ✅ Proper null check
    if (data['values'] == null) {
      return []; // No rows in this category yet
    }

    // ✅ Defensive row casting
    final rawValues = data['values'];
    return rawValues
        .where((row) => row is List)
        .map<List<String>>(
          (row) => List<String>.from(row.map((e) => e?.toString() ?? "")),
        )
        .toList();
  }

  // Add to GoogleSheetsHelper
  Future<List<String>> getCategories(String spreadsheetId) async {
    final token = await _getAuthToken();
    final res = await http.get(
      Uri.parse("$_sheetsApiBase/$spreadsheetId"),
      headers: {"Authorization": "Bearer $token"},
    );
    final data = jsonDecode(res.body);
    final sheetsRaw = data['sheets'];
    final sheets = (sheetsRaw is List) ? sheetsRaw : <dynamic>[];
    return sheets
        .where(
          (s) =>
              s != null &&
              s is Map &&
              s['properties'] != null &&
              s['properties']['title'] != null,
        )
        .map((s) => s['properties']['title'].toString())
        .toList();
  }
}

/// Description: This helper class provides methods to interact with Google Sheets API, including creating or retrieving a master spreadsheet, ensuring category sheets exist, appending data, and fetching rows from specific category sheets.
