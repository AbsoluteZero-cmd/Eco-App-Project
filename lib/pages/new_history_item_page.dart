import 'dart:io';

import 'package:camera/camera.dart';
import 'package:eco_app_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
  final currentDate = DateTime.now();
  int currentPoints = 0;



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
      _outputs = output;
      res = _outputs![0]["label"];
      print('my output: ${res}');
    });

    currentPoints = calculatePoints(res);

    print('my output: ${res}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding * 1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plant\'s form',
              style: TextStyle(
                fontSize: kFontTitle,
                fontWeight: FontWeight.bold,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.file(
                _image,
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              child: Text(
                '${res} = ${currentPoints} points \n${DateFormat('EEEE, MMM d, yyyy').format(currentDate)}',
                maxLines: 2,
              ),
            ),
            TextField(
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Input your plant\'s name',
              ),
            ),
            ElevatedButton(
              onPressed: uploadData,
              child: Text('Upload'),
            )
          ],
        ),
      ),
    );
  }

  int calculatePoints(String plant_type) {
    return 30;
  }

  void uploadData() {
  }
}