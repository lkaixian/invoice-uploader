import 'package:flutter/material.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';
import 'category_manage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryPickerPage extends StatefulWidget {
  final void Function(String category) onCategorySelected;
  final String? initialCategory;

  const CategoryPickerPage({
    super.key,
    required this.onCategorySelected,
    this.initialCategory,
  });

  @override
  State<CategoryPickerPage> createState() => _CategoryPickerPageState();
}

class _CategoryPickerPageState extends State<CategoryPickerPage> {
  List<String> _categories = [];
  String? _selectedCategory;
  final TextEditingController _customCategoryController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final stored = await CategoryService.loadCategories();
    final prefs = await SharedPreferences.getInstance();
    final lastUsed = prefs.getString("lastUsedCategory");

    setState(() {
      _categories = [...stored, S.of(context)!.addCategoryOption];

      if (_selectedCategory == null && stored.isNotEmpty) {
        _selectedCategory = lastUsed != null && stored.contains(lastUsed)
            ? lastUsed
            : stored.first;
      }
    });
  }

  Future<void> _addCategory(String newCategory) async {
    final stored = await CategoryService.addCategory(newCategory);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("lastUsedCategory", newCategory);

    setState(() {
      _categories = [...stored, S.of(context)!.addCategoryOption];
      _selectedCategory = newCategory;
      _customCategoryController.clear();
    });
  }

  Future<void> _removeCategory(String category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.of(context)!.deleteCategoryTitle(category)),
        content: Text(S.of(context)!.deleteCategoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(S.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final stored = await CategoryService.removeCategory(category);
      setState(() {
        _categories = [...stored, S.of(context)!.addCategoryOption];
        if (_selectedCategory == category) _selectedCategory = null;
      });
    }
  }

  void _proceed() async {
    if (_selectedCategory != null) {
      final selected = _selectedCategory == S.of(context)!.addCategoryOption
          ? _customCategoryController.text.trim()
          : _selectedCategory!;

      if (selected.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("lastUsedCategory", selected);
        widget.onCategorySelected(selected);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final addOption = S.of(context)!.addCategoryOption;
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context)!.categoryLabel)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: S.of(context)!.categoryLabel,
              ),
              value: _selectedCategory,
              items: _categories.map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: GestureDetector(
                    onLongPress: c != addOption
                        ? () => _removeCategory(c)
                        : null,
                    child: Text(c),
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value),
            ),
            if (_selectedCategory == addOption)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customCategoryController,
                      decoration: InputDecoration(
                        labelText: S.of(context)!.newCategoryLabel,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      final input = _customCategoryController.text.trim();
                      if (input.isNotEmpty) {
                        _addCategory(input);
                      }
                    },
                  ),
                ],
              ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _proceed,
              icon: const Icon(Icons.arrow_forward),
              label: Text(S.of(context)!.next),
            ),
          ],
        ),
      ),
    );
  }
}
