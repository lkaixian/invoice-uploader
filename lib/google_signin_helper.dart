import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleDriveSignIn {
  static final GoogleDriveSignIn _instance = GoogleDriveSignIn._internal();
  factory GoogleDriveSignIn() => _instance;

  GoogleDriveSignIn._internal();

  late final GoogleSignIn _googleSignIn;

  // Async initialization method — call this before using anything
  Future<void> init() async {
    final String clientId = kIsWeb
        ? const String.fromEnvironment('GOOGLE_CLIENT_ID')
        : dotenv.env['GOOGLE_CLIENT_ID']!;

    _googleSignIn = GoogleSignIn(
      clientId: clientId,
      scopes: [
        'https://www.googleapis.com/auth/drive.file',
        'https://www.googleapis.com/auth/spreadsheets',
      ],
    );
  }

  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  Future<GoogleSignInAccount?> trySilentSignIn() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (e) {
      debugPrint("Silent sign-in failed: $e");
      return null;
    }
  }

  Future<GoogleSignInAccount?> signIn(BuildContext context) async {
    final S localizations = S.of(context)!;

    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        debugPrint(localizations.signInCancelled);
        return null;
      }

      final prefs = await SharedPreferences.getInstance();
      final previousEmail = prefs.getString('lastSignedInEmail');
      final currentEmail = account.email;

      if (previousEmail != null && previousEmail != currentEmail) {
        await prefs.remove('spreadsheetId');
        debugPrint("Switched Google account. Cleared cached spreadsheetId.");
      }

      await prefs.setString('lastSignedInEmail', currentEmail);
      debugPrint(localizations.signedInMessage(currentEmail));
      return account;
    } catch (error) {
      debugPrint(localizations.signInError(error.toString()));
      return null;
    }
  }

  Future<void> signOut(BuildContext context) async {
    final S localizations = S.of(context)!;
    try {
      await _googleSignIn.signOut();
      debugPrint(localizations.signedOut);
    } catch (e) {
      debugPrint("Error during sign out: $e");
    }
  }

  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }
}
