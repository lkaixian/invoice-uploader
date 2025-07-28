import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'google_sheets_helper.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

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
  List<String> categories = [];

  String selectedCategory = 'All';
  bool loading = true;
  late DateTime selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now();
    _loadExpenses();
  }

  String _getLocalizedMonthName(BuildContext context, int month) {
    final s = S.of(context)!;
    switch (month) {
      case 1:
        return s.monthJanuary;
      case 2:
        return s.monthFebruary;
      case 3:
        return s.monthMarch;
      case 4:
        return s.monthApril;
      case 5:
        return s.monthMay;
      case 6:
        return s.monthJune;
      case 7:
        return s.monthJuly;
      case 8:
        return s.monthAugust;
      case 9:
        return s.monthSeptember;
      case 10:
        return s.monthOctober;
      case 11:
        return s.monthNovember;
      case 12:
        return s.monthDecember;
      default:
        return '';
    }
  }

  Future<void> _loadExpenses() async {
    setState(() => loading = true);
    final helper = GoogleSheetsHelper(widget.user);

    final allCategories = await helper.getCategories(widget.spreadsheetId);
    categories = ['All', ...allCategories];
    Map<String, double> totals = {};
    List<Map<String, dynamic>> expenses = [];

    final monthStr =
        "${selectedMonth.year}-${selectedMonth.month.toString().padLeft(2, '0')}";

    for (final category in allCategories) {
      if (selectedCategory != 'All' && selectedCategory != category) continue;

      final rows = await helper.fetchCategorySheetRows(
        widget.spreadsheetId,
        category,
      );
      for (final row in rows) {
        if (row.length < 3) continue;
        final date = row[0];
        final amount = double.tryParse(row[1]) ?? 0;
        final filename = row[2];

        if (date.startsWith(monthStr)) {
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
    if (!mounted) return;
    setState(() {
      categoryTotals = totals;
      allExpenses = expenses;
      loading = false;
    });
  }

  void _selectMonth() async {
    final now = DateTime.now();
    final picked = await showMonthPicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2022, 1),
      lastDate: DateTime(now.year, now.month),
    );

    if (picked != null) {
      setState(() => selectedMonth = DateTime(picked.year, picked.month));
      _loadExpenses();
    }
  }

  void _selectCategory(String? newCategory) {
    if (newCategory != null && newCategory != selectedCategory) {
      setState(() {
        selectedCategory = newCategory;
      });
      _loadExpenses();
    }
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

    final formattedMonth =
        "${selectedMonth.year}-${selectedMonth.month.toString().padLeft(2, '0')}";

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(S.of(context)!.viewExpenses)),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 🔽 Month + Category Dropdown
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            setState(() {
                              selectedMonth = DateTime(
                                selectedMonth.year,
                                selectedMonth.month - 1,
                              );
                            });
                            _loadExpenses();
                          },
                        ),
                        Flexible(
                          child: GestureDetector(
                            onTap: _selectMonth,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "${_getLocalizedMonthName(context, selectedMonth.month)} ${selectedMonth.year}",
                                style: Theme.of(context).textTheme.titleLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            final now = DateTime.now();
                            final nextMonth = DateTime(
                              selectedMonth.year,
                              selectedMonth.month + 1,
                            );
                            if (nextMonth.isBefore(
                              DateTime(now.year, now.month + 1),
                            )) {
                              setState(() {
                                selectedMonth = nextMonth;
                              });
                              _loadExpenses();
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedCategory,
                            items: categories
                                .map(
                                  (cat) => DropdownMenuItem(
                                    value: cat,
                                    child: Text(
                                      cat,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: _selectCategory,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    if (categoryTotals.isNotEmpty)
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            centerSpaceRadius: 0,
                            sections: [
                              ...topCategories.map(
                                (e) => PieChartSectionData(
                                  value: e.value,
                                  title: e.key,
                                  color:
                                      Colors.primaries[topCategories.indexOf(
                                            e,
                                          ) %
                                          Colors.primaries.length],
                                  showTitle: true,
                                  radius: 100,
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
                      S.of(context)!.topCategories,
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
                                "${S.of(context)!.theme} - ${S.of(context)!.spreadsheet}",
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
                      S.of(context)!.topSpends,
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
                                "${S.of(context)!.theme} - ${S.of(context)!.spreadsheet}",
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
      ),
    );
  }
}
