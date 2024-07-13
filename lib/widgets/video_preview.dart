import 'dart:io';

import 'package:flutter/material.dart';

class VideoPreviewPage extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const VideoPreviewPage(
      {super.key, required this.videoFile, required this.videoPath});

  @override
  State<VideoPreviewPage> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return const TextField();
  }
}
