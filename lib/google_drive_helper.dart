import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class GoogleDriveUploader {
  final GoogleSignInAccount account;

  GoogleDriveUploader(this.account);

  Future<String?> _getAuthToken() async {
    final auth = await account.authentication;
    return auth.accessToken;
  }

  Future<String?> _getOrCreateFolder(String folderName) async {
    final token = await _getAuthToken();
    final query =
        "mimeType='application/vnd.google-apps.folder' and name='$folderName' and trashed=false";

    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/drive/v3/files?q=${Uri.encodeComponent(query)}'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final body = jsonDecode(response.body);
    final files = body['files'];
    if (files != null && files.isNotEmpty) {
      return files[0]['id']; // Folder already exists
    }

    // Otherwise, create the folder
    final createRes = await http.post(
      Uri.parse('https://www.googleapis.com/drive/v3/files'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': folderName,
        'mimeType': 'application/vnd.google-apps.folder',
      }),
    );

    final folderData = jsonDecode(createRes.body);
    return folderData['id'];
  }

  Future<bool> uploadFile({
    required File file,
    required String fileName,
    required String folderName,
  }) async {
    final token = await _getAuthToken();
    final folderId = await _getOrCreateFolder(folderName);
    if (folderId == null) return false;

    final uri = Uri.parse("https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart");

    final mimeType = _getMimeType(file.path);
    final fileBytes = await file.readAsBytes();

    final metadata = {
      'name': fileName,
      'parents': [folderId],
    };

    final boundary = '----flutter_upload_boundary';
    final body = <int>[];

    // Part 1: Metadata (JSON)
    body.addAll(utf8.encode('--$boundary\r\n'));
    body.addAll(utf8.encode('Content-Type: application/json; charset=UTF-8\r\n\r\n'));
    body.addAll(utf8.encode(jsonEncode(metadata)));
    body.addAll(utf8.encode('\r\n'));

    // Part 2: Binary File Data
    body.addAll(utf8.encode('--$boundary\r\n'));
    body.addAll(utf8.encode('Content-Type: $mimeType\r\n\r\n'));
    body.addAll(fileBytes);
    body.addAll(utf8.encode('\r\n--$boundary--\r\n'));

    final uploadRes = await http.post(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        "Content-Type": "multipart/related; boundary=$boundary",
      },
      body: Uint8List.fromList(body),
    );

    if (uploadRes.statusCode == 200) {
      print("✅ Upload success!");
      return true;
    } else {
      print("❌ Upload failed: ${uploadRes.statusCode} ${uploadRes.body}");
      return false;
    }
  }

  String _getMimeType(String path) {
    if (path.endsWith('.jpg') || path.endsWith('.jpeg')) {
      return 'image/jpeg';
    } else if (path.endsWith('.png')) {
      return 'image/png';
    }
    return 'application/octet-stream';
  }
}
// This file is part of the Invoice Scanner project.
// It provides functionality to upload files to Google Drive using the Google Drive API.  