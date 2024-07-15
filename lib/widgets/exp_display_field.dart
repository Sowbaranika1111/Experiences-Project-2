import 'package:experiences_project/configs.dart';
import 'package:experiences_project/pallete.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpDisplayField extends StatefulWidget {
  const ExpDisplayField({super.key});

  @override
  State<ExpDisplayField> createState() => _ExpDisplayFieldState();
}

class _ExpDisplayFieldState extends State<ExpDisplayField> {
  String displayText = 'Loading...';

  Future<void> expSubmitApiCall() async {
    try {
      debugPrint("Attempting Fetching!");
      var response = await http.get(Uri.parse(getExp));
      
      if (response.statusCode == 200) {
        debugPrint("Data fetched successfully: ${response.body}");
        
        // Try to parse the response as JSON
        try {
          var jsonResponse = jsonDecode(response.body);
          setState(() {
            displayText = jsonEncode(jsonResponse); // Convert JSON to string for display
          });
        } catch (e) {
          debugPrint("Error parsing JSON: $e");
          setState(() {
            displayText = "Error parsing data: $e";
          });
        }
      } else {
        debugPrint("Failed to fetch data. Status code: ${response.statusCode}");
        setState(() {
          displayText = "Failed to load data. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      debugPrint("Error in fetching: $e");
      setState(() {
        displayText = "Error in fetching data: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    expSubmitApiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Pallete.appBar,
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              displayText,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}