import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'google_signin_helper.dart';
import 'package:invoice_scanner/google_sheets_helper.dart' as sheets;
import 'receipt_upload.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'spreadsheet_list_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';
import 'expense_overview_screen.dart';
import 'settings_screen.dart';
import 'bulk_upload_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GoogleDriveSignIn googleDriveSignIn = GoogleDriveSignIn();
  GoogleSignInAccount? _user;
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;

  void _setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('localeCode', locale.languageCode);
    if (!mounted) return;
    setState(() => _locale = locale);
  }

  void _setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.name);
    if (!mounted) return;
    setState(() => _themeMode = mode);
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('themeMode');
    if (themeString != null) {
      setState(() {
        _themeMode = ThemeMode.values.firstWhere(
          (e) => e.name == themeString,
          orElse: () => ThemeMode.system,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkSignIn();
    _loadLocale();
    _loadThemeMode();
  }

  Future<void> _checkSignIn() async {
    final account = await googleDriveSignIn.signInSilently();
    if (account != null && mounted) {
      setState(() {
        _user = account;
      });
    }
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('localeCode');
    if (!mounted) return;
    if (code != null) {
      setState(() => _locale = Locale(code));
    }
  }

  Future<void> _handleSignIn(BuildContext context) async {
    final account = await googleDriveSignIn.signIn(context);
    if (!mounted) return;
    if (account != null) {
      setState(() => _user = account);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.signedInMessage(account.email))),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context)!.signInCancelled)));
    }
  }

  Future<void> _handleSignOut(BuildContext context) async {
    await googleDriveSignIn.signOut(context);
    if (!mounted) return;
    setState(() => _user = null);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(S.of(context)!.signedOut)));
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
                _setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("简体中文"),
              onTap: () {
                _setLocale(const Locale('zh'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Bahasa Melayu"),
              onTap: () {
                _setLocale(const Locale('ms'));
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
        title: Text(S.of(context)!.appTitle + " Theme"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: _themeMode,
              title: const Text("System Default"),
              onChanged: (mode) {
                if (mode != null) _setThemeMode(mode);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: _themeMode,
              title: const Text("Light"),
              onChanged: (mode) {
                if (mode != null) _setThemeMode(mode);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: _themeMode,
              title: const Text("Dark"),
              onChanged: (mode) {
                if (mode != null) _setThemeMode(mode);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice Uploader App',
      locale: _locale,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFFF5F7FB)),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF222B45),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF1A2138)),
        cardTheme: CardThemeData(
          color: const Color(0xFF232946),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(S.of(context)!.appTitle),
            actions: [
              IconButton(
                icon: Icon(
                  _themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : _themeMode == ThemeMode.light
                      ? Icons.light_mode
                      : Icons.brightness_auto,
                ),
                tooltip: "Switch Theme",
                onPressed: () => _showThemeDialog(context),
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text(S.of(context)!.settings),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                            themeMode: _themeMode,
                            onThemeChanged: (mode) => _setThemeMode(mode),
                            onLocaleChanged: (locale) => _setLocale(locale),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _user == null
                    ? DrawerHeader(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.blueAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_circle,
                              size: 64,
                              color: Colors.white70,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              S.of(context)!.welcomeHeader,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : UserAccountsDrawerHeader(
                        accountName: Text(_user!.displayName ?? ""),
                        accountEmail: Text(_user!.email),
                        currentAccountPicture: _user!.photoUrl != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(_user!.photoUrl!),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.grey[400],
                                child: Text(
                                  (_user!.displayName
                                          ?.substring(0, 1)
                                          .toUpperCase() ??
                                      "?"),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                if (_user != null) ...[
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.upload_file),
                      title: Text(S.of(context)!.receiptUpload),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReceiptUploadScreen(user: _user!),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.upload),
                      title: Text(S.of(context)!.bulkUpload),
                      onTap: () async {
                        Navigator.pop(context);
                        // Ask user to pick a category first
                        final helper = sheets.GoogleSheetsHelper(_user!);
                        final spreadsheetId = await helper
                            .getOrCreateMainSpreadsheet();
                        final categories = await helper.getCategories(
                          spreadsheetId,
                        );
                        String? selectedCategory;
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(S.of(context)!.selectCategory),
                            content: DropdownButton<String>(
                              value: selectedCategory,
                              hint: Text(S.of(context)!.selectCategory),
                              items: categories
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                selectedCategory = val;
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                        if (selectedCategory != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BulkUploadScreen(
                                category: selectedCategory!,
                                onUpload: (entries) async {
                                  // Implement your upload logic here
                                  // For each entry: entry.file, entry.date, entry.amount, widget.category
                                  // Autogenerate filename if needed
                                  // Use your GoogleSheetsHelper to upload
                                },
                                user: _user!,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.table_chart),
                      title: Text(S.of(context)!.spreadsheet),
                      onTap: () async {
                        Navigator.pop(context);
                        final prefs = await SharedPreferences.getInstance();
                        if (!mounted) return;
                        final lastCategory = prefs.getString(
                          "lastUsedCategory",
                        );
                        if (lastCategory == null) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(S.of(context)!.noCategory)),
                          );
                          return;
                        }
                        try {
                          final helper = sheets.GoogleSheetsHelper(_user!);
                          final sheetId = await helper
                              .getOrCreateMainSpreadsheet();
                          if (!mounted) return;
                          await helper.ensureCategorySheetExists(
                            sheetId,
                            lastCategory,
                          );
                          if (!mounted) return;
                          await prefs.setString(
                            "sheetId_$lastCategory",
                            sheetId,
                          );
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpreadsheetListScreen(
                                spreadsheetId: sheetId,
                                category: lastCategory,
                                user: _user!,
                              ),
                            ),
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${S.of(context)!.spreadsheetOpenFail(e)}: $e",
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.pie_chart),
                      title: Text(
                        S.of(context)!.viewExpenses,
                      ), // Add "viewExpenses" to your ARB files
                      onTap: () async {
                        Navigator.pop(context);
                        final helper = sheets.GoogleSheetsHelper(_user!);
                        final spreadsheetId = await helper
                            .getOrCreateMainSpreadsheet();
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpenseOverviewScreen(
                              spreadsheetId: spreadsheetId,
                              user: _user!,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                if (_user == null)
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.login),
                      title: Text(S.of(context)!.signInButton),
                      onTap: () async {
                        Navigator.pop(context);
                        await _handleSignIn(context);
                      },
                    ),
                  ),
                if (_user != null)
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.logout),
                      title: Text(S.of(context)!.signOutButton),
                      onTap: () async {
                        Navigator.pop(context);
                        await _handleSignOut(context);
                      },
                    ),
                  ),
              ],
            ),
          ),
          body: Center(
            child: Card(
              margin: const EdgeInsets.all(24),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _user != null
                          ? Icons.verified_user
                          : Icons.account_circle,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _user != null
                          ? S
                                .of(context)!
                                .welcomeUser(_user!.displayName ?? _user!.email)
                          : S.of(context)!.pleaseSignIn,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
