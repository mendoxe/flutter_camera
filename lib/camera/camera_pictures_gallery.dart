import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPicturesGallery extends StatefulWidget {
  const CameraPicturesGallery({
    Key? key,
    required this.pics,
    required this.currentPic,
    required this.delete,
  }) : super(key: key);

  final List<XFile> pics;
  final XFile currentPic;
  final Function delete;

  @override
  State<CameraPicturesGallery> createState() => _CameraPicturesGalleryState();
}

class _CameraPicturesGalleryState extends State<CameraPicturesGallery> {
  late TransformationController _transformationController;
  late PageController _pageController;
  TapDownDetails? _doubleTapDetails;
  ScrollPhysics? _scrollPhysics;
  int index = 0;
  List<XFile> pics = [];

  @override
  void initState() {
    super.initState();
    pics = widget.pics;
    index = widget.pics.indexOf(widget.currentPic);
    _transformationController = TransformationController()
      ..addListener(() {
        if (_transformationController.value.getMaxScaleOnAxis() == 1) {
          setState(() {
            _scrollPhysics = null;
          });
        } else {
          setState(() {
            _scrollPhysics = const NeverScrollableScrollPhysics();
          });
        }
      });
    _pageController = PageController(
      initialPage: index,
    )..addListener(() {
        setState(() {
          index = (_pageController.page ?? 0).toInt();
        });
      });
  }

  void delete() {
    widget.delete(index);
    if (pics.isEmpty) {
      Navigator.pop(context);
    }
    _pageController.previousPage(
        duration: const Duration(milliseconds: 150), curve: Curves.ease);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(onPressed: delete, icon: const Icon(Icons.delete))
        ],
      ),
      body: GestureDetector(
        onDoubleTap: doubleTap,
        onDoubleTapDown: (details) => _doubleTapDetails = details,
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 1,
          maxScale: 5.0,
          child: PageView.builder(
            controller: _pageController,
            physics: _scrollPhysics,
            itemCount: pics.length,
            itemBuilder: (context, index) {
              return Image.file(File(pics[index].path));
            },
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            index != 0
                ? IconButton(
                    onPressed: decrement,
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 42,
                    ),
                  )
                : const SizedBox(width: 44),
            Text(
              "${index + 1}/${pics.length}",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.white),
            ),
            index != pics.length - 1
                ? IconButton(
                    onPressed: increment,
                    icon: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 42,
                    ),
                  )
                : const SizedBox(width: 44),
          ],
        ),
      ),
    );
  }

  void doubleTap() {
    if (_transformationController.value.getMaxScaleOnAxis() != 1) {
      _transformationController.value = Matrix4.identity();
      return;
    }
    if (_doubleTapDetails == null) return;
    final position = _doubleTapDetails!.localPosition;

    _transformationController.value = Matrix4.identity()
      ..translate(-position.dx, -position.dy)
      ..scale(2.0);
  }

  void increment() {
    setState(() {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 150), curve: Curves.ease);
    });
  }

  void decrement() {
    setState(() {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 150), curve: Curves.ease);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }
}
