import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class cawfee extends StatelessWidget {
  final String url;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const cawfee({
    super.key,
    required this.url,
    this.label = 'Cawfee',
    this.backgroundColor = Colors.orange,
    this.textColor = Colors.white,
  });

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _launchURL,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      icon: const Icon(Icons.local_cafe),
      label: Text(label),
    );
  }
}
