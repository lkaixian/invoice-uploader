import 'dart:io' as io show File;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'google_drive_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'google_sheets_helper.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';
import 'category_service.dart';
import 'upload_notification.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class ReceiptUploadScreen extends StatefulWidget {
  final GoogleSignInAccount user;
  const ReceiptUploadScreen({required this.user, super.key});

  @override
  State<ReceiptUploadScreen> createState() => _ReceiptUploadScreenState();
}

class _ReceiptUploadScreenState extends State<ReceiptUploadScreen> {
  io.File? _selectedImage;
  Uint8List? _webImageBytes;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _customCategoryController =
      TextEditingController();
  final TextEditingController _filenameController = TextEditingController();
  final FocusNode _filenameFocusNode = FocusNode();
  bool _autoFilenameEnabled = false;

  String? _selectedCategory;
  DateTime? _selectedDate;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadAutoFilenameSetting();

    _filenameFocusNode.addListener(() {
      if (_filenameFocusNode.hasFocus &&
          _filenameController.text.isEmpty &&
          _selectedDate != null) {
        _autoGenerateFilename();
      }
    });
  }

  Future<void> _loadAutoFilenameSetting() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('autoFilename') ?? false;
    setState(() {
      _autoFilenameEnabled = enabled;
      if (_autoFilenameEnabled) {
        _autoGenerateFilename(); // Set the filename when the screen loads
      }
    });
  }

  Future<void> _loadCategories() async {
    final savedCategories = await CategoryService.loadCategories();
    final prefs = await SharedPreferences.getInstance();
    final lastUsed = prefs.getString("lastUsedCategory");

    setState(() {
      _categories = savedCategories;
      _selectedCategory = lastUsed != null && savedCategories.contains(lastUsed)
          ? lastUsed
          : (savedCategories.isNotEmpty ? savedCategories.first : null);
    });
  }

  Future<String?> _showAddCategoryDialog() async {
    String input = '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.newCategoryLabel),
        content: TextField(
          autofocus: true,
          onChanged: (val) => input = val,
          decoration: InputDecoration(
            hintText: S.of(context)!.newCategoryLabel,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, input),
            child: Text(S.of(context)!.addCategoryOption),
          ),
        ],
      ),
    );
  }

  void _addCategory(String category) async {
    if (!_categories.contains(category)) {
      final updated = await CategoryService.addCategory(category);
      setState(() {
        _categories = updated;
        _selectedCategory = category;
      });
    }
  }

  void _showDeleteDialog(String category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.deleteCategoryTitle(category)),
        content: Text(
          S
              .of(context)!
              .deleteCategoryConfirm
              .replaceAll('{category}', category),
        ),
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

    if (confirm == true) {
      final updated = await CategoryService.removeCategory(category);
      setState(() {
        _categories = updated;
        if (_selectedCategory == category) {
          _selectedCategory = _categories.isNotEmpty ? _categories.first : null;
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _selectedImage = null; // Not used on web
        });
      } else {
        setState(() {
          _selectedImage = io.File(picked.path);
          _webImageBytes = null;
        });
      }
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
      setState(() {
        _selectedDate = picked;
        if (_autoFilenameEnabled) _autoGenerateFilename();
      });
    }
  }

  bool get _isFormComplete {
    final isCategoryValid =
        _selectedCategory != null &&
        (_selectedCategory != S.of(context)!.addCategoryOption ||
            _customCategoryController.text.isNotEmpty);

    final hasImage = kIsWeb ? _webImageBytes != null : _selectedImage != null;

    return hasImage &&
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

    final date = _selectedDate;
    final amount = double.tryParse(_amountController.text);

    final dateStr = date?.toIso8601String().split('T')[0] ?? 'no_date';
    final amountStr = amount?.toStringAsFixed(2) ?? 'no_amount';
    final safeCat = cat.isNotEmpty ? cat : 'no_category';

    final generated = '${safeCat}_${dateStr}_$amountStr.jpg'
        .toLowerCase()
        .replaceAll(' ', '_');

    _filenameController.text = generated;
  }

  Future<bool> uploadToDriveWeb({
    required GoogleSignInAccount user,
    required Uint8List fileBytes,
    required String fileName,
    required String folderName,
  }) async {
    final uploader = GoogleDriveUploader(user);
    return await uploader.uploadFileBytes(
      fileBytes: fileBytes,
      fileName: fileName,
      folderName: folderName,
    );
  }

  Future<bool> uploadToDrive({
    required GoogleSignInAccount user,
    required io.File file,
    required String fileName,
    required String folderName,
  }) async {
    final uploader = GoogleDriveUploader(user);
    return await uploader.uploadFile(
      file: file,
      fileName: fileName,
      folderName: folderName,
    );
  }

  Future<void> _uploadAndReturn() async {
    if (!mounted) return;
    final localizations = S.of(context)!;
    _autoGenerateFilename();

    final category = _selectedCategory == localizations.addCategoryOption
        ? _customCategoryController.text
        : _selectedCategory!.trim();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("lastUsedCategory", category.trim());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(child: Text(localizations.uploadingPleaseWait)),
            ],
          ),
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 100));

    try {
      final filename = _filenameController.text.trim();

      bool success;
      if (kIsWeb && _webImageBytes != null) {
        success = await uploadToDriveWeb(
          user: widget.user,
          fileBytes: _webImageBytes!,
          fileName: filename,
          folderName: category,
        );
      } else if (_selectedImage != null) {
        success = await uploadToDrive(
          user: widget.user,
          file: _selectedImage!,
          fileName: filename,
          folderName: category,
        );
      } else {
        throw Exception(localizations.noImageSelected);
      }

      if (!mounted) return;
      Navigator.pop(context); // Close progress dialog

      if (success) {
        final sheets = GoogleSheetsHelper(widget.user);
        final sheetId = await sheets.getOrCreateMainSpreadsheet();
        await sheets.ensureCategorySheetExists(sheetId, category);
        await sheets.appendToCategorySheet(sheetId, category, [
          _selectedDate!.toIso8601String().split('T').first,
          _amountController.text.trim(),
          filename,
        ]);

        await prefs.setString("sheetId_$category", sheetId);
        await prefs.setString("lastUsedCategory", category);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.uploadSuccessSnackbar)),
        );
        Navigator.pop(context); // Close screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.uploadFailedSnackbar)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(localizations.uploadErrorTitle),
          content: Text("$e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations.ok),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context)!.receiptUpload)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              height: 200,
              color: Colors.grey[300],
              child: (kIsWeb && _webImageBytes != null)
                  ? Image.memory(_webImageBytes!, fit: BoxFit.cover)
                  : (_selectedImage != null
                        ? Image.file(_selectedImage!, fit: BoxFit.cover)
                        : Center(child: Text(S.of(context)!.noImageSelected))),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: Text(S.of(context)!.cameraButton),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library),
                  label: Text(S.of(context)!.galleryButton),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: S.of(context)!.categoryLabel,
                      border: const OutlineInputBorder(),
                    ),
                    value: _selectedCategory,
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
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                        if (_autoFilenameEnabled) _autoGenerateFilename();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: S.of(context)!.addCategoryOption,
                  onPressed: () async {
                    final newCategory = await _showAddCategoryDialog();
                    if (newCategory != null && newCategory.trim().isNotEmpty) {
                      _addCategory(newCategory.trim());
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: _selectedCategory != null
                      ? S.of(context)!.deleteCategoryTitle(_selectedCategory!)
                      : S.of(context)!.deleteCategoryTitlePlaceholder,
                  onPressed: _selectedCategory == null
                      ? null
                      : () => _showDeleteDialog(_selectedCategory!),
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: S.of(context)!.amountLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              focusNode: _filenameFocusNode,
              controller: _filenameController,
              readOnly: _autoFilenameEnabled,
              style: TextStyle(
                color: _autoFilenameEnabled
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).textTheme.bodyMedium?.color,
              ),
              decoration: InputDecoration(
                labelText: S.of(context)!.filenameLabel,
                filled: _autoFilenameEnabled,
                fillColor: _autoFilenameEnabled ? Colors.grey[200] : null,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today),
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
              icon: const Icon(Icons.cloud_upload),
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
