import 'package:experiences_project/configs.dart';
import 'package:experiences_project/pallete.dart';
import 'package:experiences_project/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

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
  ChewieController? _chewieController;

  String displayText = 'Fetching...';
  final List<ChewieController> _chewieControllers = [];
  final Map<String, int> idToIndexMap = {};
  List<Map<String, dynamic>> listResponse = [];

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

          if (email.isNotEmpty) {
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
        debugPrint("Data fetched successfully: ${detailResponse.body}");

        try {
          var jsonResponse = jsonDecode(detailResponse.body);

          if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
            setState(() {
              listResponse =
                  List<Map<String, dynamic>>.from(jsonResponse['data']);
              for (int i = 0; i < listResponse.length; i++) {
                idToIndexMap[listResponse[i][email]] = i;
              }
              _initializeVideoControllers();

              // isLoading = false;
            });
            // _initializeVideoControllers();
          } else {
            setState(() {
              displayText = "No data available";
            });
          }
        } catch (e) {
          debugPrint("Error parsing JSON: $e");
          setState(() {
            displayText = "Error parsing data: $e";
          });
        }
      } else {
        debugPrint(
            "Failed to fetch data. Status code: ${detailResponse.statusCode}");
        setState(() {
          displayText =
              "Failed to load data. Status code: ${detailResponse.statusCode}";
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _initializeVideoControllers() async {
    for (var item in listResponse) {
      if (item['video'] != null && item['video'].isNotEmpty) {
        final videoUrl = ' $videoBaseUrl${item['video']}';
        debugPrint(
            "=========>Initializing video in profile page of the user<======= $videoUrl");

        try {
          final videoPlayerController =
              VideoPlayerController.networkUrl(Uri.parse(videoUrl));
          await videoPlayerController.initialize();

          final chewieController = ChewieController(
              videoPlayerController: videoPlayerController,
              autoPlay: false,
              looping: true,
              aspectRatio: 18 / 15,
              errorBuilder: (context, errorMessage) {
                return Center(
                    child: Text(errorMessage,
                        style: const TextStyle(color: Colors.white)));
              });

          setState(() {
            _chewieControllers.add(chewieController);
          });

          debugPrint("_________________Video initialized: ${item['video']}");
        } catch (error) {
          debugPrint("_____________-Error initializing video: $error");
        }
      } else {
        debugPrint("Invalid video key for item: $item");
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _chewieControllers) {
      controller.dispose;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (_chewieController != null)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Chewie(controller: _chewieController!),
                    ),
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '',
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Name: $name', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  Text('Email: $email', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await prefs.remove('tokenValue');
                      if (context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
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
