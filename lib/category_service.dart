import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  static const _storageKey = 'customCategories';

  /// Load all stored categories
  static Future<List<String>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_storageKey) ?? [];
  }

  /// Add a new category if it doesn't exist
  static Future<List<String>> addCategory(String newCategory) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey) ?? [];

    if (!stored.contains(newCategory)) {
      stored.add(newCategory);
      await prefs.setStringList(_storageKey, stored);
    }

    return stored;
  }

  /// Remove a category if it exists
  static Future<List<String>> removeCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey) ?? [];

    stored.remove(category);
    await prefs.setStringList(_storageKey, stored);
    return stored;
  }
}
