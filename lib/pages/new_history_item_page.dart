import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class NewHistoryItemPage extends StatefulWidget {
  const NewHistoryItemPage({this.image, Key? key}) : super(key: key);

  final image;

  @override
  State<NewHistoryItemPage> createState() => _NewHistoryItemPageState();
}


class _NewHistoryItemPageState extends State<NewHistoryItemPage> {
  late PickedFile? _file;
  late File _image;
  bool _loading = false;
  List<dynamic>? _outputs;
  String res = "no results yet";


  final ImagePicker _picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    _file = widget.image;

    if (_file != null) {
      setState(() {
        _image = File(_file!.path);
      });
    }

    loadModel();
    classifyImage(_image);
  }

  //Load the Tflite model
  loadModel() async {
    var cur = await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  classifyImage(image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );


    setState(() {
      _loading = false;
      //Declare List _outputs in the class which will be used to show the classified class name and confidence
      _outputs = output;
      res = _outputs![0]["label"];
      print('my output: ${res}');
    });

    print('my output: ${res}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(_image),
          Text(res),
        ],
      ),
    );
  }
}