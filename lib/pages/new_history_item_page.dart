import 'dart:io';

import 'package:eco_app_project/auth/user_model.dart';
import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/my_classes.dart';
import 'package:eco_app_project/yandex_map/location_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tflite/tflite.dart';

import '../auth/auth.dart';
import '../navigation.dart';

class NewHistoryItemPage extends StatefulWidget {
  const NewHistoryItemPage({this.image, Key? key}) : super(key: key);

  final image;

  @override
  State<NewHistoryItemPage> createState() => _NewHistoryItemPageState();
}


class _NewHistoryItemPageState extends State<NewHistoryItemPage> {
  late PickedFile? _file;
  late File _image;
  List<dynamic>? _outputs;
  String type_of_plant = "";
  final currentDate = DateTime.now();
  int currentPoints = 0;
  final ImagePicker _picker = ImagePicker();
  String? _input;
  bool _isLoading = false;
  int mPoints = 0;

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


    print('confidence: ${output![0]["confidence"]}');
    setState(() {
      _outputs = output;
      type_of_plant =
          _outputs![0]["label"].toString().substring(2).replaceAll('_', ' ');
      var list = type_of_plant.split(' ');
      var confidence = 100 * output[0]["confidence"];
    // });
      if(confidence < 0.7){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Navigation(),
            )
        );
        Fluttertoast.showToast(
          msg: 'Not a plant! Confidence: ${(confidence.round())}%',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );
      }
      else if(list[list.length - 1] == 'healthy'){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Navigation(),
            )
        );
        Fluttertoast.showToast(
          msg: 'The plant is healthy already!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );
      }
      print('my output: $type_of_plant');
    });
    currentPoints = await calculatePoints(type_of_plant);

    setState(() {
      mPoints = currentPoints;
    });
    print('my output: $type_of_plant; my points: $currentPoints');
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
                '${type_of_plant.split(' ').length > 2 ? '${type_of_plant.split(' ')[0]}_${type_of_plant.split(' ')[1]}' : type_of_plant.split(' ')[0]} = $mPoints points \n${DateFormat('EEEE, MMM d, yyyy').format(currentDate)}',
                maxLines: 2,
              ),
            ),
            _isLoading ? LinearProgressIndicator()
            : TextField(
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Input your plant\'s name',
              ),
              onChanged: (text) {
                _input = text;
              },
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

  Future<int> calculatePoints(String plantType) async {
    String name = type_of_plant.split(' ')[0];
    if(type_of_plant.split(' ').length > 2){
      name += '_${type_of_plant.split(' ')[1]}';
    }
    print("plants/$name");
    DatabaseReference ref = FirebaseDatabase.instance.ref("plants/$name");
    var data = await ref.get();
    var data2 = Map<String, dynamic>.from(data.value as Map);
    final plant = Plant.fromMap(data2);
    print(data2);
    return plant.rarity * 10;
  }

  Future<void> uploadData() async {
    setState(() {
      _isLoading = true;
    });
    
    String? uid = Auth().currentUser?.uid.toString();
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid");

    var result = await ref.get();
    final data = Map<String, dynamic>.from(result.value as Map);
    final myUser = MyUser.fromMap(data);


    await ref.update({
      "history_items": myUser.history_items + 1,
      "points": myUser.points + currentPoints,
      "was_today": true,
      "days_streak" : myUser.was_yesterday ? myUser.days_streak + 1 : 1,
    });

    DatabaseReference itemRef = FirebaseDatabase.instance.ref("history/$uid/${myUser.history_items}");


    Reference imgRef = FirebaseStorage.instance.ref("history/$uid/${myUser.history_items}");
    await imgRef.putFile(_image);
    String imageUri = await imgRef.getDownloadURL();

    final currentLocation = await LocationService().getCurrentLocation();

    final HistoryItem historyItem = HistoryItem(title: _input?.trim() ?? 'plant${myUser.history_items}', date: HistoryItem.getDate(currentDate), imageUri: imageUri, latLong: currentLocation.toString(), points: currentPoints);

    print(historyItem.toMap());

    await itemRef.set(historyItem.toMap());

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Navigation()));
  }
}