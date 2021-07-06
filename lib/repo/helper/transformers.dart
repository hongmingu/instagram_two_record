import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_two_record/models/firestore/user_model.dart';

class Transformers {
  final toUser = StreamTransformer<DocumentSnapshot<Map<String, dynamic>>,
      UserModel>.fromHandlers(handleData: (snapshot, sink) async {
    sink.add(UserModel.fromSnapshot(snapshot));
  });

  final toUsersExceptMe = StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
      List<UserModel>>.fromHandlers(handleData: (snapshot, sink) async {
    List<UserModel> users = [];

    User? _firebaseUser = FirebaseAuth.instance.currentUser;

    snapshot.docs.forEach((documentSnapshot) {
      if (_firebaseUser!.uid != documentSnapshot.id) {
        users.add(UserModel.fromSnapshot(documentSnapshot));
      }
    });
    sink.add(users);
  });
}
