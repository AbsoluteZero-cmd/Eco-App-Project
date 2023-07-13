import 'dart:io';

import 'package:eco_app_project/auth/user_model.dart';
import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/my_classes.dart';
import 'package:eco_app_project/yandex_map/location_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  String type_of_plant = "";
  final currentDate = DateTime.now();
  int currentPoints = 0;
  String? _input;
  String _input_description = '';
  bool _isLoading = false;
  int mPoints = 0;

  final List<XFile>? imagefiles = [];


  @override
  void initState(){
    super.initState();
    _file = widget.image;
    imagefiles!.add(_file!);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.photo_camera),
        onPressed: addNewImage,
        heroTag: "btn2",
      ),
      body: Padding(
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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                  child: getImagesGrid()
                ),
                TextField(
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
                _isLoading ? LinearProgressIndicator() : ElevatedButton(
                  onPressed: uploadData,
                  child: Text('Загрузить'),
                )
              ],
            )
        ),
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
    Reference imgRef = FirebaseStorage.instance.ref("history/$uid/${id}");
    List<String> imageUris = [];
    for(int i = 0; i < imagefiles!.length; i++){
      Reference currentRef = imgRef.child(imagefiles![i].name);
      await currentRef.putFile(File(imagefiles![i].path));
      String imageUri = await currentRef.getDownloadURL();
      imageUris.add(imageUri);
    }


    final currentLocation = await LocationService().getCurrentLocation();
    final HistoryItem historyItem = HistoryItem(title: _input?.trim() ?? '${id}', date: HistoryItem.getDate(currentDate), imageUris: imageUris, latLong: currentLocation.toString(), points: currentPoints, description: _input_description, id: id);
    DatabaseReference itemRef = FirebaseDatabase.instance.ref("history/$uid/${id}");
    await itemRef.set(historyItem.toMap());

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Navigation()));
  }

  Widget getImagesGrid(){
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: SingleChildScrollView(
        child: imagefiles != null ? Wrap(
          alignment: WrapAlignment.spaceBetween,
          runAlignment: WrapAlignment.spaceBetween,
          children: imagefiles!.map((image){
            return Card(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                padding: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: AspectRatio(
                    aspectRatio: 7 / 9,
                    child: Image.file(File(image.path))),
              ),
            );
          }).toList(),
        ):Container(),
      ),
    );
  }

  Future<void> addNewImage() async {
    XFile? newImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if(newImage == null) return;

    setState(() {
      imagefiles!.add(newImage);
    });
  }
}
