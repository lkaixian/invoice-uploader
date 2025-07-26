import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'google_sheets_helper.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';

class ExpenseOverviewScreen extends StatefulWidget {
  final GoogleSignInAccount user;
  final String spreadsheetId;

  const ExpenseOverviewScreen({
    required this.user,
    required this.spreadsheetId,
    super.key,
  });

  @override
  State<ExpenseOverviewScreen> createState() => _ExpenseOverviewScreenState();
}

class _ExpenseOverviewScreenState extends State<ExpenseOverviewScreen> {
  Map<String, double> categoryTotals = {};
  List<Map<String, dynamic>> allExpenses = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    setState(() => loading = true);
    final helper = GoogleSheetsHelper(widget.user);

    // Fetch all categories (tabs)
    final categories = await helper.getCategories(widget.spreadsheetId);

    Map<String, double> totals = {};
    List<Map<String, dynamic>> expenses = [];

    final now = DateTime.now();
    final thisMonth = "${now.year}-${now.month.toString().padLeft(2, '0')}";

    for (final category in categories) {
      final rows = await helper.fetchCategorySheetRows(
        widget.spreadsheetId,
        category,
      );
      for (final row in rows) {
        if (row.length < 3) continue;
        final date = row[0];
        final amount = double.tryParse(row[1]) ?? 0;
        final filename = row[2];

        // Only include this month's expenses
        if (date.startsWith(thisMonth)) {
          totals[category] = (totals[category] ?? 0) + amount;
          expenses.add({
            'category': category,
            'amount': amount,
            'date': date,
            'filename': filename,
          });
        }
      }
    }

    setState(() {
      categoryTotals = totals;
      allExpenses = expenses;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topCategories = sortedCategories.take(3).toList();
    final otherCategories = sortedCategories.skip(3).toList();

    final sortedExpenses = allExpenses.toList()
      ..sort(
        (a, b) => (b['amount'] as double).compareTo(a['amount'] as double),
      );
    final topExpenses = sortedExpenses.take(3).toList();
    final otherExpenses = sortedExpenses.skip(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context)!.appTitle + " - " + S.of(context)!.spreadsheet,
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    S.of(context)!.spreadsheet,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  if (categoryTotals.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            ...topCategories.map(
                              (e) => PieChartSectionData(
                                value: e.value,
                                title: e.key,
                                color:
                                    Colors.primaries[topCategories.indexOf(e) %
                                        Colors.primaries.length],
                              ),
                            ),
                            if (otherCategories.isNotEmpty)
                              PieChartSectionData(
                                value: otherCategories.fold(
                                  0.0,
                                  (sum, e) => sum! + e.value,
                                ),
                                title: S.of(context)!.viewAll,
                                color: Colors.grey,
                              ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    S.of(context)!.theme + " - Top 3 Categories",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ...topCategories.map(
                    (e) => ListTile(
                      title: Text(e.key),
                      trailing: Text(e.value.toStringAsFixed(2)),
                    ),
                  ),
                  if (otherCategories.isNotEmpty)
                    TextButton(
                      child: Text(S.of(context)!.viewAll),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(
                              S.of(context)!.theme +
                                  " - " +
                                  S.of(context)!.spreadsheet,
                            ),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ListView(
                                shrinkWrap: true,
                                children: otherCategories
                                    .map(
                                      (e) => ListTile(
                                        title: Text(e.key),
                                        trailing: Text(
                                          e.value.toStringAsFixed(2),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  const Divider(),
                  Text(
                    S.of(context)!.theme + " - Top 3 Spends",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ...topExpenses.map(
                    (e) => ListTile(
                      title: Text("${e['category']} (${e['date']})"),
                      subtitle: Text(e['filename']),
                      trailing: Text(
                        (e['amount'] as double).toStringAsFixed(2),
                      ),
                    ),
                  ),
                  if (otherExpenses.isNotEmpty)
                    TextButton(
                      child: Text(S.of(context)!.viewAll),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(
                              S.of(context)!.theme +
                                  " - " +
                                  S.of(context)!.spreadsheet,
                            ),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ListView(
                                shrinkWrap: true,
                                children: otherExpenses
                                    .map(
                                      (e) => ListTile(
                                        title: Text(
                                          "${e['category']} (${e['date']})",
                                        ),
                                        subtitle: Text(e['filename']),
                                        trailing: Text(
                                          (e['amount'] as double)
                                              .toStringAsFixed(2),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
}
