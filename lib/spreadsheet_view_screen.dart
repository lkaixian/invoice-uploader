import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    const sheetTitle = "InvoiceLog";

    final cachedId = prefs.getString('spreadsheetId');
    if (cachedId != null && cachedId.isNotEmpty) {
      return cachedId;
    }

    final token = await _getAuthToken();

    // Search for spreadsheet by title
    final query = "mimeType='application/vnd.google-apps.spreadsheet' and name='$sheetTitle' and trashed=false";
    final searchRes = await http.get(
      Uri.parse("$_driveApiBase?q=${Uri.encodeComponent(query)}"),
      headers: { "Authorization": "Bearer $token" },
    );

    final data = jsonDecode(searchRes.body);
    if (data['files'] != null && data['files'].isNotEmpty) {
      final existingId = data['files'][0]['id'];
      await prefs.setString('spreadsheetId', existingId);
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
  Future<void> ensureCategorySheetExists(String spreadsheetId, String category) async {
    final token = await _getAuthToken();

    final getSheetRes = await http.get(
      Uri.parse("$_sheetsApiBase/$spreadsheetId"),
      headers: { "Authorization": "Bearer $token" },
    );
    final sheetData = jsonDecode(getSheetRes.body);
    final sheets = sheetData['sheets'] as List;

    final exists = sheets.any((sheet) =>
        sheet['properties']?['title']?.toString().toLowerCase() == category.toLowerCase());

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
                "properties": {"title": category}
              }
            }
          ]
        }),
      );
    }
  }

  /// Append a row to the specified category tab
  Future<void> appendToCategorySheet(String spreadsheetId, String category, List<String> rowData) async {
    final token = await _getAuthToken();

    final range = "${Uri.encodeComponent(category)}!A:C";
    final body = jsonEncode({
      "values": [rowData]
    });

    await http.post(
      Uri.parse("$_sheetsApiBase/$spreadsheetId/values/$range:append?valueInputOption=USER_ENTERED"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: body,
    );
  }

  /// Fetch rows from a category tab
  Future<List<List<String>>> fetchCategorySheetRows(String spreadsheetId, String category) async {
    final token = await _getAuthToken();
    final range = "${Uri.encodeComponent(category)}!A:C";

    final response = await http.get(
      Uri.parse("$_sheetsApiBase/$spreadsheetId/values/$range"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) throw Exception("Failed to load data: ${response.body}");

    final data = jsonDecode(response.body);
    final values = data['values'] as List<dynamic>?;

    return values?.map<List<String>>((row) => List<String>.from(row)).toList() ?? [];
  }
}