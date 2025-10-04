import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';


void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL Checker App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// -------------------------
// 1. HOME PAGE
// -------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/photo_2025-04-18_19-11-52.jpg',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Detect if a URL is malicious or safe.\nYou can either scan a QR code or enter the link manually.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF326BB8),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Scan QR Code',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UrlCheckerPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF326BB8),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Enter URL Manually',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------
// 2. MANUAL URL CHECKER PAGE
// ---------------------------
class UrlCheckerPage extends StatefulWidget {
  const UrlCheckerPage({super.key});

  @override
  State<UrlCheckerPage> createState() => _UrlCheckerPageState();
}

class _UrlCheckerPageState extends State<UrlCheckerPage> {
  final TextEditingController _urlController = TextEditingController();

  void showLoadingDialog(String url) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Checking URL'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(url, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            const Text('Checking link with backend...'),
          ],
        ),
      ),
    );
  }

  Future<void> checkUrlWithBackend(String url) async {
    final backendUrl = Uri.parse('http://10.80.8.96:5000/check');

    try {
      final response = await http.post(
        backendUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': url}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final isMalicious = data['malicious'] == 1;

        Navigator.pop(context); // Close loading

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Scan Result'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(url, textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text(
                  isMalicious
                      ? '⚠️ This link is MALICIOUS!'
                      : '✅ This link is SAFE.',
                  style: TextStyle(
                    color: isMalicious ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              if (!isMalicious)
                TextButton.icon(
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text("Open Link"),
                  onPressed: () async {
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              TextButton(
                child: const Text("Check Another"),
                onPressed: () {
                  Navigator.pop(context);
                  _urlController.clear();
                },
              ),
              TextButton(
                child: const Text("Close"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      } else {
        throw Exception("Backend returned error");
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Failed to contact backend.")),
      );
    }
  }

  void handleSubmit() {
    final url = _urlController.text.trim();
    final uri = Uri.tryParse(url);

    if (uri != null && (uri.isScheme("http") || uri.isScheme("https"))) {
      showLoadingDialog(url);
      checkUrlWithBackend(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ Invalid URL format")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('URL Checker')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter URL',
                hintText: 'https://example.com',
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: handleSubmit,
              icon: const Icon(Icons.search),
              label: const Text('Check URL'),
            ),
          ],
        ),
      ),
    );
  }
}

