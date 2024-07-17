import 'package:experiences_project/configs.dart';
import 'package:experiences_project/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences prefs;
  String name = '';
  String email = '';
  bool isLoading = true;
  // Map<String,dynamic> jsonResponse = {};

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await _loadUserData();
    await _loadUserExpData(email);
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
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
          setState(() {
            name = data['user']['name'];
            email = data['user']['email'];
            isLoading = false;
          });
          debugPrint('Name: $name, Email: $email');

          if(email.isNotEmpty){
                      await _loadUserExpData(email);
          }

        } else {
          // Handle error
          debugPrint('Failed to load user data');
          setState(() {
            isLoading = false;
          });
        }

        // final userExpDetails =
        // );
      } catch (e) {
        debugPrint('Error: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      debugPrint('No token found');
      // No token found, navigate to login page
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<void> _loadUserExpData(String email) async {
    try {
      var regBody = {
        //what the api is accepting pass that here
        "email": email
      };

      var detailResponse = await http.post(Uri.parse(getUserExpDetails),
          headers: {"Content-type": "application/json"},
          body: jsonEncode(regBody));

      if (detailResponse.statusCode == 200) {
        var jsonResponse = jsonDecode(detailResponse.body) as Map<String,dynamic>;
        debugPrint(jsonResponse.toString());
      } else {
        debugPrint('Failed to load user experience data');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '',
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Name: $name',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Email: $email',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await prefs.remove('tokenValue');
                      if (context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      }
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
    );
  }
}
