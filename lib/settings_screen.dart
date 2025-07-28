import 'package:flutter/material.dart';
import 'sheet_config.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
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
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _useCustomFileName = false;
  final TextEditingController _fileNameController = TextEditingController(
    text: "InvoiceLog",
  );

  @override
  void initState() {
    super.initState();
    _loadCustomFileNameSettings();
  }

  Future<void> _loadCustomFileNameSettings() async {
    await SheetConfig().init();
    final savedId = SheetConfig().currentSheetId;
    final isCustom = savedId != "InvoiceLog";

    setState(() {
      _useCustomFileName = isCustom;
      _fileNameController.text = savedId;
    });
  }

  Future<void> _saveFileName(String name) async {
    await SheetConfig().updateSheetId(name);
  }

  void _toggleCustomFileName(bool? value) {
    final newValue = value ?? false;
    setState(() {
      _useCustomFileName = newValue;
      if (!newValue) {
        _fileNameController.text = "InvoiceLog";
        _saveFileName("InvoiceLog");
      } else {
        _saveFileName(_fileNameController.text);
      }
    });
  }

  void _handleFileNameChange(String value) {
    if (_useCustomFileName) {
      _saveFileName(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context)!.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLanguageTile(context),
          _buildThemeTile(context),
          const Divider(),
          _buildCustomFileNameSettings(),
          _buildCawfeeButton(context),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(S.of(context)!.language),
      onTap: () => _showLanguageDialog(context),
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    final theme = widget.themeMode;
    final subtitle = theme == ThemeMode.dark
        ? S.of(context)!.themeDark
        : theme == ThemeMode.light
        ? S.of(context)!.themeLight
        : S.of(context)!.themeSystem;

    final icon = theme == ThemeMode.dark
        ? Icons.dark_mode
        : theme == ThemeMode.light
        ? Icons.light_mode
        : Icons.brightness_auto;

    return ListTile(
      leading: Icon(icon),
      title: Text(S.of(context)!.theme),
      subtitle: Text(subtitle),
      onTap: () => _showThemeDialog(context),
    );
  }

  Widget _buildCustomFileNameSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: const Text("Use custom file name"),
          value: _useCustomFileName,
          onChanged: _toggleCustomFileName,
        ),
        TextField(
          controller: _fileNameController,
          enabled: _useCustomFileName,
          decoration: const InputDecoration(
            labelText: "Spreadsheet Title",
            hintText: "e.g. InvoiceLog",
          ),
          onChanged: _handleFileNameChange,
        ),
      ],
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
                widget.onLocaleChanged(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("简体中文"),
              onTap: () {
                widget.onLocaleChanged(const Locale('zh'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Bahasa Melayu"),
              onTap: () {
                widget.onLocaleChanged(const Locale('ms'));
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
            _buildThemeOption(ThemeMode.system, S.of(context)!.themeSystem),
            _buildThemeOption(ThemeMode.light, S.of(context)!.themeLight),
            _buildThemeOption(ThemeMode.dark, S.of(context)!.themeDark),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(ThemeMode mode, String label) {
    return RadioListTile<ThemeMode>(
      value: mode,
      groupValue: widget.themeMode,
      title: Text(label),
      onChanged: (selectedMode) {
        if (selectedMode != null) {
          widget.onThemeChanged(selectedMode);
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildCawfeeButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.coffee),
      title: Text(S.of(context)!.buyMeCoffee),
      subtitle: Text(S.of(context)!.supportMyWork),
      onTap: () async {
        final Uri url = Uri.parse("https://www.buymeacoffee.com/lkaixian");

        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context)!.linkOpenFailed)),
          );
        }
      },
    );
  }
}
