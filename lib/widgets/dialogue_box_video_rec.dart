import 'dart:io';
import 'package:experiences_project/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:experiences_project/widgets/camera_utils.dart';
class UploadRecordOption extends StatefulWidget {
  const UploadRecordOption({super.key});

  @override
  State<UploadRecordOption> createState() => _UploadRecordOptionState();
}

class _UploadRecordOptionState extends State<UploadRecordOption> {
  @override
  void initState() {
    super.initState();
    setUpCameraDelegate();
  }

  Future<void> getVideoFile(
      BuildContext context, ImageSource sourceVideo) async {
    try {
      final videoFile = await ImagePicker().pickVideo(source: sourceVideo);
      if (videoFile != null) {
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VideoPreviewPage(
                videoFile: File(videoFile.path),
                videoPath: videoFile.path,
              ),
            ),
          );
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
            Navigator.pop(context); // Close the dialog
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
            Navigator.pop(context); // Close the dialog
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

        // For cancel option
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
