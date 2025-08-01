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
import 'category_service.dart';
import 'sheet_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures binding is ready
  await SheetConfig().init(); // Load sheet config
  runApp(const MyApp());
}

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

  Widget _buildDrawerCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        child: ListTile(leading: Icon(icon), title: Text(label), onTap: onTap),
      ),
    );
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
    final account = await googleDriveSignIn.trySilentSignIn();
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
    final localizations = S.of(context)!;
    final account = await googleDriveSignIn.signIn(context);
    if (!mounted) return;

    if (account != null) {
      setState(() => _user = account);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.signedInMessage(account.email))),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(localizations.signInCancelled)));
    }
  }

  Future<void> _handleSignOut(BuildContext context) async {
    final localizations = S.of(context)!;

    await googleDriveSignIn.signOut(context);
    if (!mounted) return;
    setState(() => _user = null);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(localizations.signedOut)));
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.appTitle + S.of(context)!.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: _themeMode,
              title: Text(S.of(context)!.themeSystem),
              onChanged: (mode) {
                if (mode != null) _setThemeMode(mode);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: _themeMode,
              title: Text(S.of(context)!.themeLight),
              onChanged: (mode) {
                if (mode != null) _setThemeMode(mode);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: _themeMode,
              title: Text(S.of(context)!.themeDark),
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
      title: "Invoice Uploader",
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
                tooltip: S.of(context)!.switchTheme,
                onPressed: () => _showThemeDialog(context),
              ),
            ],
          ),
          drawer: Drawer(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // --- Header Section ---
                    _user == null
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue, Colors.blueAccent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
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
                                    backgroundImage: NetworkImage(
                                      _user!.photoUrl!,
                                    ),
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

                    // --- Settings ---
                    _buildDrawerCard(
                      icon: Icons.settings,
                      label: S.of(context)!.settings,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(
                              themeMode: _themeMode,
                              onThemeChanged: _setThemeMode,
                              onLocaleChanged: _setLocale,
                            ),
                          ),
                        );
                      },
                    ),

                    // --- Auth and Feature Cards ---
                    if (_user != null) ...[
                      _buildDrawerCard(
                        icon: Icons.upload_file,
                        label: S.of(context)!.receiptUpload,
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
                      _buildDrawerCard(
                        icon: Icons.upload,
                        label: S.of(context)!.bulkUpload,
                        onTap: () async {
                          Navigator.pop(context);
                          final categories =
                              await CategoryService.loadCategories();
                          String? selectedCategory = categories.isNotEmpty
                              ? categories.first
                              : null;

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
                                  onUpload: (entries) async {},
                                  user: _user!,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      _buildDrawerCard(
                        icon: Icons.table_chart,
                        label: S.of(context)!.spreadsheet,
                        onTap: () async {
                          final localizations = S.of(context)!;
                          Navigator.pop(context);
                          final prefs = await SharedPreferences.getInstance();
                          final lastCategory = prefs.getString(
                            "lastUsedCategory",
                          );

                          if (lastCategory == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(localizations.noCategory)),
                            );
                            return;
                          }

                          try {
                            final helper = sheets.GoogleSheetsHelper(_user!);
                            final sheetId = await helper
                                .getOrCreateMainSpreadsheet();
                            await helper.ensureCategorySheetExists(
                              sheetId,
                              lastCategory,
                            );
                            await prefs.setString(
                              "sheetId_$lastCategory",
                              sheetId,
                            );

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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${localizations.spreadsheetOpenFail(e)}: $e",
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      _buildDrawerCard(
                        icon: Icons.pie_chart,
                        label: S.of(context)!.viewExpenses,
                        onTap: () async {
                          Navigator.pop(context);
                          final helper = sheets.GoogleSheetsHelper(_user!);
                          final spreadsheetId = await helper
                              .getOrCreateMainSpreadsheet();
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
                    ],

                    if (_user == null)
                      _buildDrawerCard(
                        icon: Icons.login,
                        label: S.of(context)!.signInButton,
                        onTap: () async {
                          Navigator.pop(context);
                          await _handleSignIn(context);
                        },
                      ),

                    if (_user != null)
                      _buildDrawerCard(
                        icon: Icons.logout,
                        label: S.of(context)!.signOutButton,
                        onTap: () async {
                          Navigator.pop(context);
                          await _handleSignOut(context);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Center(
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
                                  .welcomeUser(
                                    _user!.displayName ?? _user!.email,
                                  )
                            : S.of(context)!.pleaseSignIn,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_user == null) const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: Icon(_user == null ? Icons.login : Icons.logout),
                        onPressed: () => _user == null
                            ? _handleSignIn(context)
                            : _handleSignOut(context),
                        label: Text(
                          _user == null
                              ? S.of(context)!.signInButton
                              : S.of(context)!.signOutButton,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
