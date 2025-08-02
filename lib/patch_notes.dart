import 'package:flutter/material.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';

class PatchNotesScreen extends StatelessWidget {
  const PatchNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final S s = S.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(s.changelogTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              "📦 V0.2.1 - NIGHTLY BUILD REVISION 6",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text("• ${s.changelog_latest_1}"),
            Text("• ${s.changelog_latest_2}"),
            Text("• ${s.changelog_latest_3}"),
            Text("• ${s.changelog_latest_4}"),
            Text("• ${s.changelog_latest_5}"),
            Text("• ${s.changelog_latest_6}"),
            Text("• ${s.changelog_latest_7}"),
            Text("• ${s.changelog_latest_8}"),
            Text("• ${s.changelog_latest_9}"),
            Text("• ${s.changelog_latest_note}"),
            const SizedBox(height: 24),
            Text(
              "📦 V0.2.1 - NIGHTLY BUILD REVISION 5",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text("• ${s.changelog_1}"),
            Text("• ${s.changelog_2}"),
            Text("• ${s.changelog_3}"),
            Text("• ${s.changelog_4}"),
            Text("• ${s.changelog_5}"),
            Text("• ${s.changelog_6}"),
            Text("• ${s.changelog_7}"),
            Text("• ${s.changelog_8}"),
            Text("• ${s.changelog_note}"),
          ],
        ),
      ),
    );
  }
}
