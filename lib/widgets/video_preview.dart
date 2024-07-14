// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPreviewPage extends StatefulWidget {
//   final File videoFile;
//   final String videoPath;

//   const VideoPreviewPage({
//     super.key,
//     required this.videoFile,
//     required this.videoPath,
//   });

//   @override
//   State<VideoPreviewPage> createState() => _VideoPreviewPageState();
// }

// class _VideoPreviewPageState extends State<VideoPreviewPage> {
//   VideoPlayerController? playerController;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//   }

//   Future<void> _initializeVideo() async {
//     try {
//       playerController = VideoPlayerController.file(widget.videoFile);
//       await playerController!.initialize();
//       setState(() {
//         playerController!.play();
//         playerController!.setVolume(1.0);
//         playerController!.setLooping(false);
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = "Error initializing video: $e";
//       });
//       debugPrint("Error initializing video: $e");
//     }
//   }

//   @override
//   void dispose() {
//     playerController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video Preview'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             if (errorMessage != null)
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   errorMessage!,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//             if (playerController != null &&
//                 playerController!.value.isInitialized)
//               Column(
//                 children: [
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height / 1.8,
//                     child: AspectRatio(
//                       aspectRatio: playerController!.value.aspectRatio,
//                       child: VideoPlayer(playerController!),
//                     ),
//                   ),
//                   VideoProgressIndicator(
//                     playerController!,
//                     allowScrubbing: true,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           playerController!.value.isPlaying
//                               ? Icons.pause
//                               : Icons.play_arrow,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             if (playerController!.value.isPlaying) {
//                               playerController!.pause();
//                             } else {
//                               playerController!.play();
//                             }
//                           });
//                         },
//                       ),
                      
//                       IconButton(
//                         icon: const Icon(Icons.cancel,
//                         color:Colors.red),
//                         iconSize: 44,
//                         onPressed: () {
//                           Navigator.pop(context, false);
//                           // Optionally, add logic here to start video capture again
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.check),
//                         onPressed: () {
//                           Navigator.pop(context, true);
//                           // Optionally, handle the confirmation action here
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               )
//             else if (errorMessage == null)
//               const Center(child: CircularProgressIndicator()),
//           ],
//         ),
//       ),
//     );
//   }
// }
