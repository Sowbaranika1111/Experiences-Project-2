import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewPage extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const VideoPreviewPage(
      {super.key, required this.videoFile, required this.videoPath,});
      
  @override
  State<VideoPreviewPage> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  VideoPlayerController? playerController;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      playerController = VideoPlayerController.file(widget.videoFile);
      await playerController!.initialize();
      setState(() {
        playerController!.play();
        playerController!.setVolume(2);
        playerController!.setLooping(true);
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error initializing video: $e";
      });
      debugPrint("Error initializing video: $e");
    }
  }

  @override
  void dispose() {
    playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Preview'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text( errorMessage!, style: const TextStyle(color: Colors.red)),
              ),
            if (playerController != null &&
                playerController!.value.isInitialized)
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.6,
                child: AspectRatio(
                  aspectRatio: playerController!.value.aspectRatio,
                  child: VideoPlayer(playerController!),
                ),
              )
            else if (errorMessage == null)
              const Center(child: CircularProgressIndicator()),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("File path: ${widget.videoPath}"),
            ),
          ],
        ),
      ),
    );
  }
}
