import 'dart:io';

// import 'package:experiences_project/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadRecordOption extends StatelessWidget {
  const UploadRecordOption({super.key});

  Future<void> getVideoFile(
      BuildContext context, ImageSource sourceVideo) async {
    try {
      // Request permissions first
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.camera,
      ].request();

      if (statuses[Permission.storage]!.isGranted &&
          (sourceVideo == ImageSource.gallery ||
              statuses[Permission.camera]!.isGranted)) {
        try {
          final videoFile = await ImagePicker().pickVideo(source: sourceVideo);
          if (videoFile == null) {
            debugPrint('File is not available');
          }
          if (videoFile != null) {
            final File file = File(videoFile.path);
            final String path = videoFile.path;
            debugPrint("Video selected: $path");
            if (context.mounted) {
              debugPrint("Context is mounted, attempting to navigate...");
              Navigator.of(context).pop(file);
            }
          } else {
            debugPrint("No video file selected!");
          }
        } catch (e) {
          debugPrint("Specific error while picking video: $e");
        }
      } else {
        throw Exception("Required permissions not granted");
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
            debugPrint('Opening Gallery');
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
            debugPrint('Opening Camera');
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
