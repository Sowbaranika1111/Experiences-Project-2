import 'package:flutter/material.dart';

class UploadRecordOption extends StatelessWidget {
  const UploadRecordOption({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        // For picking video from the gallery
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            // Implement your functionality here
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
            // Implement your functionality here
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
