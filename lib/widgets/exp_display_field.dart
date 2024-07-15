import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:experiences_project/configs.dart';
import 'package:experiences_project/pallete.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class ExpDisplayField extends StatefulWidget {
  const ExpDisplayField({super.key});

  @override
  ExpDisplayFieldState createState() => ExpDisplayFieldState();
}

class ExpDisplayFieldState extends State<ExpDisplayField> {
  String displayText = 'Loading...';
  List<dynamic> listResponse = [];
  final List<VideoPlayerController> _controllers = [];

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

Future<void> _initializeVideoControllers() async {
  for (var item in listResponse) {
    if (item['video'] != null && item['video'].isNotEmpty) {
      final videoUrl = '${videoBaseUrl}${item['video']}';
      debugPrint("Initializing video: $videoUrl");
      try {
  final videoUrl = '$videoBaseUrl${item['video']}';
  debugPrint("Full video URL: $videoUrl");
  final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
  await controller.initialize();
  controller.setLooping(true); // Loop the video
  _controllers.add(controller);
  debugPrint("Video initialized: ${item['video']}");
} on PlatformException catch (error) {
  // Handle specific platform exceptions
  debugPrint("PlatformException - Error code: ${error.code}, message: ${error.message}");
} catch (error) {
  // Handle other general exceptions
  debugPrint("General error initializing video: $error");
}

    } else {
      debugPrint("Invalid video key for item: $item");
    }
  }
}

  @override
  void initState() {
    super.initState();
    // expSubmitApiCall();
    _initializeVideoControllers();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Pallete.appBar,
      ),
      child: listResponse.isEmpty
          ? Center(child: Text(displayText, style: const TextStyle(color: Colors.white)))
          : ListView.builder(
              itemCount: listResponse.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  height: 200,
                  child: _buildVideoWidget(index),
                );
              },
            ),
    );
  }

  Widget _buildVideoWidget(int index) {
    if (_controllers.length <= index) {
      return const Center(child: Text("Video not available", style: TextStyle(color: Colors.white)));
    }
    
    final controller = _controllers[index];
    if (!controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          VideoPlayer(controller),
          VideoProgressIndicator(controller, allowScrubbing: true),
          PlayPauseOverlay(controller: controller),
        ],
      ),
    );
  }
}

class PlayPauseOverlay extends StatelessWidget {
  final VideoPlayerController controller;

  const PlayPauseOverlay({super.key,required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedSwitcher(
          duration:const Duration(milliseconds: 50),
          reverseDuration:const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ?const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child:const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}



//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       width: 300,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Pallete.appBar,
//       ),
//       child: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child:  Text(
//               listResponse.isNotEmpty ? 
//                                     listResponse[0]['name'].toString()
//                                     :
//                                     displayText,
//               style: const TextStyle(color: Colors.white),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       ),
//     );
//   }