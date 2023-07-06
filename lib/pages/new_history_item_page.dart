import 'dart:io';

import 'package:eco_app_project/auth/user_model.dart';
import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/my_classes.dart';
import 'package:eco_app_project/yandex_map/location_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  late XFile? _file;
  late File _image;
  List<dynamic>? _outputs;
  String type_of_plant = "";
  final currentDate = DateTime.now();
  int currentPoints = 0;
  final _formKey = GlobalKey<FormState>();
  String? _input;
  String _input_description = '';
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

    // loadModel();
    // classifyImage(_image);
  }

  //Load the Tflite model
  // loadModel() async {
  //   var cur = await Tflite.loadModel(
  //     model: 'assets/model.tflite',
  //     labels: 'assets/labels.txt',
  //   );
  // }
  //
  // classifyImage(image) async {
  //   var output = await Tflite.runModelOnImage(
  //     path: image.path,
  //     numResults: 2,
  //     threshold: 0.5,
  //     imageMean: 127.5,
  //     imageStd: 127.5,
  //   );
  //
  //
  //   print('confidence: ${output![0]["confidence"]}');
  //   setState(() {
  //     _outputs = output;
  //     type_of_plant =
  //         _outputs![0]["label"].toString().substring(2).replaceAll('_', ' ');
  //     var list = type_of_plant.split(' ');
  //     var confidence = 100 * output[0]["confidence"];
  //   // });
  //
  //     /*
  //     if(confidence < 0.7){
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => Navigation(),
  //           )
  //       );
  //       Fluttertoast.showToast(
  //         msg: 'Not a plant! Confidence: ${(confidence.round())}%',
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.TOP,
  //         timeInSecForIosWeb: 1,
  //       );
  //     }
  //     else if(list[list.length - 1] == 'healthy'){
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => Navigation(),
  //           )
  //       );
  //       Fluttertoast.showToast(
  //         msg: 'The plant is healthy already!',
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.TOP,
  //         timeInSecForIosWeb: 1,
  //       );
  //     }
  //     */
  //     print('my output: $type_of_plant');
  //   });
  //   currentPoints = await calculatePoints(type_of_plant);
  //
  //   setState(() {
  //     mPoints = currentPoints;
  //   });
  //   print('my output: $type_of_plant; my points: $currentPoints');
  // }

  showPopupForm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Enter plant type'
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Enter plant name'
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Text("Upload"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 1.5 * kDefaultPadding),
              child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Форма',
                        style: TextStyle(
                          fontSize: kFontTitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.file(
                            _image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      _isLoading ? LinearProgressIndicator()
                          : TextField(
                        maxLines: 1,
                        maxLength: 30,
                        decoration: InputDecoration(
                          labelText: 'Вид растения',
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        onChanged: (text) {
                          _input = text;
                        },
                      ),
                      TextField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Описание болезни',
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        onChanged: (text) {
                          setState(() {
                            _input_description = text;
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: uploadData,
                        child: Text('Загрузить'),
                      )
                    ],
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<int> calculatePoints(String plantType) async {
    String name = type_of_plant.split(' ')[0];
    if(type_of_plant.split(' ').length > 2){
      name += '_${type_of_plant.split(' ')[1]}';
    }
    DatabaseReference ref = FirebaseDatabase.instance.ref("plants/$name");
    var data = await ref.get();
    var data2 = Map<String, dynamic>.from(data.value as Map);
    final plant = Plant.fromMap(data2);
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


    currentPoints = 100;
    await ref.update({
      "points": myUser.points + currentPoints,
      "was_today": true,
      "days_streak" : myUser.was_yesterday ? myUser.days_streak + 1 : 1,
    });

    String id = DateTime.now().millisecondsSinceEpoch.toString();

    DatabaseReference itemRef = FirebaseDatabase.instance.ref("history/$uid/${id}");


    Reference imgRef = FirebaseStorage.instance.ref("history/$uid/${id}");
    await imgRef.putFile(_image);
    String imageUri = await imgRef.getDownloadURL();

    final currentLocation = await LocationService().getCurrentLocation();

    final HistoryItem historyItem = HistoryItem(title: _input?.trim() ?? '${id}', date: HistoryItem.getDate(currentDate), imageUri: imageUri, latLong: currentLocation.toString(), points: currentPoints, description: _input_description, id: id);


    await itemRef.set(historyItem.toMap());

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Navigation()));
  }
}
