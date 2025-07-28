import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleDriveSignIn {
  // Singleton instance
  static final GoogleDriveSignIn _instance = GoogleDriveSignIn._internal();

  // Private constructor
  GoogleDriveSignIn._internal();

  // Factory constructor returns the singleton
  factory GoogleDriveSignIn() => _instance;

  // Sign-In configuration
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/spreadsheets',
    ],
  );

  // Returns the current signed-in account (if any)
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  // Silent sign-in (used at app startup)
  Future<GoogleSignInAccount?> trySilentSignIn() async {
    try {
      final account = await _googleSignIn.signInSilently();
      return account;
    } catch (e) {
      debugPrint("Silent sign-in failed: $e");
      return null;
    }
  }

  // Prompts user to sign in and handles caching
  Future<GoogleSignInAccount?> signIn(BuildContext context) async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        debugPrint(S.of(context)!.signInCancelled);
        return null;
      }

      final prefs = await SharedPreferences.getInstance();
      final previousEmail = prefs.getString('lastSignedInEmail');
      final currentEmail = account.email;

      // Clear cached spreadsheet ID if user switched accounts
      if (previousEmail != null && previousEmail != currentEmail) {
        await prefs.remove('spreadsheetId');
        debugPrint("Switched Google account. Cleared cached spreadsheetId.");
      }

      // Save current email
      await prefs.setString('lastSignedInEmail', currentEmail);

      debugPrint(S.of(context)!.signedInMessage(currentEmail));
      return account;
    } catch (error) {
      debugPrint(S.of(context)!.signInError(error.toString()));
      return null;
    }
  }

  // Signs the user out
  Future<void> signOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      debugPrint(S.of(context)!.signedOut);
    } catch (e) {
      debugPrint("Error during sign out: $e");
    }
  }

  // Returns true if a user is signed in
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }
}
