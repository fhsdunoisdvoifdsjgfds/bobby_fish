import 'package:fish/data/storage/fish.dart';
import 'package:fish/preview/screens/add_fish/details/fish_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  RangeValues _weightRange = const RangeValues(0, 100);
  RangeValues _lengthRange = const RangeValues(0, 200);
  bool _isFilterVisible = false;

  List<Fish> _filterFish(List<Fish> fishes) {
    return fishes.where((fish) {
      final nameMatch =
          fish.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final weight = double.tryParse(fish.weight.split(' ')[0]) ?? 0;
      final length = double.tryParse(fish.length.split(' ')[0]) ?? 0;

      return nameMatch &&
          weight >= _weightRange.start &&
          weight <= _weightRange.end &&
          length >= _lengthRange.start &&
          length <= _lengthRange.end;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Fishing catch',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoSearchTextField(
                backgroundColor: Colors.white.withOpacity(0.1),
                style: const TextStyle(color: Colors.white),
                placeholderStyle: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Icon(CupertinoIcons.slider_horizontal_3,
                        color: Colors.white),
                    const Spacer(),
                    Text('Filters', style: TextStyle(color: Colors.white)),
                    const Spacer(),
                    Icon(
                      _isFilterVisible
                          ? CupertinoIcons.chevron_up
                          : CupertinoIcons.chevron_down,
                      color: Colors.white,
                    ),
                  ],
                ),
                onPressed: () =>
                    setState(() => _isFilterVisible = !_isFilterVisible),
              ),
            ),
            if (_isFilterVisible) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Weight Range (kg)',
                        style: TextStyle(color: Colors.white)),
                    RangeSlider(
                      values: _weightRange,
                      min: 0,
                      max: 100,
                      activeColor: const Color.fromARGB(255, 191, 190, 190),
                      inactiveColor: const Color.fromARGB(145, 35, 87, 130),
                      divisions: 100,
                      labels: RangeLabels(
                        _weightRange.start.round().toString(),
                        _weightRange.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() => _weightRange = values);
                      },
                    ),
                    const Text('Length Range (cm)',
                        style: TextStyle(color: Colors.white)),
                    RangeSlider(
                      values: _lengthRange,
                      min: 0,
                      max: 200,
                      activeColor: const Color.fromARGB(255, 191, 190, 190),
                      inactiveColor: const Color.fromARGB(145, 35, 87, 130),
                      divisions: 200,
                      labels: RangeLabels(
                        _lengthRange.start.round().toString(),
                        _lengthRange.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() => _lengthRange = values);
                      },
                    ),
                  ],
                ),
              ),
            ],
            Expanded(
              child: FutureBuilder<List<Fish>>(
                future: FishStorage.getFishList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final allFish = snapshot.data ?? [];
                  final filteredFish = _filterFish(allFish);

                  if (filteredFish.isEmpty) {
                    return const Center(
                      child: Text('No fish found',
                          style: TextStyle(color: Colors.white)),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredFish.length,
                    itemBuilder: (context, index) {
                      final fish = filteredFish[index];
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => FishDetailsScreen(fish: fish),
                          ),
                        ),
                        child: fishBlock(context, fish),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
