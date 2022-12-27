import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CameraLoading extends StatelessWidget {
  const CameraLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Lottie.asset('assets/lotties/loading.json'),
              ),
              const SizedBox(width: 100),
              const Text("Camera is loading..."),
            ],
          ),
        ),
      ),
    );
  }
}
