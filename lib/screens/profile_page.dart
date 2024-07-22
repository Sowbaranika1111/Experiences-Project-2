import 'package:experiences_project/configs.dart';
// import 'package:experiences_project/pallete.dart';
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
  // ChewieController? _chewieController;

  String displayText = 'Fetching...';
  final List<ChewieController> _chewieControllers = [];
  final Map<String, int> idToIndexMap = {};
  List<Map<String, dynamic>> listResponse = [];

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    await _loadUserData();
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

  Future<void> _loadUserExpData(String email) async {
    try {
      var regBody = {"email": email};

      var detailResponse = await http.post(
        Uri.parse(getUserExpDetails),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (detailResponse.statusCode == 200) {
        debugPrint("Data fetched successfully: ${detailResponse.body}");

        var jsonResponse = jsonDecode(detailResponse.body);

        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          setState(() {
            listResponse = (jsonResponse['data'] as List).map((item) {
              return {
                '_id': item['id']?.toString() ?? '',
                'name': item['name']?.toString() ?? '',
                'age': item['age']?.toString() ?? '',
                'country': item['country']?.toString() ?? '',
                'profession': item['profession']?.toString() ?? '',
                'meditating_experience':
                    item['meditating_experience']?.toString() ?? '',
                'exp_category': item['exp_category']?.toString() ?? '',
                'exp_desc': item['exp_desc']?.toString() ?? '',
                'video': item['video']?.toString() ?? '',
              };
            }).toList();

            _initializeVideoControllers();
            displayText = "Data loaded successfully";
          });
        } else {
          setState(() {
            displayText = jsonResponse['message'] ?? "No data available";
          });
        }
      } else {
        setState(() {
          displayText = "Failed to fetch data: ${detailResponse.statusCode}";
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() {
        displayText = "Error: $e";
      });
    }
  }

  Future<void> _deleteUserExp(String id) async {
    try {
      var regBody = {"_id": id};

      var removeResponse = await http.post(
        Uri.parse(removeUserExpDetails),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (removeResponse.statusCode == 200) {
        setState(() {
          listResponse.removeWhere((item) => item['_id'] == id);
        });

        debugPrint(
            "Remove Response=====================: ${removeResponse.body}");

        debugPrint("Item deleted successfully: $id");
      }
    } catch (e) {
      debugPrint("Error deleting the data! : $e");
    }
  }

  Future<void> _initializeVideoControllers() async {
    for (var item in listResponse) {
      if (item['video'] != null && item['video'].isNotEmpty) {
        final videoUrl = '$videoBaseUrl${item['video']}';
        debugPrint("Initializing video: $videoUrl");
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
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          );

          setState(() {
            _chewieControllers.add(chewieController);
          });

          debugPrint("Video initialized: ${item['video']}");
        } catch (error) {
          debugPrint("Error initializing video: $error");
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '',
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                //!Logout button
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
            const SizedBox(height: 20),
            Text('Name: $name', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Email: $email', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: listResponse.isEmpty
                  ? Center(
                      child: Text(displayText,
                          style: const TextStyle(color: Colors.black)),
                    )
                  : ListView.builder(
                      itemCount: listResponse.length,
                      itemBuilder: (context, index) {
                        final item = listResponse[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 63, 62, 62),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_chewieControllers.length > index)
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Chewie(
                                        controller: _chewieControllers[index]),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Name: ${item['name']}',
                                            style: const TextStyle(
                                                color: Colors.white)),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 18,
                                          ),
                                          onPressed: () async {
                                            String itemId = item['_id'];
                                            debugPrint(
                                                'Id======================: $itemId');
                                            await _deleteUserExp(itemId);
                                            
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Experience deleted!')));
                                            }
                                            await (_loadUserExpData(email));
                                          },
                                        )
                                      ],
                                    ),
                                    Text('Age: ${item['age']}',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    Text('Country: ${item['country']}',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    Text('Profession: ${item['profession']}',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    Text(
                                        'Meditating Experience: ${item['meditating_experience']}',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    Text(
                                        'Experience Category: ${item['exp_category']}',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    Text(
                                        'Experience Description: ${item['exp_desc']}',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
