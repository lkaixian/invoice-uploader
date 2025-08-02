import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  static const String _key = 'categories';

  /// Load categories from SharedPreferences
  static Future<List<String>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// Add a new category (if it doesn't already exist)
  static Future<List<String>> addCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];

    if (!existing.contains(category)) {
      final updated = [...existing, category];
      await prefs.setStringList(_key, updated);
      return updated;
    }

    return existing;
  }

  /// Remove a category
  static Future<List<String>> removeCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];

    if (existing.contains(category)) {
      final updated = [...existing]..remove(category);
      await prefs.setStringList(_key, updated);
      return updated;
    }

    return existing;
  }
}
