import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:instagram_two_record/constants/screen_size.dart';
import 'package:instagram_two_record/models/camera_state.dart';
import 'package:instagram_two_record/models/user_model_state.dart';
import 'package:instagram_two_record/repo/helper/generate_post_key.dart';
import 'package:instagram_two_record/screens/share_post_screeen.dart';
import 'package:instagram_two_record/widgets/my_progress_indicator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class TakePhoto extends StatefulWidget {
  const TakePhoto({
    Key? key,
  }) : super(key: key);

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  Widget _progress = MyProgressIndicator(
      containerSize: size.width, progressSize: size.width * 0.08);

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraState>(
      builder: (BuildContext context, CameraState cameraState, Widget? child) {
        return Column(
          children: [
            (cameraState.isReadyToTakePhoto)
                ? _getPreview(cameraState)
                : Container(
                    width: size.width,
                    height: size.width,
                    color: Colors.red,
                    child: _progress,
                  ),
            Expanded(
              child: OutlineButton(
                shape: CircleBorder(),
                borderSide: BorderSide(color: Colors.black12, width: 20),
                onPressed: () {
                  if (cameraState.isReadyToTakePhoto) {
                    _attemptTakePhoto(cameraState, context);
                  }
                },
              ),
            )
          ],
        );
      },
    );
  }

  Widget _getPreview(CameraState cameraState) {
    CameraController _controller = cameraState.controller;
    return Container(
      width: size.width,
      height: size.width,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Container(
              width: size.width,
              height: size.width * _controller.value.aspectRatio,
              child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: CameraPreview(_controller)),
            ),
          ),
        ),
      ),
    );
  }

  void _attemptTakePhoto(CameraState cameraState, BuildContext context) async {
    final String postKey =
        getNewPostKey(Provider.of<UserModelState>(context, listen: false).userModel);
    final String timeInMilli = DateTime.now().microsecondsSinceEpoch.toString();
    try {
      final path = join((await getTemporaryDirectory()).path, "$postKey.png");

      XFile picture = await cameraState.controller.takePicture();
      picture.saveTo(path);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SharePostScreen(
                File(path),
                postKey: postKey,
              )));
    } catch (e) {
      print("Error: " + e.toString());
    }
  }
}

/*
* Container(
              width: size.width,
              height: size.width,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      width: size.width,
                      height: size.height,
                      child: AspectRatio(
                          aspectRatio: size.height/size.width,
                          child: CameraPreview(_controller)),
                    ),
                  ),
                ),
              ),
            );
*
* */
