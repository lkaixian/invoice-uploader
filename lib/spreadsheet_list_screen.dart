import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'google_sheets_helper.dart'; // Make sure this path is correct

class SpreadsheetListScreen extends StatefulWidget {
  final String spreadsheetId;
  final String category;
  final GoogleSignInAccount user;

  const SpreadsheetListScreen({
    required this.spreadsheetId,
    required this.category,
    required this.user,
    super.key,
  });

  @override
  State<SpreadsheetListScreen> createState() => _SpreadsheetListScreenState();
}

class _SpreadsheetListScreenState extends State<SpreadsheetListScreen> {
  List<List<String>> _rows = [];

  @override
  void initState() {
    super.initState();
    _loadRows();
  }

  Future<void> _loadRows() async {
    final helper = GoogleSheetsHelper(widget.user);
    final fetchedRows = await helper.fetchCategorySheetRows(
      widget.spreadsheetId,
      widget.category,
    );
    setState(() {
      _rows = fetchedRows;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: _rows.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _rows.length,
              itemBuilder: (context, index) {
                final row = _rows[index];
                return ListTile(
                  title: Text(row.join(" | ")),
                );
              },
            ),
    );
  }
}
