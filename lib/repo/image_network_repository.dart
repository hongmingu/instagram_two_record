import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_two_record/repo/helper/image_helper.dart';

class ImageNetworkRepository {
  Future<TaskSnapshot?> uploadImageCreateNewPost(
      File originImage, {required String postKey}) async {
    try {
      final File resized = await compute(getResizedImage, originImage);
      final Reference storageReference =
          FirebaseStorage.instance.ref().child(_getImagePathByPostKey(postKey));
      final UploadTask uploadTask = storageReference.putFile(resized);
      return uploadTask.whenComplete(() => null);

      await Future.delayed(Duration(seconds: 3));
    } catch (e) {
      print(e.toString());
      print("Here Error");
      return null;
    }
  }

  String _getImagePathByPostKey(String postKey) {
    return 'post/$postKey/post.jpg';
  }

  Future<dynamic> getPostImageUrl(String postKey){
    print("kiki: ${FirebaseStorage.instance.ref().child(_getImagePathByPostKey(postKey)).getDownloadURL()}");
    return FirebaseStorage.instance.ref().child(_getImagePathByPostKey(postKey)).getDownloadURL();
  }

}

ImageNetworkRepository imageNetworkRepository = ImageNetworkRepository();
