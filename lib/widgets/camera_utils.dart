import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

void setUpCameraDelegate() {
  final ImagePickerPlatform instance = ImagePickerPlatform.instance;
  if (instance is CameraDelegatingImagePickerPlatform) {
    instance.cameraDelegate = MyCameraDelegate();
  }
}

class MyCameraDelegate extends ImagePickerCameraDelegate {
  @override
  Future<XFile?> takePhoto({
    ImagePickerCameraDelegateOptions options =
        const ImagePickerCameraDelegateOptions(),
  }) async {
    return null;
  }

  @override
  Future<XFile?> takeVideo({
    ImagePickerCameraDelegateOptions options =
        const ImagePickerCameraDelegateOptions(),
  }) async {
    try {
      // Initialize the camera
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      // Create a CameraController
      final controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );

      // Initialize the controller
      await controller.initialize();

      // Take the picture
      final XFile file = await controller.takePicture();

      // Dispose of the controller when done
      await controller.dispose();

      return file;
    } catch (e) {
      debugPrint('Error taking photo: $e');
      return null;
    }
  }
}
