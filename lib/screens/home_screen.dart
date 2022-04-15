import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_test/models/image_modal.dart';
import 'package:job_test/providers/auth_provider.dart';
import 'package:job_test/providers/image_list_provider.dart';
import 'package:job_test/screens/image_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;
  List<CameraDescription> cameras = [];
  String? imagePath;
  int selectedCameraIdx = 0;
  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = Future.delayed(Duration(milliseconds: 100));
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.isNotEmpty) {
        setState(() {
          selectedCameraIdx = 0;
        });
        _initCameraController(cameras[selectedCameraIdx]);
      } else {
        _showSnackBar("No camera available");
      }
    }).catchError((err) {
      _showSnackBar('Error: $err.code\nError Message: $err.message');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    controller = CameraController(cameraDescription, ResolutionPreset.high);
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        _showSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });
    try {
      _initializeControllerFuture = controller.initialize();
    } on CameraException catch (e) {
      _showSnackBar(e.toString());
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _captureImage(ImageListProvider imageListProvider) async {
    try {
      final image = await controller.takePicture();
      imageListProvider.addImageToList(ImageModal(imageSrc: image.path));
      setState(() {
        imagePath = image.path;
      });
    } catch (e) {
      _showSnackBar('Cannot Capture');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Hero(tag: 'log',
        child: const FlutterLogo()),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                authService.signOut();
              },
              child: Container(
                  width: 75,
                  height: 20,
                  padding: EdgeInsets.all(5),
                  child: const Center(
                      child: Text(
                    "Log Out",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ))),
            ),
          )
        ],
      ),
      body: Consumer<ImageListProvider>(
        builder: (BuildContext context, imageList, Widget? child) {
          return Stack(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: FutureBuilder(
                    future: _initializeControllerFuture,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(controller);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(),
                      FloatingActionButton(
                        onPressed: () {
                          _captureImage(imageList);
                        },
                        backgroundColor: Colors.lightBlueAccent,
                        child: const Icon(Icons.camera),
                      ),
                      GestureDetector(
                        onTap: () {
                          imageList.images.isNotEmpty
                              ? Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ImagePreViewScreen(
                                          imagePath: imagePath!)))
                              : _showSnackBar('No Image');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 2, color: Colors.lightBlueAccent)),
                          width: 40,
                          height: 40,
                          child: imagePath != null
                              ? Image.file(File(imagePath ?? ''))
                              : const Icon(Icons.image),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {}
    }
  }

  _showSnackBar(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(s),
    ));
  }
}
