import 'package:flutter/material.dart';

class SettingsCategory {
  const SettingsCategory({
    required this.id,
    required this.title,
    this.color = Colors.deepPurple,
  });
  final String id;
  final String title;
  final Color color;



}
