import 'package:experiences_project/pallete.dart';
import 'package:flutter/material.dart';

class DiaryWritingField extends StatefulWidget {
  const DiaryWritingField({super.key});

  @override
  State<DiaryWritingField> createState() => _DiaryWritingFieldState();
}

class _DiaryWritingFieldState extends State<DiaryWritingField> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ink your experiences'),
        backgroundColor: Pallete.appBar,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'Enter title here...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        debugPrint('Save button pressed');
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: 'Write your notes here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}