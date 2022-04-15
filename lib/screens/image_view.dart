import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_test/models/image_modal.dart';
import 'package:job_test/providers/image_list_provider.dart';
import 'package:provider/provider.dart';

class ImagePreViewScreen extends StatelessWidget {
  const ImagePreViewScreen({Key? key, required this.imagePath})
      : super(key: key);
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<ImageListProvider>(
        builder: (BuildContext context, imageList, Widget? child) {
          List<ImageModal> list = imageList.images.reversed.toList();
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: imageList.images.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                ImageViewScreen(initial: index)));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(list[index].imageSrc)))),
                  ),
                );
              });
        },
      ),
    );
  }
}

class ImageViewScreen extends StatefulWidget {
  const ImageViewScreen({Key? key, required this.initial}) : super(key: key);
  final int initial;
  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  late PageController pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: widget.initial);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<ImageListProvider>(
        builder: (BuildContext context, imageList, Widget? child) {
          List<ImageModal> list = imageList.images.reversed.toList();
          return PageView.builder(
              controller: pageController,
              itemCount: imageList.images.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(list[index].imageSrc)))),
                );
              });
        },
      ),
    );
  }
}
