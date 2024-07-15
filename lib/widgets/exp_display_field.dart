import 'package:experiences_project/configs.dart';
import 'package:experiences_project/pallete.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExpDisplayField extends StatefulWidget {
  const ExpDisplayField({super.key});

  @override
  State<ExpDisplayField> createState() => _ExpDisplayFieldState();
}

class _ExpDisplayFieldState extends State<ExpDisplayField> {
  String stringResponse = 'Fetching data...';

  Future expSubmitApiCall() async {
    try {
      debugPrint("Attempting Fetching!");
      var response = await http.get(Uri.parse(getExp));
      if (response.statusCode == 200) {
        debugPrint("Data fetched successfully: ${response.body}");
        setState(() {
          stringResponse = response.body;
        });
      } else {
        debugPrint("Failed to fetch data. Status code: ${response.statusCode}");
        setState(() {
          stringResponse = "Failed to load data. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      debugPrint("Error in fetching: $e");
      setState(() {
        stringResponse = "Error in fetching data.";
      });
    }
  }

  @override
  void initState() {
    expSubmitApiCall();
    super.initState();
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
        child: Text(
          stringResponse,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center, // Added to handle multi-line text better
        ),
      ),
    );
  }
}
