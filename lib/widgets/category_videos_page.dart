import 'package:flutter/material.dart';
import 'package:experiences_project/pallete.dart';
import 'exp_display_field.dart';

class CategoryVideosPage extends StatelessWidget {
  final String category;

  const CategoryVideosPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category == 'All' ? 'All Categories' : category),
        backgroundColor: Pallete.backgroundColorLoginPg,
      ),
      body: Container(
        color: Pallete.backgroundColorLoginPg,
        child: ExpDisplayField(category: category),
      ),
    );
  }
}