import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SupportReport extends StatefulWidget {
  const SupportReport({super.key});

  @override
  State<SupportReport> createState() => _SupportReportState();
}

class _SupportReportState extends State<SupportReport> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitReport() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your report has been successfully sent'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4052EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CupertinoButton(
          child: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Write Support',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  label: 'Name',
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Message',
                  controller: _messageController,
                  maxLines: 5,
                  minLines: 5,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    onPressed: () {
                      if (_nameController.text.isEmpty ||
                          _emailController.text.isEmpty ||
                          _messageController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      _submitReport();
                    },
                    child: const Text(
                      'Send',
                      style: TextStyle(
                        color: Color(0xFF4052EE),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int? maxLines,
    int? minLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          maxLines: maxLines,
          minLines: minLines,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          placeholder: 'Enter $label',
          placeholderStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ],
    );
  }
}
