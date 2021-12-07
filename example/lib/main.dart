import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_frame/video_frame.dart';

void main() {
  runApp( MyApp(images: <Image>[]));
}


class ImageItem extends StatelessWidget {
  ImageItem({required this.image}) : super(key: ObjectKey(image));
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Container(child: image);
  }
}

class MyApp extends StatefulWidget {
  List<Image> images;

 MyApp({Key? key, required this.images}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  var _isClean = false;
  final ImagePicker _picker = ImagePicker();
  Stream<File>? _imagesStream;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await VideoFrame.platformVersion ?? 'Unknown platform version';
    } on PlatformException {

      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }



  Future _getImagesByTime() async {
    final XFile? file = await _picker.pickVideo(
        source: ImageSource.gallery);
    _imagesStream = VideoFrame.exportImagesFromFile(
      File(file!.path),
      const Duration(milliseconds: 500),
      pi / 2,
    ) ;

    setState(() {
      _isClean = true;
    });

    _imagesStream!.listen((image) {
      setState(() {
        widget.images.add(Image.file(File(image.path)));
      });
    });
  }

  Future _getImages() async {
    final XFile? file = await _picker.pickVideo(
        source: ImageSource.gallery,);
    var images = await VideoFrame.exportImage(file!.path, 10, 100);
    var result = images.map((file) => Image.file(file)).toList();
    setState(() {
      widget.images.addAll(result);
      _isClean = true;
    });
  }

  Future _getGifImages() async {
    final XFile? file =
    await _picker.pickImage(source: ImageSource.gallery);

    var images = await VideoFrame.exportGifImage(file!.path, 0);
    var result = images.map((file) => Image.file(file)).toList();
    setState(() {
      widget.images.addAll(result);
      _isClean = true;
    });
  }

  Future _getImagesByDuration() async {
    final XFile? pickedFile =
    await _picker.pickVideo(source: ImageSource.gallery);
    final File file = File(pickedFile!.path);
    var duration = Duration(seconds: 1);
    var image =
    await VideoFrame.exportImageBySeconds(file, duration, 0);
    setState(() {
      widget.images.add(Image.file(image));
      _isClean = true;
    });
    await VideoFrame.saveImage(image, "Video Export Demo",
        waterMark: "images/water_mark.png",
        alignment: Alignment.bottomLeft,
        scale: 2.0);
  }

  Future _cleanCache() async {
    var result = await VideoFrame.cleanImageCache();
    print(result);
    setState(() {
      widget.images.clear();
      _isClean = false;
    });
  }

  Future _handleClickFirst() async {
    if (_isClean) {
      await _cleanCache();
    } else {
      await _getImages();
    }
  }

  Future _handleClickSecond() async {
    if (_isClean) {
      await _cleanCache();
    } else {
      await _getImagesByDuration();
    }
  }

  Future _handleClickThird() async {
    if (_isClean) {
      await _cleanCache();
    } else {
      await _getGifImages();
    }
  }

  Future _handleClickFourth() async {
    if (_isClean) {
      await _cleanCache();
    } else {
      await _getImagesByTime();
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            Expanded(
              flex: 1,
              child: GridView.extent(
                  maxCrossAxisExtent: 400,
                  childAspectRatio: 1.0,
                  padding: const EdgeInsets.all(4),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: widget.images.length > 0
                      ? widget.images
                      .map((image) => ImageItem(image: image))
                      .toList()
                      : [Container()]),
            ),
            Expanded(
              flex: 0,
              child: Center(
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: 40,
                  minWidth: 100,
                  onPressed: () {
                    _handleClickFirst();
                  },
                  color: Colors.orange,
                  child: Text(_isClean ? "Clean" : "Export image list"),
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Center(
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: 40,
                  minWidth: 150,
                  onPressed: () {
                    _handleClickSecond();
                  },
                  color: Colors.orange,
                  child: Text(_isClean ? "Clean" : "Export one image and save"),
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Center(
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: 40,
                  minWidth: 150,
                  onPressed: () {
                    _handleClickThird();
                  },
                  color: Colors.orange,
                  child: Text(_isClean ? "Clean" : "Export gif image"),
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Center(
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: 40,
                  minWidth: 150,
                  onPressed: () {
                    _handleClickFourth();
                  },
                  color: Colors.orange,
                  child: Text(_isClean ? "Clean" : "Export images by interval"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
