import 'package:google_sign_in/google_sign_in.dart';

class GoogleDriveSignIn {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['https://www.googleapis.com/auth/drive.file','https://www.googleapis.com/auth/spreadsheets'],
  );

  Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        print("✅ Signed in as ${account.email}");
        return account;
      } else {
        print("❌ Sign-in cancelled");
        return null;
      }
    } catch (error) {
      print("Error signing in: $error");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    print("🔒 Signed out.");
  }

  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
}
