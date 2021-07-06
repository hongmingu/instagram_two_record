import 'dart:io';
import 'package:image/image.dart';


File getResizedImage(File originImage){
  Image? image = decodeImage(originImage.readAsBytesSync());
  Image resizedImage = copyResizeCropSquare(image!, 300);

  // png 가 3이라서 3을 뺀다.
  File resizedFile = File(originImage.path.substring(0, originImage.path.length-3)+"jpg");
  resizedFile.writeAsBytesSync(encodeJpg(resizedImage, quality: 50));
  return resizedFile;

}