import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';
import 'bulk_upload.dart';

class BulkUploadEntry {
  final PlatformFile file;
  DateTime? date;
  double? amount;
  String filename;
  String category;
  bool autoGenerateFilename;

  final TextEditingController amountController;
  final TextEditingController filenameController;

  BulkUploadEntry({
    required this.file,
    this.date,
    this.amount,
    this.filename = '',
    this.category = '',
    this.autoGenerateFilename = false,
  }) : amountController = TextEditingController(text: amount?.toString() ?? ''),
       filenameController = TextEditingController(text: filename);
}

class BulkUploadScreen extends StatefulWidget {
  final String category;
  final Future<void> Function(List<BulkUploadEntry>) onUpload;
  final GoogleSignInAccount user;

  const BulkUploadScreen({
    Key? key,
    required this.category,
    required this.onUpload,
    required this.user,
  }) : super(key: key);

  @override
  State<BulkUploadScreen> createState() => _BulkUploadScreenState();
}

class _BulkUploadScreenState extends State<BulkUploadScreen> {
  List<BulkUploadEntry> entries = [];
  int currentIndex = 0;

  String _generateFilename(BulkUploadEntry entry) {
    final date = entry.date?.toIso8601String().split('T')[0] ?? 'no_date';
    final amount = entry.amount?.toStringAsFixed(2) ?? 'no_amount';
    return '${widget.category}_$date\_$amount.jpg';
  }

  String truncateFilename(String filename, {int maxLength = 30}) {
    if (filename.length <= maxLength) return filename;

    final dotIndex = filename.lastIndexOf('.');
    final extension = (dotIndex != -1) ? filename.substring(dotIndex) : '';
    final baseName = filename.substring(
      0,
      dotIndex != -1 ? dotIndex : filename.length,
    );

    final allowedBaseLength = maxLength - extension.length - 3; // 3 for "..."
    final truncatedBase = baseName.substring(
      0,
      allowedBaseLength.clamp(0, baseName.length),
    );

    return '$truncatedBase...$extension';
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() {
        entries = result.files.map((f) {
          return BulkUploadEntry(
            file: f,
            filename: truncateFilename(f.name),
            category: widget.category,
          );
        }).toList();
        currentIndex = 0;
      });
    }
  }

  void _updateAutoFilename(int index) {
    if (entries[index].autoGenerateFilename) {
      final newName = _generateFilename(entries[index]);
      entries[index].filename = newName;
      entries[index].filenameController.text = newName;
    }
  }

  void _goToImage(int newIndex) {
    final current = entries[currentIndex];
    current.amount = double.tryParse(current.amountController.text);
    current.filename = current.filenameController.text;

    setState(() {
      currentIndex = newIndex;
    });

    final next = entries[newIndex];

    // If auto-generation is on, re-generate the filename
    if (next.autoGenerateFilename) {
      final newName = _generateFilename(next);
      next.filename = newName;
      next.filenameController.text = newName;
    } else {
      next.filenameController.text = next.filename;
    }

    next.amountController.text = next.amount?.toString() ?? '';
  }

  Future<void> _submitAll() async {
    final allFilled = entries.every(
      (e) =>
          e.filename.trim().isNotEmpty &&
          e.category.trim().isNotEmpty &&
          e.amount != null &&
          e.date != null,
    );

    if (!allFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all required fields.")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Expanded(child: Text("Uploading files, please wait...")),
            ],
          ),
        ),
      ),
    );

    try {
      for (int i = 0; i < entries.length; i++) {
        final entry = entries[i];

        entry.amount = double.tryParse(entry.amountController.text);
        entry.filename = entry.filenameController.text.trim();
        final file = File(entry.file.path!);

        setState(() {}); // Optional live UI update

        await uploadEntryToDriveAndSheets(
          file: file,
          filename: entry.filename,
          category: entry.category,
          date: entry.date!,
          amount: entry.amount.toString(),
          user: widget.user,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Uploaded ${i + 1} of ${entries.length}')),
        );
      }

      Navigator.pop(context); // close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All files uploaded successfully.")),
      );
      Navigator.pop(context); // close screen
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Upload Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = entries.isEmpty ? null : entries[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context)!.receiptUpload)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: entries.isEmpty
            ? Center(
                child: ElevatedButton(
                  onPressed: _pickFiles,
                  child: Text(S.of(context)!.galleryButton),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('File ${currentIndex + 1} of ${entries.length}'),
                  const SizedBox(height: 12),

                  if (entry?.file.path != null)
                    Image.file(File(entry!.file.path!), height: 160),

                  const SizedBox(height: 12),
                  Text('Original name: ${entry!.file.name}'),

                  // Category
                  TextFormField(
                    initialValue: entry.category,
                    decoration: const InputDecoration(labelText: "Category"),
                    onChanged: (val) {
                      setState(() {
                        entry.category = val;
                        _updateAutoFilename(currentIndex);
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Date picker
                  Row(
                    children: [
                      Text('${S.of(context)!.pickDate}: '),
                      Text(
                        entry.date?.toLocal().toIso8601String().split('T')[0] ??
                            S.of(context)!.noDateSelected,
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              entry.date = picked;
                              _updateAutoFilename(currentIndex);
                            });
                          }
                        },
                        child: Text(S.of(context)!.pickDate),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Amount
                  TextFormField(
                    controller: entry.amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: S.of(context)!.amountLabel,
                    ),
                    onChanged: (val) {
                      setState(() {
                        entry.amount = double.tryParse(val);
                        _updateAutoFilename(currentIndex);
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Auto-generate filename
                  Row(
                    children: [
                      Checkbox(
                        value: entry.autoGenerateFilename,
                        onChanged: (val) {
                          setState(() {
                            entry.autoGenerateFilename = val ?? false;
                            _updateAutoFilename(currentIndex);
                          });
                        },
                      ),
                      const Text('Auto-generate filename'),
                    ],
                  ),

                  // Filename
                  TextFormField(
                    enabled: !entry.autoGenerateFilename,
                    controller: entry.filenameController,
                    decoration: InputDecoration(
                      labelText: S.of(context)!.filenameLabel,
                    ),
                    onChanged: (val) {
                      setState(() {
                        entry.filename = val;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: currentIndex > 0
                            ? () => _goToImage(currentIndex - 1)
                            : null,
                        child: const Text('Previous'),
                      ),
                      ElevatedButton(
                        onPressed: currentIndex < entries.length - 1
                            ? () => _goToImage(currentIndex + 1)
                            : null,
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Submit
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.cloud_upload),
                      label: Text(S.of(context)!.uploadButton),
                      onPressed: _submitAll,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
