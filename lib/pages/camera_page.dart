import 'dart:io';

import 'package:camera/camera.dart';
import 'package:eco_app_project/constants.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({required this.cameras, Key? key}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late List<CameraDescription> cameras = widget.cameras;

  late CameraController cameraController;
  late Future<void> cameraValue;

  late Widget kWidget;

  @override
  void initState() {
    // startCamera();
    // TODO: implement initState
    super.initState();

    cameraController = CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
    cameraValue = cameraController.initialize();

    kWidget = Container(height: 50, width: 50, color: Colors.grey,);
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                return CameraPreview(cameraController);
              }
              else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }},
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: kWidget,
                  ),
                  FloatingActionButton.large(
                    child: Icon(Icons.camera),
                    onPressed: () async {
                      try {
                        // Ensure that the camera is initialized.
                        await cameraValue;

                        // Attempt to take a picture and then get the location
                        // where the image file is saved.
                        final image = await cameraController.takePicture();
                        print('my new image is at ${image.path}');
                        setState(() {
                          kWidget = Image.file(File(image.path), height: 80, width: 80, fit: BoxFit.cover,);
                        });
                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        print(e);
                      }
                    },
                  ),
                  SizedBox(
                    width: 100,
                    child: Text('This is a tree...'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
