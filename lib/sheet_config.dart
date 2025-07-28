import 'package:shared_preferences/shared_preferences.dart';

class SheetConfig {
  // Singleton instance
  static final SheetConfig _instance = SheetConfig._internal();
  factory SheetConfig() => _instance;
  SheetConfig._internal();

  static const String _keySheetId = 'sheetId';
  static const String _defaultSheetId = 'InvoiceLog';

  String _currentSheetId = _defaultSheetId;
  bool _initialized = false;

  // Getter to retrieve the current sheet ID
  String get currentSheetId => _currentSheetId;

  // Returns true if the sheet ID has not been changed by the user
  bool get isDefault => _currentSheetId == _defaultSheetId;

  // Initializes the config from SharedPreferences. Should be called early (e.g., in `main()`).
  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    _currentSheetId = prefs.getString(_keySheetId) ?? _defaultSheetId;
    _initialized = true;
  }

  // Updates the sheet ID and stores it in SharedPreferences
  Future<void> updateSheetId(String newSheetId) async {
    _currentSheetId = newSheetId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySheetId, newSheetId);
  }

  // Resets the sheet ID to the default value
  Future<void> resetToDefault() async {
    _currentSheetId = _defaultSheetId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySheetId, _defaultSheetId);
    await prefs.remove('spreadsheetId'); // Clear cached spreadsheet ID
  }
}
