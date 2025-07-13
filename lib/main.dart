import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'google_signin_helper.dart';
import 'package:invoice_scanner/google_sheets_helper.dart' as sheets;
import 'receipt_upload.dart';
import 'spreadsheet_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'spreadsheet_list_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GoogleDriveSignIn googleDriveSignIn = GoogleDriveSignIn();
  GoogleSignInAccount? _user;

  @override
  void initState() {
    super.initState();
    _checkSignIn();
  }

  Future<void> _checkSignIn() async {
    final signedIn = await googleDriveSignIn.isSignedIn();
    if (signedIn) {
      setState(() {
        _user = googleDriveSignIn.currentUser;
      });
    }
  }

  Future<void> _handleSignIn(BuildContext context) async {
    final account = await googleDriveSignIn.signIn();
    if (account != null) {
      setState(() => _user = account);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Signed in as ${account.email}")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ Sign-in cancelled")));
    }
  }

  Future<void> _handleSignOut(BuildContext context) async {
    await googleDriveSignIn.signOut();
    setState(() => _user = null);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("🔒 Signed out")));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice OCR App',
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("Invoice OCR App")),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _user == null
                    ? const DrawerHeader(
                        decoration: BoxDecoration(color: Colors.blue),
                        child: Text(
                          "Welcome!",
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

                // 📤 Receipt Upload Option
                if (_user != null) ...[
                  ListTile(
                    leading: const Icon(Icons.upload_file),
                    title: const Text("Receipt Upload"),
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReceiptUploadScreen(user: _user!),
                        ),
                      );
                    },
                  ),

                  // 📊 Spreadsheet Viewer
                  ListTile(
                    leading: const Icon(Icons.table_chart),
                    title: const Text("Spreadsheet"),
                    onTap: () async {
                      Navigator.pop(context);

                      final prefs = await SharedPreferences.getInstance();
                      final lastCategory = prefs.getString("lastUsedCategory");

                      if (lastCategory == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "⚠️ No category chosen yet. Please upload at least one receipt first.",
                            ),
                          ),
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
                            content: Text("❌ Failed to open spreadsheet: $e"),
                          ),
                        );
                      }
                    },
                  ),
                ],

                // 🔑 Sign In / Out
                if (_user == null)
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text("Sign In"),
                    onTap: () async {
                      Navigator.pop(context);
                      await _handleSignIn(context);
                    },
                  ),
                if (_user != null)
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Sign Out"),
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
                  ? "Welcome, ${_user!.displayName ?? _user!.email}"
                  : "Please sign in to begin.",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
