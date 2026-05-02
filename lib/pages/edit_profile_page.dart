import 'package:day35/theme/app_theme.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String initialService;
  final String initialImageUrl;

  const EditProfilePage({
    super.key,
    required this.initialName,
    required this.initialService,
    required this.initialImageUrl,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _serviceController;
  late TextEditingController _bioController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _serviceController = TextEditingController(text: widget.initialService);
    _bioController = TextEditingController(text: "Professional plumber with 5 years of experience in Tunis.");
    _priceController = TextEditingController(text: "50");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serviceController.dispose();
    _bioController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // In a real app, this would update a database/state
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeController.instance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            onPressed: theme.toggle,
            icon: Icon(theme.isDarkMode ? Icons.dark_mode : Icons.light_mode),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(widget.initialImageUrl),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildTextField('Full Name', _nameController, Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField('Service Category', _serviceController, Icons.work_outline),
            const SizedBox(height: 16),
            _buildTextField('Base Price (TND)', _priceController, Icons.monetization_on_outlined, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField('Bio', _bioController, Icons.description_outlined, maxLines: 3),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
    );
  }
}
