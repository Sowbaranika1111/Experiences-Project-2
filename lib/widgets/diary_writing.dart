import 'package:experiences_project/configs.dart';
import 'package:experiences_project/pallete.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DiaryWritingField extends StatefulWidget {
  const DiaryWritingField({super.key});

  @override
  State<DiaryWritingField> createState() => _DiaryWritingFieldState();
}

class _DiaryWritingFieldState extends State<DiaryWritingField> {
  late SharedPreferences prefs;
  String email = '';
  bool isLoading = true;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await _loadUserData();
  }

  Future<void> _loadUserData() async {
    final token = prefs.getString('tokenValue');
    debugPrint('Token: $token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse(getUserDetails),
          headers: {'Authorization': 'Bearer $token'},
        );

        debugPrint('Response status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          debugPrint('Decoded Response body: $data');

          setState(() {
            email = data['user']['email'];
            isLoading = false;
          });
          debugPrint('Email: $email');
        } else {
          debugPrint('Failed to load user data');
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        debugPrint('Error: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      debugPrint('No token found');
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<void> _addDiary() async {
    if (email.isEmpty ||
        _titleController.text.isEmpty ||
        _noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      var diaryBody = {
        "email": email,
        "title": _titleController.text,
        "desc": _noteController.text
      };

      var diaryResponse = await http.post(
        Uri.parse(addDiary),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(diaryBody),
      );

      if (diaryResponse.statusCode == 200) {
        debugPrint('Response body: ${diaryResponse.body}');
        debugPrint('Diary added successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Diary entry saved successfully')),
        );
        // Clear the text fields after successful save
        _titleController.clear();
        _noteController.clear();
      } else {
        debugPrint(
            'Failed to add diary. Status code: ${diaryResponse.statusCode}');
        debugPrint('Response body: ${diaryResponse.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to save diary entry. Please try again.')),
        );
      }
    } catch (e) {
      debugPrint("Error sending data to the backend: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ink your experiences'),
        backgroundColor: Pallete.appBar,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
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
                                hintText: 'Title',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          ElevatedButton(
                            onPressed: () async {
                              debugPrint('Save button pressed');
                              await _addDiary();
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
                            hintText: 'Enter your contents ',
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
