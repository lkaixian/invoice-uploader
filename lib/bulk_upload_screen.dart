import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';
import 'bulk_upload.dart';
import 'settings_screen.dart';

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
    super.key,
    required this.category,
    required this.onUpload,
    required this.user,
  });

  @override
  State<BulkUploadScreen> createState() => _BulkUploadScreenState();
}

class _BulkUploadScreenState extends State<BulkUploadScreen> {
  List<BulkUploadEntry> entries = [];
  int currentIndex = 0;

  String _generateFilename(BulkUploadEntry entry) {
    final date = entry.date?.toIso8601String().split('T')[0] ?? 'no_date';
    final amount = entry.amount?.toStringAsFixed(2) ?? 'no_amount';
    return '${widget.category}_${date}_$amount.jpg';
  }

  String truncateFilename(String filename, {int maxLength = 30}) {
    if (filename.length <= maxLength) return filename;
    final dotIndex = filename.lastIndexOf('.');
    final extension = dotIndex != -1 ? filename.substring(dotIndex) : '';
    final base = filename.substring(
      0,
      dotIndex != -1 ? dotIndex : filename.length,
    );
    final allowedLength = maxLength - extension.length - 3;
    return '${base.substring(0, allowedLength.clamp(0, base.length))}...$extension';
  }

  Future<void> _pickFiles({bool append = false}) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.isNotEmpty) {
      final newEntries = result.files.map((f) {
        return BulkUploadEntry(
          file: f,
          filename: truncateFilename(f.name),
          category: widget.category,
        );
      }).toList();

      setState(() {
        if (append) {
          entries.addAll(newEntries);
        } else {
          entries = newEntries;
          currentIndex = 0;
        }
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
    final allValid = entries.every(
      (e) =>
          e.filename.trim().isNotEmpty &&
          e.category.trim().isNotEmpty &&
          e.amount != null &&
          e.date != null,
    );

    if (!allValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context)!.incompleteData)));
      return;
    }

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
              Expanded(child: Text(S.of(context)!.uploadingPleaseWait)),
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

        await uploadEntryToDriveAndSheets(
          file: file,
          filename: entry.filename,
          category: entry.category,
          date: entry.date!,
          amount: entry.amount.toString(),
          user: widget.user,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ ${i + 1}/${entries.length} ${S.of(context)!.uploadSuccessSnackbar}',
            ),
          ),
        );
      }

      Navigator.pop(context); // Close progress
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.uploadSuccessSnackbar)),
      );
      Navigator.pop(context); // Close screen
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(S.of(context)!.uploadErrorTitle),
          content: Text(e.toString()),
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
    final entry = entries.isEmpty ? null : entries[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context)!.bulkUpload)),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: entries.isEmpty
            ? Center(
                child: ElevatedButton(
                  onPressed: () => _pickFiles(),
                  child: Text(S.of(context)!.galleryButton),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${S.of(context)!.file} ${currentIndex + 1}/${entries.length}',
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.upload_file),
                          label: Text(S.of(context)!.selectFiles),
                          onPressed: () => _pickFiles(append: true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (entry?.file.path != null)
                      Center(
                        child: Image.file(
                          File(entry!.file.path!),
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      '${S.of(context)!.filenameLabel}: ${truncateFilename(entry!.filename)}',
                    ),

                    TextFormField(
                      initialValue: entry.category,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: S.of(context)!.categoryLabel,
                      ),
                      onChanged: (val) {
                        setState(() {
                          entry.category = val;
                          _updateAutoFilename(currentIndex);
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Text('${S.of(context)!.pickDate}: '),
                        Text(
                          entry.date?.toLocal().toIso8601String().split(
                                'T',
                              )[0] ??
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
                        Text(S.of(context)!.autoGenerateFilename),
                      ],
                    ),

                    TextFormField(
                      enabled: !entry.autoGenerateFilename,
                      controller: entry.filenameController,
                      decoration: InputDecoration(
                        labelText: S.of(context)!.filenameLabel,
                      ),
                      onChanged: (val) => setState(() => entry.filename = val),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: currentIndex > 0
                              ? () => _goToImage(currentIndex - 1)
                              : null,
                          child: Text(S.of(context)!.previous),
                        ),
                        ElevatedButton(
                          onPressed: currentIndex < entries.length - 1
                              ? () => _goToImage(currentIndex + 1)
                              : null,
                          child: Text(S.of(context)!.next),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

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
      ),
    );
  }
}
