showDialog(
  context = context,
  builder = (_) => AlertDialog(
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
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("❌ Could not launch URL")),
              );
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
