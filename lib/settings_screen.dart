import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeChanged;
  final Function(Locale) onLocaleChanged;

  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context)!.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(S.of(context)!.language),
            onTap: () => _showLanguageDialog(context),
          ),
          ListTile(
            leading: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : themeMode == ThemeMode.light
                  ? Icons.light_mode
                  : Icons.brightness_auto,
            ),
            title: Text(S.of(context)!.theme),
            subtitle: Text(
              themeMode == ThemeMode.dark
                  ? S.of(context)!.themeDark
                  : themeMode == ThemeMode.light
                  ? S.of(context)!.themeLight
                  : S.of(context)!.themeSystem,
            ),
            onTap: () => _showThemeDialog(context),
          ),
          // Add more settings options here in the future
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("English"),
              onTap: () {
                onLocaleChanged(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("简体中文"),
              onTap: () {
                onLocaleChanged(const Locale('zh'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Bahasa Melayu"),
              onTap: () {
                onLocaleChanged(const Locale('ms'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: themeMode,
              title: Text(S.of(context)!.themeSystem),
              onChanged: (mode) {
                if (mode != null) onThemeChanged(mode);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: themeMode,
              title: Text(S.of(context)!.themeLight),
              onChanged: (mode) {
                if (mode != null) onThemeChanged(mode);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: themeMode,
              title: Text(S.of(context)!.themeDark),
              onChanged: (mode) {
                if (mode != null) onThemeChanged(mode);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
