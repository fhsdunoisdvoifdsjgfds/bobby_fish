import 'package:fish/data/storage/fish.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddFishScreen extends StatefulWidget {
  const AddFishScreen({super.key});

  @override
  State<AddFishScreen> createState() => _AddFishScreenState();
}

class _AddFishScreenState extends State<AddFishScreen> {
  String? selectedFishType;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _waterTypeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final List<Map<String, String>> fishTypes = [
    {'name': 'River perch', 'image': 'assets/images/fish1.png'},
    {'name': 'Pike', 'image': 'assets/images/fish2.png'},
    {'name': 'Bream', 'image': 'assets/images/fish3.png'},
    {'name': 'Pikepearch', 'image': 'assets/images/fish4.png'},
    {'name': 'Cod', 'image': 'assets/images/fish5.png'},
    {'name': 'Trout', 'image': 'assets/images/fish6.png'},
    {'name': 'Carp', 'image': 'assets/images/fish7.png'},
    {'name': 'Catfish', 'image': 'assets/images/fish8.png'},
    {'name': 'Mackerel', 'image': 'assets/images/fish9.png'},
  ];
  String _selectedWeight = '0';
  String _selectedWeightUnit = 'kg';
  String _selectedLength = '0';
  String _selectedLengthUnit = 'cm';

  @override
  void dispose() {
    _locationController.dispose();
    _nameController.dispose();
    _waterTypeController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _saveFish() async {
    if (selectedFishType == null) {
      _showError('Please select fish type');
      return;
    }

    final fish = Fish(
      name: _nameController.text,
      weight: '$_selectedWeight $_selectedWeightUnit',
      length: '$_selectedLength $_selectedLengthUnit',
      waterType: _waterTypeController.text,
      imagePath:
          fishTypes.firstWhere((f) => f['name'] == selectedFishType)['image']!,
      location: _locationController.text,
      date: DateTime.now(),
    );

    await FishStorage.addFish(fish);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${fish.name} has been added successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4052EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Add fish',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField('Name', 'Name title', controller: _nameController),
            const SizedBox(height: 16),
            _buildTextField('Water type', 'Enter water type',
                controller: _waterTypeController),
            const SizedBox(height: 16),
            _buildMeasurementPicker(
              'Weight',
              _selectedWeight,
              _selectedWeightUnit,
              ['kg', 'g', 'lb'],
              (value) => setState(() => _selectedWeight = value),
              (unit) => setState(() => _selectedWeightUnit = unit),
            ),
            const SizedBox(height: 16),
            _buildMeasurementPicker(
              'Length',
              _selectedLength,
              _selectedLengthUnit,
              ['cm', 'mm', 'in'],
              (value) => setState(() => _selectedLength = value),
              (unit) => setState(() => _selectedLengthUnit = unit),
            ),
            const SizedBox(height: 16),
            _buildTextField('Color', 'Red'),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: _locationController,
                  placeholder: 'Paste Google Maps location link',
                  style: const TextStyle(color: Colors.white),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  placeholderStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: fishTypes.length,
              itemBuilder: (context, index) {
                final fishType = fishTypes[index];
                final isSelected = selectedFishType == fishType['name'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFishType = fishType['name'];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            fishType['image']!,
                            height: 50,
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 20,
                                color: Color(0xFF4052EE),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveFish,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add Fish',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF4052EE),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder,
      {TextInputType? keyboardType, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
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

  Widget _buildMeasurementPicker(
      String label,
      String value,
      String unit,
      List<String> units,
      Function(String) onValueChanged,
      Function(String) onUnitChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CupertinoTextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                placeholder: '0',
                controller: TextEditingController(text: value),
                onChanged: onValueChanged,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                color: Colors.white.withOpacity(0.1),
                child: Text(
                  unit,
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => Container(
                      height: 200,
                      color:
                          CupertinoColors.systemBackground.resolveFrom(context),
                      child: CupertinoPicker(
                        itemExtent: 32,
                        onSelectedItemChanged: (index) {
                          onUnitChanged(units[index]);
                        },
                        children:
                            units.map((u) => Center(child: Text(u))).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
