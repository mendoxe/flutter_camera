import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/camera/camera_error.dart';
import 'package:flutter_camera/camera/camera_loading.dart';
import 'package:flutter_camera/camera/camera_screen.dart';

class CameraScaffold extends StatefulWidget {
  const CameraScaffold({Key? key}) : super(key: key);

  @override
  State<CameraScaffold> createState() => _CameraScaffoldState();
}

class _CameraScaffoldState extends State<CameraScaffold> {
  late List<CameraDescription> cameras;
  late CameraController controller;
  bool hasError = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    cameras = await availableCameras().catchError((err) {
      log(err);
      setState(() => hasError = true);
    });
    controller = CameraController(cameras[0], ResolutionPreset.max);
    await controller.initialize();

    if (!mounted) return;
    controller.setFlashMode(FlashMode.off);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const CameraLoading();
    if (hasError) return const CameraError();
    return CameraScreen(cameraController: controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
