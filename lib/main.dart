import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'google_signin_helper.dart';
import 'package:invoice_scanner/google_sheets_helper.dart' as sheets;
import 'receipt_upload.dart';
import 'spreadsheet_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'spreadsheet_list_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GoogleDriveSignIn googleDriveSignIn = GoogleDriveSignIn();
  GoogleSignInAccount? _user;
  Locale? _locale;

  void _setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('localeCode', locale.languageCode);
    setState(() => _locale = locale);
  }

  @override
  void initState() {
    super.initState();
    _checkSignIn();
    _loadLocale();
  }

  Future<void> _checkSignIn() async {
    final signedIn = await googleDriveSignIn.isSignedIn();
    if (!mounted) return;
    if (signedIn) {
      setState(() {
        _user = googleDriveSignIn.currentUser;
      });
    }
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('localeCode');
    if (code != null) {
      setState(() => _locale = Locale(code));
    }
  }

  Future<void> _handleSignIn(BuildContext context) async {
    final account = await googleDriveSignIn.signIn(context);
    if (!mounted) return;
    if (account != null) {
      setState(() => _user = account);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context)!.signedInMessage(account.email))),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context)!.signInCancelled)));
    }
  }

  Future<void> _handleSignOut(BuildContext context) async {
    await googleDriveSignIn.signOut(context);
    if (!mounted) return;
    setState(() => _user = null);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(S.of(context)!.signedOut)));
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Language"),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice Uploader App',
      locale: _locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(S.of(context)!.appTitle)),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text("Language"),
                  subtitle: Text(
                    S.of(context)!.appTitle,
                  ), // Optional: show current
                  onTap: () => _showLanguageDialog(context),
                ),
                _user == null
                    ? DrawerHeader(
                        decoration: BoxDecoration(color: Colors.blue),
                        child: Text(
                          S.of(context)!.welcomeHeader,
                          style: TextStyle(fontSize: 24, color: Colors.white),
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
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                if (_user != null) ...[
                  ListTile(
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
                  ListTile(
                    leading: const Icon(Icons.table_chart),
                    title: Text(S.of(context)!.spreadsheet),
                    onTap: () async {
                      Navigator.pop(context);
                      final prefs = await SharedPreferences.getInstance();
                      final lastCategory = prefs.getString("lastUsedCategory");
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
                        await helper.ensureCategorySheetExists(
                          sheetId,
                          lastCategory,
                        );
                        await prefs.setString("sheetId_$lastCategory", sheetId);
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
                ],
                if (_user == null)
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: Text(S.of(context)!.signInButton),
                    onTap: () async {
                      Navigator.pop(context);
                      await _handleSignIn(context);
                    },
                  ),
                if (_user != null)
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(S.of(context)!.signOutButton),
                    onTap: () async {
                      Navigator.pop(context);
                      await _handleSignOut(context);
                    },
                  ),
              ],
            ),
          ),
          body: Center(
            child: Text(
              _user != null
                  ? S
                        .of(context)!
                        .welcomeUser(_user!.displayName ?? _user!.email)
                  : S.of(context)!.pleaseSignIn,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
