import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:invoice_scanner/l10n/app_localizations.dart';

class GoogleDriveSignIn {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/spreadsheets'
    ],
  );

  Future<GoogleSignInAccount?> signIn(BuildContext context) async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        print(S.of(context)!.signedInMessage(account.email));
        return account;
      } else {
        print(S.of(context)!.signInCancelled);
        return null;
      }
    } catch (error) {
      print(S.of(context)!.signInError(error.toString()));
      return null;
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _googleSignIn.signOut();
    print(S.of(context)!.signedOut);
  }

  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
}
