import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:experiences_project/configs.dart';
import 'package:experiences_project/pallete.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:expandable/expandable.dart';
// import 'package:favorite_button/favorite_button.dart';

class ExpDisplayField extends StatefulWidget {
  const ExpDisplayField({super.key});

  @override
  ExpDisplayFieldState createState() => ExpDisplayFieldState();
}

class ExpDisplayFieldState extends State<ExpDisplayField> {
  String displayText = 'Fetching...';
  List<dynamic> listResponse = [];
  final List<ChewieController> _chewieControllers = [];
  final Map<String, int> idToIndexMap = {};

  // late SharedPreferences prefs;
  // String userId = '';
  // String videoId = '';

  Future<void> expSubmitApiCall() async {
    try {
      debugPrint("Attempting Fetching!");
      var response = await http.get(Uri.parse(getExp));

      if (response.statusCode == 200) {
        debugPrint("Data fetched successfully: ${response.body}");

        try {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['data'] != null && jsonResponse['data'].isNotEmpty) {
            setState(() {
              listResponse = jsonResponse['data'];
              for (int i = 0; i < listResponse.length; i++) {
                idToIndexMap[listResponse[i]['_id']] = i;
              }
              _initializeVideoControllers();
            });
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
        debugPrint("Failed to fetch data. Status code: ${response.statusCode}");
        setState(() {
          displayText =
              "Failed to load data. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      debugPrint("Error in fetching: $e");
      setState(() {
        displayText = "Error in fetching data: $e";
      });
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
  void initState() {
    super.initState();
    expSubmitApiCall();
    // initSharedPreference();
  }

  @override
  void dispose() {
    for (var controller in _chewieControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Future<void> initSharedPreference() async {
  //   prefs = await SharedPreferences.getInstance();
  //   await _addToFavorites(videoId);
  // }

  // Future<void> _addToFavorites(String videoId) async {
  //   final token = prefs.getString('tokenValue');
  //   debugPrint('Token: $token');

  //   if (token != null) {
  //     try {
  //       // Decode the JWT token
  //       final parts = token.split('.');
  //       if (parts.length != 3) {
  //         throw Exception('Invalid token');
  //       }

  //       final payload = json.decode(
  //           utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));

  //       final userId = payload['id'];
  //       if (userId == null) {
  //         throw Exception('User ID not found in token');
  //       }

  //       debugPrint('Decoded User ID: $userId');
  //       var regBody = {
  //         'userId': userId,
  //         'videoId': videoId,
  //       };
  //       var favAddResponse = await http.post(
  //         Uri.parse(favVideo),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer $token',
  //         },
  //         body: json.encode(regBody),
  //       );

  //       if (favAddResponse.statusCode == 200) {
  //         final responseData = json.decode(favAddResponse.body);
  //         debugPrint("===========Fav=======Add========Response:$responseData");
  //         if (responseData['success']) {
  //           // ScaffoldMessenger.of(context).showSnackBar(
  //           //   SnackBar(content: Text(responseData['message'])),
  //           // );
  //           debugPrint(
  //               "===================>Video Added TO Fav<===================");
  //         } else {
  //           debugPrint(
  //               "===================>Video Not Added To Fav<===================");
  //           throw Exception(responseData['message']);
  //         }
  //       } else {
  //         throw Exception('Failed to add to favorites');
  //       }
  //     } catch (error) {
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(content: Text('Error: $error')),
  //       // );
  //       debugPrint("===================>Error: <=====$error");
  //     }
  //   } else {
  //     debugPrint("No token!");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final List<Color> containerColors = [
      Colors.blue.withOpacity(0.1),
      Colors.green.withOpacity(0.1),
      Colors.purple.withOpacity(0.1),
    ];

    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: _chewieControllers.isEmpty
          ? Center(
              child: Text(displayText,
                  style: const TextStyle(color: Colors.white)))
          : ListView.builder(
              itemCount: _chewieControllers.length,
              itemBuilder: (context, index) {
                final item = listResponse[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: containerColors[index % containerColors.length],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10)),
                        child: AspectRatio(
                          aspectRatio: 18 / 18,
                          child: Chewie(controller: _chewieControllers[index]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '~${item['exp_category'] ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Pallete.fontColorExpDesc,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    // Favourite Button
                                    // FavoriteButton(
                                    //   isFavorite: false,
                                    //   valueChanged: (isFavorite) async {
                                    //     debugPrint('Is Favorite : $isFavorite');
                                    //     if (isFavorite) {
                                    //       // String userId = item['_id'];
                                    //       String videoId = item['video'];
                                    //       debugPrint(
                                    //           'User Id: $userId ************** Video Id: $videoId');
                                    //       await _addToFavorites(videoId);
                                    //     }
                                    //   },
                                    //   iconSize: 30,
                                    //   iconColor: Colors.purple,
                                    // ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '~${item['name'] ?? 'Anonymous'}',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Pallete.fontColorExpDesc),
                                      textAlign: TextAlign.right,
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      item['profession'] ?? 'N/A',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Pallete.fontColorExpDesc),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ExpandableNotifier(
                              child: Column(
                                children: [
                                  Expandable(
                                    collapsed: Text(
                                      item['exp_desc'] ??
                                          'No description available',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Pallete.fontColorExpDesc,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    expanded: Text(
                                      item['exp_desc'] ??
                                          'No description available',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Pallete.fontColorExpDesc,
                                      ),
                                    ),
                                  ),
                                  Builder(
                                    builder: (context) {
                                      var controller = ExpandableController.of(
                                          context,
                                          required: true)!;
                                      return TextButton(
                                        child: Text(
                                          controller.expanded
                                              ? "Show less"
                                              : "Read more",
                                          style: const TextStyle(
                                              color: Colors.blue),
                                        ),
                                        onPressed: () {
                                          controller.toggle();
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
