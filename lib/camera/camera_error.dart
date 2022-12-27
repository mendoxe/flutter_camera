import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CameraError extends StatelessWidget {
  const CameraError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Column(
          children: [
            Row(
              children: const [
                BackButton(),
              ],
            ),
            const Spacer(),
            Lottie.asset(
              'assets/lotties/error.json',
              frameRate: FrameRate(300),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Something went wrong..."),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
