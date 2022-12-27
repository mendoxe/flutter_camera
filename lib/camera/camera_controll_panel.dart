import 'package:flutter/material.dart';

class CameraControllPanel extends StatelessWidget {
  const CameraControllPanel({
    Key? key,
    required this.isExpanded,
    required this.toggleGallery,
    required this.takePicture,
    required this.closeCamera,
    required this.isEmpty,
  }) : super(key: key);

  final bool isExpanded;
  final bool isEmpty;
  final void Function() toggleGallery;
  final void Function() takePicture;
  final void Function() closeCamera;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isExpanded
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.spaceAround,
      children: isExpanded
          ? [
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: TextButton.icon(
                  onPressed: toggleGallery,
                  icon: const Icon(
                    Icons.expand_more,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Collapse",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              isEmpty
                  ? const SizedBox(width: 45)
                  : IconButton(
                      onPressed: closeCamera,
                      icon: const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ),
            ]
          : [
              isEmpty
                  ? const SizedBox(width: 45)
                  : IconButton(
                      onPressed: toggleGallery,
                      icon: const Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
              Container(
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                ),
                child: IconButton(
                  onPressed: takePicture,
                  icon: const Icon(
                    Icons.camera,
                    color: Colors.white,
                  ),
                ),
              ),
              isEmpty
                  ? const SizedBox(width: 45)
                  : IconButton(
                      onPressed: closeCamera,
                      icon: const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ),
            ],
    );
  }
}
