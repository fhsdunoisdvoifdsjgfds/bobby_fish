import 'package:fish/data/storage/fish.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FishDetailsScreen extends StatelessWidget {
  final Fish fish;

  const FishDetailsScreen({super.key, required this.fish});

  Future<void> _launchLocation(String locationUrl) async {
    final Uri uri = Uri.parse(locationUrl);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $locationUrl');
    }
  }

  Future<void> _deleteFish(BuildContext context) async {
    await FishStorage.deleteFish(fish);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fish was deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4052EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          fish.name,
          style: const TextStyle(color: Colors.white),
        ),
        leading: CupertinoButton(
          child: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.asset(
                  fish.imagePath,
                  height: 150,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Date', _formatDate(fish.date)),
            _buildDetailRow('Weight', fish.weight),
            _buildDetailRow('Length', fish.length),
            _buildDetailRow('Water type', fish.waterType),
            _buildDetailRow('Color', 'grey'),
            const SizedBox(height: 24),
            CupertinoButton(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              onPressed: () => _launchLocation(fish.location),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(CupertinoIcons.map, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'View on map',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                      color: Colors.red.withOpacity(0.3),
                      child: const Text('Delete'),
                      onPressed: () {
                        _deleteFish(context);
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
