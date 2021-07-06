import 'package:flutter/material.dart';

class MyProgressIndicator extends StatelessWidget {

  final double containerSize;
  final double progressSize;
  MyProgressIndicator({Key? key, required this.progressSize, required this.containerSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: containerSize,
        height: containerSize,
        child: Center(
            child: SizedBox(
                height: progressSize,
                width: progressSize,
                child: Image.asset("assets/images/loading_img.gif"))));
  }
}
