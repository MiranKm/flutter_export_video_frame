import 'dart:io';
import 'dart:math';

<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:export_video_frame/export_video_frame.dart';

void main() {
  runApp( MyApp(images: <Image>[]));
}

=======
/** 
MIT License

Copyright (c) 2019 mengtnt

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:export_video_frame/export_video_frame.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Plugin Example App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(images: <Image>[]),
    );
  }
}
>>>>>>> upstream/master

class ImageItem extends StatelessWidget {
  ImageItem({required this.image}) : super(key: ObjectKey(image));
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Container(child: image);
  }
}

<<<<<<< HEAD
class MyApp extends StatefulWidget {
  List<Image> images;

 MyApp({Key? key, required this.images}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
=======
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.images}) : super(key: key);

  final List<Image> images;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
>>>>>>> upstream/master
  var _isClean = false;
  final ImagePicker _picker = ImagePicker();
  Stream<File>? _imagesStream;

<<<<<<< HEAD
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
          await ExportVideoFrame.platformVersion ?? 'Unknown platform version';
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
=======
  Future _getImagesByTime() async {
    final PickedFile? file = await _picker.getVideo(
        source: ImageSource.gallery, maxDuration: const Duration(seconds: 10));
>>>>>>> upstream/master
    _imagesStream = ExportVideoFrame.exportImagesFromFile(
      File(file!.path),
      const Duration(milliseconds: 500),
      pi / 2,
<<<<<<< HEAD
    ) ;
=======
    );
>>>>>>> upstream/master

    setState(() {
      _isClean = true;
    });

    _imagesStream!.listen((image) {
      setState(() {
<<<<<<< HEAD
        widget.images.add(Image.file(File(image.path)));
=======
        widget.images.add(Image.file(image));
>>>>>>> upstream/master
      });
    });
  }

  Future _getImages() async {
<<<<<<< HEAD
    final XFile? file = await _picker.pickVideo(
        source: ImageSource.gallery,);
    var images = await ExportVideoFrame.exportImage(file!.path, 10, 100);
=======
    final PickedFile? file = await _picker.getVideo(
        source: ImageSource.gallery, maxDuration: const Duration(seconds: 10));
    var images = await ExportVideoFrame.exportImage(file!.path, 10, 0);
>>>>>>> upstream/master
    var result = images.map((file) => Image.file(file)).toList();
    setState(() {
      widget.images.addAll(result);
      _isClean = true;
    });
  }

  Future _getGifImages() async {
<<<<<<< HEAD
    final XFile? file =
    await _picker.pickImage(source: ImageSource.gallery);
=======
    final PickedFile? file =
        await _picker.getImage(source: ImageSource.gallery);
>>>>>>> upstream/master

    var images = await ExportVideoFrame.exportGifImage(file!.path, 0);
    var result = images.map((file) => Image.file(file)).toList();
    setState(() {
      widget.images.addAll(result);
      _isClean = true;
    });
  }

  Future _getImagesByDuration() async {
<<<<<<< HEAD
    final XFile? pickedFile =
    await _picker.pickVideo(source: ImageSource.gallery);
    final File file = File(pickedFile!.path);
    var duration = Duration(seconds: 1);
    var image =
    await ExportVideoFrame.exportImageBySeconds(file, duration, 0);
=======
    final PickedFile? pickedFile =
        await _picker.getImage(source: ImageSource.gallery);
    final File file = File(pickedFile!.path);
    var duration = Duration(seconds: 1);
    var image =
        await ExportVideoFrame.exportImageBySeconds(file, duration, pi / 2);
>>>>>>> upstream/master
    setState(() {
      widget.images.add(Image.file(image));
      _isClean = true;
    });
<<<<<<< HEAD
    
=======
>>>>>>> upstream/master
    await ExportVideoFrame.saveImage(image, "Video Export Demo",
        waterMark: "images/water_mark.png",
        alignment: Alignment.bottomLeft,
        scale: 2.0);
  }

  Future _cleanCache() async {
    var result = await ExportVideoFrame.cleanImageCache();
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

<<<<<<< HEAD

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
=======
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Export Image"),
      ),
      body: Container(
        padding: EdgeInsets.zero,
        child: Column(
          children: <Widget>[
>>>>>>> upstream/master
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
<<<<<<< HEAD
                      .map((image) => ImageItem(image: image))
                      .toList()
=======
                          .map((image) => ImageItem(image: image))
                          .toList()
>>>>>>> upstream/master
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
