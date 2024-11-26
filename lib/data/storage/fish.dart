import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fish {
  final String name;
  final String weight;
  final String length;
  final String waterType;
  final String imagePath;
  final String location;
  final DateTime date;

  Fish({
    required this.name,
    required this.weight,
    required this.length,
    required this.waterType,
    required this.imagePath,
    required this.date,
    required this.location,
  });
  Map<String, dynamic> toJson() => {
        'name': name,
        'weight': weight,
        'length': length,
        'waterType': waterType,
        'imagePath': imagePath,
        'location': location,
        'date': date.toIso8601String(),
      };

  factory Fish.fromJson(Map<String, dynamic> json) => Fish(
        name: json['name'],
        weight: json['weight'],
        length: json['length'],
        waterType: json['waterType'],
        imagePath: json['imagePath'],
        location: json['location'],
        date: json['date'] != null
            ? DateTime.parse(json['date'] as String)
            : DateTime.now(),
      );
}

class FishStorage {
  static const String _key = 'fish_list';

  static Future<void> addFish(Fish fish) async {
    final prefs = await SharedPreferences.getInstance();
    final fishList = await getFishList();
    fishList.add(fish);
    await prefs.setString(
        _key, jsonEncode(fishList.map((f) => f.toJson()).toList()));
  }

  static Future<void> deleteFish(Fish fish) async {
    final prefs = await SharedPreferences.getInstance();
    final fishList = await getFishList();
    fishList.removeWhere(
      (f) =>
          f.name == fish.name &&
          f.date == fish.date &&
          f.location == fish.location,
    );
    await prefs.setString(
        _key, jsonEncode(fishList.map((f) => f.toJson()).toList()));
  }

  static Future<List<Fish>> getFishList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? fishListJson = prefs.getString(_key);
    if (fishListJson == null) return [];
    final List<dynamic> decodedList = jsonDecode(fishListJson);
    return decodedList.map((json) => Fish.fromJson(json)).toList();
  }
}

Widget fishBlock(BuildContext context, Fish fish) {
  return Container(
    height: 500,
    width: 400,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          fish.imagePath,
          height: 60,
          width: 120,
        ),
        Text(
          fish.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Weight: ${fish.weight}',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        Text(
          'Length: ${fish.length}',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13,
          ),
        ),
        Text(
          'Water type: ${fish.waterType}',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}
