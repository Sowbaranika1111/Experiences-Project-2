import 'dart:io';

import 'package:experiences_project/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadRecordOption extends StatelessWidget {
  const UploadRecordOption({super.key});

  Future<void> getVideoFile(
      BuildContext context, ImageSource sourceVideo) async {
    try {
      final videoFile = await ImagePicker().pickVideo(source: sourceVideo);
      if (videoFile != null) {
        final File file = File(videoFile.path);
        final String path = videoFile.path;
        debugPrint("Video selected: $path");

        // Check if the widget is still mounted before navigating
        if ( context.mounted) {
          debugPrint("Context is mounted, attempting to navigate...");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VideoPreviewPage(
                videoFile: file,
                videoPath: path,
              ),
            ),
          ).then((_) {
            if (context.mounted) {
              debugPrint("Navigation completed");
            } else {
              debugPrint("Context is not mounted after navigation");
            }
          });
        } else {
          debugPrint("Context is not mounted!");
        }
      } else {
        debugPrint("No video file selected!");
      }
    } catch (e) {
      debugPrint("Error picking video: $e");
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text("Failed to pick video: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        // For picking video from the gallery
        SimpleDialogOption(
          onPressed: () {
            getVideoFile(context, ImageSource.gallery);
          },
          child: const Row(
            children: [
              Icon(Icons.image),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Get video from gallery',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // For capturing video
        SimpleDialogOption(
          onPressed: () {
            getVideoFile(context, ImageSource.camera);
          },
          child: const Row(
            children: [
              Icon(Icons.videocam),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Capture Video',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Cancel option
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Row(
            children: [
              Icon(Icons.cancel),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
