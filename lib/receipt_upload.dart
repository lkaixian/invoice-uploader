import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'google_drive_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'google_sheets_helper.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';
import 'category_service.dart';
import 'sheet_config.dart';

class ReceiptUploadScreen extends StatefulWidget {
  final GoogleSignInAccount user;
  const ReceiptUploadScreen({required this.user, super.key});

  @override
  State<ReceiptUploadScreen> createState() => _ReceiptUploadScreenState();
}

class _ReceiptUploadScreenState extends State<ReceiptUploadScreen> {
  File? _selectedImage;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _customCategoryController =
      TextEditingController();
  final TextEditingController _filenameController = TextEditingController();
  final FocusNode _filenameFocusNode = FocusNode();

  String? _selectedCategory;
  DateTime? _selectedDate;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();

    _filenameFocusNode.addListener(() {
      if (_filenameFocusNode.hasFocus &&
          _filenameController.text.isEmpty &&
          _selectedDate != null) {
        _autoGenerateFilename();
      }
    });
  }

  Future<void> _loadCategories() async {
    final stored = await CategoryService.loadCategories();
    setState(() {
      _categories = [...stored, S.of(context)!.addCategoryOption];
    });
  }

  Future<void> _addCategory(String newCategory) async {
    final stored = await CategoryService.addCategory(newCategory);
    setState(() {
      _categories = [...stored, S.of(context)!.addCategoryOption];
      _selectedCategory = newCategory;
      _customCategoryController.clear();
    });
  }

  Future<void> _removeCategory(String category) async {
    final stored = await CategoryService.removeCategory(category);
    setState(() {
      _categories = [...stored, S.of(context)!.addCategoryOption];
      if (_selectedCategory == category) _selectedCategory = null;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  bool get _isFormComplete {
    final isCategoryValid =
        _selectedCategory != null &&
        (_selectedCategory != S.of(context)!.addCategoryOption ||
            _customCategoryController.text.isNotEmpty);
    return _selectedImage != null &&
        _amountController.text.isNotEmpty &&
        _filenameController.text.isNotEmpty &&
        _selectedDate != null &&
        isCategoryValid;
  }

  void _autoGenerateFilename() {
    if (_filenameController.text.trim().isNotEmpty) return;
    final cat = _selectedCategory == S.of(context)!.addCategoryOption
        ? _customCategoryController.text.trim()
        : _selectedCategory ?? 'receipt';
    final date = _selectedDate ?? DateTime.now();
    final timestamp =
        "${date.day.toString().padLeft(2, '0')}"
        "${date.month.toString().padLeft(2, '0')}"
        "${date.year.toString().substring(2)}";
    final generated = "${cat}_$timestamp".toLowerCase().replaceAll(" ", "_");
    _filenameController.text = generated;
  }

  void _showDeleteDialog(String category) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.of(context)!.deleteCategoryTitle(category)),
        content: Text(S.of(context)!.deleteCategoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context)!.cancel),
          ),
          ElevatedButton(
            child: Text(S.of(context)!.delete),
            onPressed: () async {
              Navigator.pop(context);
              await _removeCategory(category);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _uploadAndReturn() async {
    _autoGenerateFilename();

    if (_selectedImage == null) return;

    final uploader = GoogleDriveUploader(widget.user);
    final category = _selectedCategory == S.of(context)!.addCategoryOption
        ? _customCategoryController.text
        : _selectedCategory!.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("lastCategory", category.trim());

    // 🔒 Show blocking progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Expanded(child: Text(S.of(context)!.uploadingPleaseWait)),
            ],
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 100));

    try {
      final success = await uploader.uploadFile(
        file: _selectedImage!,
        fileName: _filenameController.text.trim(),
        folderName: category,
      );

      if (success) {
        final sheets = GoogleSheetsHelper(widget.user);
        final sheetId = await sheets.getOrCreateMainSpreadsheet();

        await sheets.ensureCategorySheetExists(sheetId, category);
        await sheets.appendToCategorySheet(sheetId, category, [
          _selectedDate!.toIso8601String().split('T').first,
          _amountController.text.trim(),
          _filenameController.text.trim(),
        ]);

        // ✅ Save the sheet ID and last used category
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("sheetId_$category", sheetId);
        await prefs.setString("lastUsedCategory", category);

        Navigator.pop(context); // Close progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context)!.uploadSuccessSnackbar)),
        );
        Navigator.pop(context); // Close upload screen
      } else {
        Navigator.pop(context); // Close progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context)!.uploadFailedSnackbar)),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close progress dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(S.of(context)!.uploadErrorTitle),
          content: Text("$e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context)!.ok),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = _selectedCategory == '➕ Add Category'
        ? _customCategoryController.text
        : _selectedCategory ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context)!.receiptUpload)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              height: 200,
              color: Colors.grey[300],
              child: _selectedImage != null
                  ? Image.file(_selectedImage!, fit: BoxFit.cover)
                  : Center(child: Text(S.of(context)!.noImageSelected)),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.camera_alt),
                  label: Text(S.of(context)!.cameraButton),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.photo_library),
                  label: Text(S.of(context)!.galleryButton),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: S.of(context)!.categoryLabel,
              ),
              items: _categories.map((c) {
                return DropdownMenuItem<String>(
                  value: c,
                  child: GestureDetector(
                    onLongPress: c != S.of(context)!.addCategoryOption
                        ? () => _showDeleteDialog(c)
                        : null,
                    child: Text(c),
                  ),
                );
              }).toList(),
              value: _selectedCategory,
              onChanged: (value) => setState(() => _selectedCategory = value),
            ),
            if (_selectedCategory == S.of(context)!.addCategoryOption)
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
                    icon: Icon(Icons.check),
                    onPressed: () {
                      if (_customCategoryController.text.isNotEmpty) {
                        _addCategory(_customCategoryController.text.trim());
                      }
                    },
                  ),
                ],
              ),

            const SizedBox(height: 20),

            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: S.of(context)!.amountLabel,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              focusNode: _filenameFocusNode,
              controller: _filenameController,
              decoration: InputDecoration(
                labelText: S.of(context)!.filenameLabel,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.calendar_today),
                  label: Text(S.of(context)!.pickDate),
                  onPressed: _pickDate,
                ),
                const SizedBox(width: 10),
                Text(
                  _selectedDate != null
                      ? "${_selectedDate!.day.toString().padLeft(2, '0')}/"
                            "${_selectedDate!.month.toString().padLeft(2, '0')}/"
                            "${_selectedDate!.year}"
                      : S.of(context)!.noDateSelected,
                ),
              ],
            ),
            const SizedBox(height: 30),

            ElevatedButton.icon(
              icon: Icon(Icons.cloud_upload),
              label: Text(S.of(context)!.uploadButton),
              onPressed: _isFormComplete ? _uploadAndReturn : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormComplete ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
