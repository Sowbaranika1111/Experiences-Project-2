import 'package:experiences_project/pallete.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:experiences_project/configs.dart';
// import 'package:experiences_project/pallete.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpDisplayField extends StatefulWidget {
  const ExpDisplayField({super.key});

  @override
  ExpDisplayFieldState createState() => ExpDisplayFieldState();
}

class ExpDisplayFieldState extends State<ExpDisplayField> {
  String displayText = 'Fetching...';
  List<dynamic> listResponse = [];
  final List<ChewieController> _chewieControllers = [];

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
  }

  @override
  void dispose() {
    for (var controller in _chewieControllers) {
      controller.dispose();
    }
    super.dispose();
  }

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
                          aspectRatio: 16 / 9,
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
                                Expanded(
                                  child: Text(
                                    listResponse[index]['exp_category'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Pallete.fontColorExpDesc),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '~${listResponse[index]['name'] ?? ''}',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Pallete.fontColorExpDesc),
                                      textAlign: TextAlign.right,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      listResponse[index]['profession'] ?? '',
                                      style: const TextStyle(
                                          fontSize: 12, color: Pallete.fontColorExpDesc),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              listResponse[index]['exp_desc'] ?? '',
                              style: const TextStyle(
                                  fontSize: 14, color: Pallete.fontColorExpDesc),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
