import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class SmallImagePreview extends StatelessWidget {
  const SmallImagePreview({
    Key? key,
    required this.delete,
    required this.picture,
    required this.open,
  }) : super(key: key);

  final Function delete;
  final Function open;
  final XFile picture;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.symmetric(
            horizontal: 6.0,
            vertical: 10.0,
          ),
          padding: const EdgeInsets.all(0.5),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade200,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: GestureDetector(
            onTap: () => open(picture),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Image.file(
                File(picture.path),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: -12,
          left: -15,
          child: IconButton(
            onPressed: () {
              delete(picture);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
