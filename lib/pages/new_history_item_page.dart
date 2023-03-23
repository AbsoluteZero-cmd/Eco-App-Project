import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class NewHistoryItemPage extends StatefulWidget {
  const NewHistoryItemPage({Key? key, required this.image}) : super(key: key);

  final XFile image;

  @override
  State<NewHistoryItemPage> createState() => _NewHistoryItemPageState();
}

class _NewHistoryItemPageState extends State<NewHistoryItemPage> {
  bool isPlanted = false;
  List _results = ['nothing yet'];

  @override
  void initState(){
    super.initState();
    // loadModel();
    // imageClassification();
  }

  // Future loadModel() async {
  //   Tflite.close();
  //
  //   Future<String?> res = Tflite.loadModel(model: 'assets/tflite_model/model_float.tflite', labels: 'assets/tflite_model/labels.txt');
  //   print('models loading status: ${res}');
  // }
  //
  // Future imageClassification() async {
  //   var recognition = Tflite.runModelOnImage(
  //     path: widget.image.path,
  //     // numResults: 3,
  //     // threshold: 0.05,
  //     // imageMean: 127.5,
  //     // imageStd: 127.5,
  //   );
  //
  //   print('my results: ${recognition}');
  //
  //   setState(() {
  //     _results = recognition as List;
  //     print('my results: ${_results[0]}');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.file(File(widget.image.path), height: 150, width: 150, fit: BoxFit.cover),
          for(var item in _results) Text(item)
        ],
      ),
    );
  }
}
