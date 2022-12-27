import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera/camera/camera_controll_panel.dart';
import 'package:flutter_camera/camera/camera_pictures_gallery.dart';
import 'package:flutter_camera/camera/small_image_preview.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.cameraController})
      : super(key: key);

  final CameraController cameraController;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<XFile> pics = [];
  double size = 160;
  bool isExpanded = false;
  bool isCapturing = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void _toggleGallery() {
    setState(() {
      isExpanded = !isExpanded;
      size = isExpanded ? MediaQuery.of(context).size.height * 0.9 : 160;
    });
  }

  void _deleteImage(XFile pic) {
    pics.remove(pic);
    setState(() {});
  }

  void _deleteImageByIndex(int index) {
    pics.removeAt(index);
    setState(() {});
  }

  void _closeCamera() {
    Navigator.pop(context, pics);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.black,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: isExpanded
                      ? Container()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CameraPreview(widget.cameraController),
                        ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    height: size,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CameraControllPanel(
                          isExpanded: isExpanded,
                          toggleGallery: _toggleGallery,
                          takePicture: _takePicture,
                          closeCamera: _closeCamera,
                          isEmpty: pics.isEmpty,
                        ),
                        if (isExpanded)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 12),
                            child: Text(
                              "Pictures",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        Container(
                          height: !isExpanded ? 80 : 420,
                          color: Colors.black,
                          child: !isExpanded
                              ? ListView.builder(
                                  itemCount: pics.length + 1,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => index == 0
                                      ? const SizedBox(width: 12)
                                      : SmallImagePreview(
                                          delete: _deleteImage,
                                          picture: pics[index - 1],
                                          open: _openPicture,
                                        ),
                                )
                              : GridView.builder(
                                  itemCount: pics.length,
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                  ),
                                  itemBuilder: (context, index) {
                                    return SmallImagePreview(
                                      delete: _deleteImage,
                                      picture: pics[index],
                                      open: _openPicture,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 5,
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.blueGrey.withOpacity(0.25),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context, []);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPicture(XFile pic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CameraPicturesGallery(
            pics: pics,
            currentPic: pic,
            delete: _deleteImageByIndex,
          );
        },
      ),
    );
  }

  Future<void> _takePicture() async {
    if (isCapturing) return;
    setState(() => isCapturing = true);
    XFile pic = await widget.cameraController.takePicture().catchError((err) {
      log(err);
      setState(() => isCapturing = false);
    });
    pics.add(pic);
    setState(() => isCapturing = false);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
