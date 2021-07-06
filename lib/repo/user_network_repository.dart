import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_two_record/constants/firestore_keys.dart';
import 'package:instagram_two_record/models/firestore/user_model.dart';
import 'package:instagram_two_record/repo/helper/transformers.dart';

class UserNetworkRepository with Transformers {
  late Stream<UserModel> _stream;

  Future<void> sendData() {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc("123123123")
        .set({"email": "testing@gmail.com", "username": "myUsername"});
  }

  Future<void> attemptCreateUser({String? userKey, String? email}) async {
    final DocumentReference userRef =
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(userKey);
    DocumentSnapshot snapshot = await userRef.get();
    if (!snapshot.exists) {
      return await userRef.set(UserModel.getMapForCreateUser(email));
    }
  }

  void getData() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc("123123123")
        .get()
        .then((docSnapshot) => print(docSnapshot.data()));
  }

  late Query<UserModel> _usersQuery;
  late DocumentReference<Object?> _usersDoc;
  late Stream<DocumentSnapshot<Object?>> _userModel;
  late CollectionReference<UserModel> _userRef;

  void getUserRef(userKey) {
    _userRef = FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .withConverter<UserModel>(
          fromFirestore: (snapshots, _) =>
              UserModel.fromJson(snapshots.data()!, userKey),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  void getSnapshots(String userKey) {
    _usersDoc =
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(userKey);
    _userModel = _usersDoc.snapshots();

    // StreamBuilder<DocumentSnapshot<Object?>>(
    //     stream: _userModel, builder: (context, snapshot) {
    //
    // });
  }

  Stream<UserModel> getUserModelStream(String userKey) {
    print("skdisk");
    _stream = FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(userKey)
        .snapshots()
        .transform(toUser);

    return _stream;
  }

  Stream<List<UserModel>> getAllUserWithoutMe() {
    return FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .snapshots()
        .transform(toUsersExceptMe);
  }

  followUser({required String myUserKey, required String otherUserKey}) async {
    final DocumentReference myUserRef =
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(myUserKey);

    final DocumentSnapshot mySnapShot = await myUserRef.get();
    final DocumentReference otherUserRef = FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(otherUserKey);
    final DocumentSnapshot otherSnapShot = await otherUserRef.get();

    FirebaseFirestore.instance.runTransaction((transaction) async {
      if (mySnapShot.exists && otherSnapShot.exists) {
        await transaction.update(
          myUserRef,
          {
            KEY_FOLLOWINGS: FieldValue.arrayUnion([otherUserKey]),
          },
        );

        int currentFollowers =
            (otherSnapShot.data() as Map<String, dynamic>)[KEY_FOLLOWERS];
        print((otherSnapShot.data() as Map<String, dynamic>));
        await transaction.update(
          otherUserRef,
          {
            KEY_FOLLOWERS: currentFollowers + 1,
          },
        );
      }
    });
  }
  unFollowUser({required String myUserKey, required String otherUserKey}) async {
    final DocumentReference myUserRef =
        FirebaseFirestore.instance.collection(COLLECTION_USERS).doc(myUserKey);

    final DocumentSnapshot mySnapShot = await myUserRef.get();
    final DocumentReference otherUserRef = FirebaseFirestore.instance
        .collection(COLLECTION_USERS)
        .doc(otherUserKey);
    final DocumentSnapshot otherSnapShot = await otherUserRef.get();

    FirebaseFirestore.instance.runTransaction((transaction) async {
      if (mySnapShot.exists && otherSnapShot.exists) {
        await transaction.update(
          myUserRef,
          {
            KEY_FOLLOWINGS: FieldValue.arrayRemove([otherUserKey]),
          },
        );

        int currentFollowers =
            (otherSnapShot.data() as Map<String, dynamic>)[KEY_FOLLOWERS];
        print((otherSnapShot.data() as Map<String, dynamic>));

        await transaction.update(
          otherUserRef,
          {
            KEY_FOLLOWERS: currentFollowers - 1,
          },
        );
      }
    });
  }
}

UserNetworkRepository userNetworkRepository = UserNetworkRepository();
