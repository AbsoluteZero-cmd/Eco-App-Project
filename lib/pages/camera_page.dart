import 'package:camera/camera.dart';
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

  @override
  void initState() {
    // startCamera();
    // TODO: implement initState
    super.initState();

    cameraController = CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
    cameraValue = cameraController.initialize();
  }

  void startCamera() async {
    cameras = await availableCameras();

    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController.initialize().then((value) {
      if(!mounted) {
        print('not mounted');
        return;
      }
      setState(() {}); //To refresh widget
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if(cameraController.value.isInitialized){
      return Scaffold(
        body: Stack(
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
                }
              },
            )
          ],
        ),
      );
    // }
    // else{
    //   return SizedBox();
    // }
  }
}
