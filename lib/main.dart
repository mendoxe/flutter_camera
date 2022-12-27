import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/camera/camera_scaffold.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(scheme: FlexScheme.bahamaBlue),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.bahamaBlue),
      themeMode: ThemeMode.light,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<XFile> pictures = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Camera"),
        actions: [
          IconButton(
            icon: const Icon(Icons.hot_tub),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: pictures.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lotties/empty.json'),
                  const SizedBox(height: 24),
                  const Text("No photos taken..."),
                ],
              )
            : SingleChildScrollView(
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  runSpacing: 6,
                  spacing: 6,
                  alignment: WrapAlignment.center,
                  children: pictures
                      .map(
                        (XFile pic) => ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            File(pic.path),
                            fit: BoxFit.cover,
                            width: 100,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCamera,
        isExtended: true,
        child: const Icon(Icons.camera),
      ),
    );
  }

  Future<void> _openCamera() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CameraScaffold(),
      ),
    );

    if (result == null) return;

    setState(() {
      pictures.addAll(result);
    });
  }
}
