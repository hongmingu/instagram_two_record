import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraState extends ChangeNotifier{
  late CameraController _controller;
  late CameraDescription _cameraDescription;
  bool _readyTakePhoto = false;

  void getReadyToTakePhoto() async{
    List<CameraDescription> cameras = await availableCameras();
    if (cameras != null && cameras.isNotEmpty){
      setCameraDescription(cameras[0]);

    }
    bool init = false;
    while (!init){
      init = await initialize();
    }

    _readyTakePhoto = true;
    notifyListeners();
  }


  @override
  void dispose() {
    _controller.dispose();
    _readyTakePhoto = false;
    notifyListeners();
    super.dispose();
  }

  void setCameraDescription(CameraDescription cameraDescription){
    _cameraDescription = cameraDescription;
    _controller = CameraController(_cameraDescription, ResolutionPreset.max);
  }

  Future<bool> initialize() async{
    try {
      await _controller.initialize();
      return true;
    } catch(e){
      return false;
    }
  }

  CameraController get controller => _controller;
  CameraDescription get description => _cameraDescription;
  bool get isReadyToTakePhoto => _readyTakePhoto;
}